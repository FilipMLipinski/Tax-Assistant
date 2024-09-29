# Tax Assistant - Formularz PCC-3

Tax Assistant to aplikacja webowa wspierana przez sztuczną inteligencję, która pomaga użytkownikom w wypełnianiu formularza PCC-3, wymaganego do zgłoszenia podatku od czynności cywilnoprawnych w Polsce. Aplikacja jest w pełni zintegrowana z OpenAI (GPT-4) i obsługuje wielojęzyczne interakcje z użytkownikami, generując gotowe pliki XML na podstawie wprowadzonych danych.

## 🚀 Funkcjonalności

- **Interaktywny Chatbot AI**: Chatbot prowadzi użytkownika przez proces wypełniania formularza PCC-3, zbierając niezbędne dane.
- **Generowanie XML**: Na podstawie danych zebranych przez chatbota, aplikacja generuje dokument XML zgodny ze schematem XSD.
- **Komunikacja w czasie rzeczywistym**: Wykorzystanie WebSocket (Socket.IO) do komunikacji między backendem a frontendem.
- **Dockerized**: Aplikacja jest w pełni zdockerowana, co umożliwia łatwe wdrażanie i uruchamianie na różnych platformach.

## 🛠️ Technologie

- **Backend**: Flask (Python), SQLAlchemy, Flask-SocketIO, Flask-CORS
- **Frontend**: React (Node.js)
- **AI**: OpenAI GPT-4
- **Baza danych**: SQLite
- **Konteneryzacja**: Docker
- **Inne**: WebSockets, REST API, Webpack

## 📋 Jak działa aplikacja?

1. Użytkownik odwiedza stronę aplikacji i rozpoczyna interakcję z chatbotem.
2. Chatbot zadaje pytania dotyczące formularza PCC-3 i zbiera odpowiednie dane.
3. Dane są zapisywane w lokalnej bazie danych SQLite.
4. Po zebraniu wszystkich wymaganych informacji, aplikacja generuje plik XML zgodny z formatem PCC-3.
5. Użytkownik może pobrać wygenerowany plik XML.

## 📦 Instalacja

Aby uruchomić aplikację lokalnie:

1. **Sklonuj repozytorium**:
   ```bash
   git clone https://github.com/your-username/Tax-Assistant.git
   cd Tax-Assistant
   ```

2. **Zbuduj obrazy Dockera**:
   ```bash
   docker build -t tax-assistant .
   ```

3. **Uruchom kontener**:
   ```bash
   docker run -p 5000:5000 tax-assistant
   ```

4. **Otwórz przeglądarkę i wejdź na adres**:
   ```
   http://localhost:5000
   ```

## 🐳 Konteneryzacja z Docker

Projekt jest zdockerowany, co oznacza, że możesz łatwo uruchomić aplikację na dowolnej platformie wspierającej Docker. Zarówno backend (Flask), jak i frontend (React) są zbudowane w jednym obrazie.

**Dockerfile**:
- Używa wieloetapowego buildu, aby najpierw zbudować aplikację frontendową React, a następnie zintegrować ją z backendem Flask.

## 🔧 Konfiguracja .env

Stwórz plik `.env` w katalogu głównym projektu z następującymi zmiennymi środowiskowymi:

```bash
OPENAI_API_KEY=your_openai_api_key
FLASK_ENV=development
SECRET_KEY=your_secret_key
```

## 📜 Schemat Generowania XML

Aplikacja generuje plik XML na podstawie danych zebranych od użytkownika i zapisanych w bazie danych. Schemat XSD służy jako podstawa do walidacji i generowania poprawnych danych.

## ✨ Przyszłe Rozwój

- [ ] Dodanie obsługi bardziej zaawansowanych formularzy podatkowych.
- [ ] Lepsza integracja z systemami rządowymi (np. ePUAP).
- [ ] Ulepszenie mechanizmów walidacji danych.


## 📄 Licencja

Projekt jest dostępny na licencji MIT.
