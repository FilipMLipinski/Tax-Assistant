# Stage 1: Build the React frontend
FROM node:16-alpine AS build-frontend

# Set working directory
WORKDIR /app/frontend

# Install dependencies and build the React app
COPY frontend/package.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Build the Flask backend
FROM python:3.10-slim AS build-backend

# Set working directory
WORKDIR /app

# Copy the backend code
COPY backend/ .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy built frontend to backend static files
COPY --from=build-frontend /app/frontend/build /app/frontend/build

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Expose the Flask port
EXPOSE 5000

# Start the Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
