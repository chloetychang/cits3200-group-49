# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system deps (needed for psycopg2 etc.)
RUN apt-get update && apt-get install -y \
    build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first (for layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Start FastAPI
CMD ["python", "-m", "uvicorn", "App.main:app", "--host", "0.0.0.0", "--port", "8000"]
