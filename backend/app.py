from flask import Flask, request, jsonify, render_template
import os
from dotenv import load_dotenv
from openai import OpenAI
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_socketio import SocketIO, emit  # Nowe importy
import re

# Załaduj zmienne środowiskowe z pliku .env
load_dotenv()

app = Flask(__name__)
CORS(app)  # Umożliwienie zapytań między frontendem (React) a backendem (Flask)

# Konfiguracja WebSocket
app.config['SECRET_KEY'] = 'your_secret_key'
socketio = SocketIO(app)  # SocketIO dla komunikacji w czasie rzeczywistym

# Konfiguracja SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///form_data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Model bazy danych do przechowywania danych z formularza
class FormData(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    field_name = db.Column(db.String(100), nullable=False)
    value = db.Column(db.String(100), nullable=False)

    def __init__(self, field_name, value):
        self.field_name = field_name
        self.value = value

# Pobierz klucz API OpenAI z pliku .env
openai_api_key = os.getenv('OPENAI_API_KEY')
if not openai_api_key:
    raise ValueError("OPENAI_API_KEY is not set")

client = OpenAI(api_key=openai_api_key)

# Funkcja do interpretowania odpowiedzi użytkownika i generowania dynamicznej odpowiedzi
@app.route('/api/openai', methods=['POST'])
def openai_api():
    user_input = request.json.get('input', '')

    conversation_history = [
        {"role": "system", "content": """
        You are a tax assistant AI developed to help users complete the PCC-3 form, 
        a tax form related to the tax on civil law transactions in Poland, 
        such as the purchase of a car or a private loan. Your main responsibilities are:
        - Asking users simple and intuitive questions to gather the necessary data for the form.
        - Guiding users through the form completion process in Polish, and optionally in English or Ukrainian.
        - Filling out the PCC-3 form based on user input and generating a valid XML document compliant with the XSD schema.
        - Ensuring that tax calculations are correct and based on the latest tax regulations.
        - Providing users with relevant explanations on taxes, based on publicly available data from sources such as the Ministry of Finance website.
        - Safeguarding the user’s data and ensuring secure handling of personal information.
        - Avoiding topics unrelated to taxes and ending the conversation if such topics arise.
        """},
        {"role": "user", "content": user_input}
    ]

    # Wywołanie OpenAI API z kontekstem rozmowy
    chat_completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=conversation_history,
        max_tokens=150
    )

    # Pobranie odpowiedzi z OpenAI
    response_dict = chat_completion.to_dict()
    message_content = response_dict['choices'][0]['message']['content']

    # Opcjonalnie: Wyłapanie wartości takich jak PESEL, imię, nazwisko
    if 'PESEL' in user_input or 'PESEL' in message_content:
        pesel_value = extract_value_from_text(user_input, "PESEL")
        if pesel_value:
            new_entry = FormData(field_name='PESEL', value=pesel_value)
            db.session.add(new_entry)
            db.session.commit()

            # Emitowanie nowych danych do WebSocket
            socketio.emit('new_entry', {'field_name': 'PESEL', 'value': pesel_value})

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

# Strona do wyświetlania wpisów na żywo
@app.route('/live_entries')
def live_entries():
    return render_template('live_entries.html')

# Zainicjuj bazę danych przed uruchomieniem aplikacji
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    socketio.run(app, debug=True, host='0.0.0.0', port=5000)
