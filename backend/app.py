from flask import Flask, request, jsonify, render_template, send_from_directory
import os
from dotenv import load_dotenv
from openai import OpenAI
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_socketio import SocketIO, emit
import re
import json
from generateXML import generateXML 

# Load environment variables from .env file
load_dotenv()

# Initialize the Flask app and required extensions
app = Flask(__name__, static_folder='frontend/build')
CORS(app)  # Enable CORS for the React frontend
app.config['SECRET_KEY'] = os.getenv('OPENAI_API_KEY')

# Initialize SocketIO for real-time communication
socketio = SocketIO(app, cors_allowed_origins="*")

# Initialize SQLAlchemy for SQLite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///form_data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

INITIAL_FIELDS = [
    'Data',
    'KodUrzedu',
    'PESEL',
    'ImiePierwsze',
    'Nazwisko',
    'DataUrodzenia',
    'KodKraju',
    'Wojewodztwo',
    'Powiat',
    'Gmina',
    'NrDomu',
    'Miejscowosc',
    'KodPocztowy',
]

# Serve React frontend from the build directory
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_react_app(path):
    if path != "" and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    else:
        return send_from_directory(app.static_folder, 'index.html')


def printDB():
    # Query all the entries from the database
    entries = FormData.query.all()

    # Create a dictionary with field_name as keys and value as values
    db_dict = {entry.field_name: entry.value for entry in entries}

    # Print the dictionary to the console
    print(db_dict)

    # Return the dictionary
    return db_dict

# Function to initialize the database and seed it
def seed_database():
    db.session.query(FormData).delete()
    db.session.commit()
    for field_name in INITIAL_FIELDS:
        if not FormData.query.filter_by(field_name=field_name).first():
            db.session.add(FormData(field_name=field_name, value=''))
    db.session.commit()

class FormData(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    field_name = db.Column(db.String(100), nullable=False)
    value = db.Column(db.String(100), nullable=False)

    def __init__(self, field_name, value):
        self.field_name = field_name
        self.value = value

openai_api_key = os.getenv('OPENAI_API_KEY')
if not openai_api_key:
    raise ValueError("OPENAI_API_KEY is not set")

client = OpenAI(api_key=openai_api_key)

def getMissingFields():
    missing_fields = FormData.query.filter(FormData.value == '').all()
    return [entry.field_name for entry in missing_fields]

def update_using_assistant(user_input):
    missing_info = ', '.join(getMissingFields())
    conversation_history = [
        {"role": "system", "content": f"""
        You are not a chat assistant, rather, you help me parse the information provided by the user. The message could be in english, polish, or ukrainian. 
         Help me understand what information the user provided. 
         I am interested to see if the user provided any of the missing information (note the list could contain only one item): {missing_info}.
         output a json formatted dictionary of field_name:value, where field_name is one of the strings from the above list, and value
         is the value provided by the user.
         For example imagine the message from the user was: moj Pesel to 292347428, imie Ania, nazwisko Dabrowska.
         And that the missing information is PESEL, Name, Street, City.
         Then you should output "PESEL":"292347428", "Name":"Ania".
         Note: you dont output her surname as it is not a missing information. And you dont output Street or City since that information was not provided.
         Now I will send you the message, output only a json formatted dictionary!
        """},
        {"role": "user", "content": user_input}
    ]

    chat_completion = client.chat.completions.create(
        model="gpt-4-turbo",
        messages=conversation_history,
        max_tokens=150
    )

    response_dict = chat_completion.to_dict()
    message_content = response_dict['choices'][0]['message']['content']

    try:
        parsed_values = json.loads(message_content)
    except json.JSONDecodeError:
        print("Failed to parse the response into JSON.")
        return

    for field_name, value in parsed_values.items():
        existing_entry = FormData.query.filter_by(field_name=field_name).first()
        if existing_entry:
            existing_entry.value = value
        else:
            new_entry = FormData(field_name=field_name, value=value)
            db.session.add(new_entry)
        print("Wysylam do bazy danych: "+ field_name + " " + value)
        socketio.emit('new_entry', {'field_name': field_name, 'value': value})

    db.session.commit()  # Commit changes to the database
    print(getMissingFields())

def doneMessage():
    entries = FormData.query.all()

    socketio.emit('xml_ready')

    thank_you_message = "Dziekuję, to wszystkie dane które potrzebowałem.\n\nWpisałem je do formularza, proszę sprawdzić czy są poprawne.\nJeśli tak, przejdźmy do dokładniejszego omówienia sprawy."

    seed_database()

    return thank_you_message


@app.route('/api/get_xml', methods=['GET'])
def get_xml():
    if(getMissingFields()==[]):
        xml = generateXML(printDB())
        print("returning " + xml)
        return jsonify({'response':xml})
    else:
        print("returning none")
        return jsonify({'response':"none"})


# Funkcja do interpretowania odpowiedzi użytkownika i generowania dynamicznej odpowiedzi
@app.route('/api/chat_assistant', methods=['POST'])
def chat_assistant():
    printDB()
    user_input = request.json.get('input', '')

    update_using_assistant(user_input)

    missing_info = ', '.join(getMissingFields())

    if(missing_info==""):
        return jsonify({'response':doneMessage()})

    conversation_history = [
        {"role": "system", "content": f"""
        You are a tax assistant AI developed to help users complete the PCC-3 form. You will be answering in 
         polish, english, or ukrainian, depending on the language of the user. It is important that you detect and
         switch to the language of the user.
        You can only help the user if you ask him/her for the information you need to fill in the form.
         Say please in the user's language and be polite, but concise. 
         Don't greet them and don't ask for any other details apart from the ones you will get in the specification now. Assume that this
         conversation has already been going.
        Here is the specification, a comma separated list of fields about which you need to 
         politely ask the user: {missing_info}. If a lot of data is missing, try to ask broader questions. If there
         are fewer than 5 or so missing fields, you can ask more directly.
        """},
        {"role": "user", "content": user_input}
    ]

    # Wywołanie OpenAI API z kontekstem rozmowy
    chat_completion = client.chat.completions.create(
        model="gpt-4-turbo",
        messages=conversation_history,
        max_tokens=150
    )

    # Pobranie odpowiedzi z OpenAI
    response_dict = chat_completion.to_dict()
    message_content = response_dict['choices'][0]['message']['content']

    return jsonify({'response': message_content})

# Funkcja pomocnicza do wyciągania wartości z odpowiedzi
def extract_value_from_text(text, field_name):
    if field_name == "PESEL":
        match = re.search(r'\b\d{11}\b', text)
        if match:
            return match.group(0)
    return None

# Endpoint do zapisywania wartości w bazie danych
@app.route('/api/store', methods=['POST'])
def store_value():
    data = request.json
    field_name = data.get('field_name')
    value = data.get('value')

    if not field_name or not value:
        return jsonify({"error": "Missing field_name or value"}), 400

    new_entry = FormData(field_name, value)
    db.session.add(new_entry)
    db.session.commit()

    # Emitowanie nowego wpisu przez WebSocket
    socketio.emit('new_entry', {'field_name': field_name, 'value': value})

    return jsonify({"message": f"Zapisano {field_name}: {value}"}), 200

# Endpoint do pobierania wartości z bazy danych
@app.route('/api/get', methods=['GET'])
def get_value():
    field_name = request.args.get('field_name')
    entry = FormData.query.filter_by(field_name=field_name).first()

    if entry:
        return jsonify({"field_name": entry.field_name, "value": entry.value}), 200
    else:
        return jsonify({"error": f"Nie znaleziono wartości dla {field_name}"}), 404


# Initialize the database before running the app
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        seed_database()
    socketio.run(app, debug=True, host='0.0.0.0', port=5000)
