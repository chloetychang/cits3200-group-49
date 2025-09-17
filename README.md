# Botanic Guide - A Tool for Garden Planters

A new Flutter project.

## Project Overview

This project consists of:
- **Frontend**: Flutter web application
- **Backend**: FastAPI Python application
- **Database**: PostgreSQL

## Backend API Setup

### Prerequisites
- Python 3.8+
- PostgreSQL database

### Quick Setup

1. **Create Python Virtual Environment**
   ```bash
   python -m venv venv
   
   # Activate virtual environment
   # Windows:
   venv\Scripts\activate
   # macOS/Linux:
   source venv/bin/activate
   ```

2. **Install Dependencies**
   ```bash
   cd App
   pip install -r requirements.txt
   ```

3. **Configure Environment Variables**
   
   Create `App/.env` file:
   ```env
   DATABASE_HOST=localhost
   DATABASE_PORT=5432
   DATABASE_NAME=your_database_name
   DATABASE_USER=your_username
   DATABASE_PASSWORD=your_password
   ```

4. **Run the API**
   ```bash
   python main.py
   ```
   
   API will be available at `http://localhost:8000`
   - Interactive docs: `http://localhost:8000/docs`

For detailed backend setup instructions, see [App/API_README.md](App/API_README.md)

## Frontend (Flutter) Setup - "flutterflow" Branch
To set up Flutter, refer to the official set-up guide:
[Flutter Installation Guide](https://docs.flutter.dev/get-started/quick)

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.
