from flask import Flask, request, jsonify
import os
from dotenv import load_dotenv
from openai import OpenAI
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

# Załaduj zmienne środowiskowe z pliku .env
load_dotenv()

app = Flask(__name__)
CORS(app)  # Umożliwienie zapytań między frontendem (React) a backendem (Flask)

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

# Endpoint do komunikacji z OpenAI
@app.route('/api/openai', methods=['POST'])
def openai_api():
    user_input = request.json.get('input', '')

    # Wywołanie OpenAI API
    chat_completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": user_input}],
        max_tokens=150
    )

    # Pobranie odpowiedzi z OpenAI
    response_dict = chat_completion.to_dict()
    message_content = response_dict['choices'][0]['message']['content']

    # Opcjonalnie: Zapisz odpowiedź do bazy danych (np. pytanie PESEL)
    if 'PESEL' in user_input:
        new_entry = FormData(field_name='PESEL', value=message_content)
        db.session.add(new_entry)
        db.session.commit()

    return jsonify({'response': message_content})

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

if __name__ == '__main__':
    # Zainicjuj bazę danych przed uruchomieniem aplikacji
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=5000)
