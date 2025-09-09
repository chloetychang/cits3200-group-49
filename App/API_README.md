# Yanchep Plant Database API

A FastAPI application for managing plant genetic sources, plantings, and related botanical data.

## Project Structure

```
Backend/
├── main.py              # FastAPI application entry point
├── models.py            # SQLAlchemy database models
├── schemas.py           # Pydantic schemas for request/response validation
├── crud.py              # Database CRUD operations
├── database.py          # Database connection and session management
├── config.py            # Application configuration settings
├── requirements.txt     # Python dependencies
└── readme.txt           # This file
```

## Setup Instructions

### Prerequisites
- Python 3.8+
- PostgreSQL database
- Virtual environment (already set up)

### Database Configuration

Before running the application, update the database connection settings in `config.py` or set environment variables:

```bash
# Environment variables (recommended)
export DATABASE_HOST="your_host"
export DATABASE_PORT="5432"
export DATABASE_NAME="your_database_name"
export DATABASE_USER="your_username"
export DATABASE_PASSWORD="your_password"
```

Or modify the placeholder values in `config.py`.

### Installation

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Ensure your PostgreSQL database is running and accessible.

3. Run the application:
```bash
python main.py
```

The API will be available at `http://localhost:8000`

### API Documentation

Once the application is running, you can access:
- Interactive API docs: `http://localhost:8000/docs`
- Alternative API docs: `http://localhost:8000/redoc`