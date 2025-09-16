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

### 1. Python Virtual Environment Setup

First, set up a Python virtual environment to isolate project dependencies:

```bash
# Navigate to your desired directory (can be outside project or inside with .gitignore)
python -m venv venv

# Activate the virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate
```

You should see `(venv)` in your terminal prompt when the environment is active.

### 2. Install Dependencies

With your virtual environment activated:
```bash
pip install -r requirements.txt
```

### 3. Environment Variables Configuration

Create a `.env` file in the `App` directory with your database credentials:

```env
# Database configuration
DATABASE_HOST=localhost
DATABASE_PORT=your_port
DATABASE_NAME=your_database_name
DATABASE_USER=your_username
DATABASE_PASSWORD=your_password
```

### 4. Database Setup

Ensure your PostgreSQL database is running and accessible with the credentials specified in your `.env` file.

### 5. Run the Application

With your virtual environment activated and environment variables configured:
```bash
python main.py
```

The API will be available at `http://localhost:8000`

### API Documentation

Once the application is running, you can access:
- Interactive API docs: `http://localhost:8000/docs`
- Alternative API docs: `http://localhost:8000/redoc`