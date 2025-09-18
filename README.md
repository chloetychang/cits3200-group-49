# cits3200-group-49
Botanic Guide: A Tool for Garden Planters

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
   
   # Windows:
   pip install -r requirements.txt

   # macOS/Linux
   pip install -r requirements_mac.txt
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

## Database Migrations with Alembic

Alembic is used for managing database schema migrations with SQLAlchemy and PostgreSQL.

### Alembic Installation & Setup

1. **Install Alembic**
   (Already included in `requirements.txt`, otherwise if not, follow instructions below)
   ```bash
   pip install alembic
   ```

2. **Initialize Alembic**
   In your **project root** (where your database code lives):
   ```bash
   alembic init alembic
   ```
   This creates an `alembic/` directory and an `alembic.ini` config file.

3. **Configure Alembic**
   - Open `alembic.ini` and set your database URL:
     ```ini
     sqlalchemy.url = postgresql+psycopg2://<user>:<password>@localhost:5434/<databasename>
     ```
   - In `alembic/env.py`, import your SQLAlchemy models and set metadata:
     ```python
     from App.models import Base  
     target_metadata = Base.metadata
     ```

4. **Use the latest Alembic Migration Version provided and apply**
   ```bash
   alembic upgrade head
   ```

5. **Test Your API Routes**
   - Start your FastAPI server:
     ```bash
     python main.py
     ```
   - Use Interactive docs: `http://localhost:8000/docs` to test API Routes like POST/GET request with live sync changes to the PostgreSQL database. (Verify it via pgAdmin and find specific database table)


## Frontend (Flutter) Setup - "flutterflow" Branch
To set up Flutter, refer to the official set-up guide:
[Flutter Installation Guide](https://docs.flutter.dev/get-started/quick)

### 1. Verify Flutter installation
To check that Flutter is installed and available on your system, run the following in your Terminal:
```bash
flutter doctor -v
```

### 2. Enable Flutter for Web (first time only)
Run the following command in your Terminal: 
```bash
flutter config --enable-web
```

### 3. Build the Project for Web - Compiling the app into a web bundle inside the `build/web/` folder:
Run the following command in your Terminal: 
```bash
flutter build web
```

### 4. Run the project locally
Run the following command in your Terminal: 
```bash
flutter run -d web-server
```
