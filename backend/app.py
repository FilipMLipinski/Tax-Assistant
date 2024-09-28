import os
from flask import Flask, request, jsonify
from openai import OpenAI
from dotenv import load_dotenv

# Załaduj zmienne środowiskowe z pliku .env
load_dotenv()

app = Flask(__name__)

# Pobierz klucz API z zmiennej środowiskowej
openai_api_key = os.getenv('OPENAI_API_KEY')
if not openai_api_key:
    raise ValueError("OPENAI_API_KEY is not set")

client = OpenAI(api_key=openai_api_key)

@app.route('/api/openai', methods=['POST'])
def openai_api():
    user_input = request.json.get('input', '')

    # Wywołanie OpenAI API
    chat_completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": user_input}],
        max_tokens=150
    )

    response_dict = chat_completion.to_dict()
    message_content = response_dict['choices'][0]['message']['content']

    return jsonify({'response': message_content})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
