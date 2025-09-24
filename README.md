# cits3200-group-49
Botanic Guide: A Tool for Garden Planters

## Project Overview

This project consists of:
- **Frontend**: Flutter web application
- **Backend**: FastAPI Python application
- **Database**: PostgreSQL

## Backend API and Database Setup

### Prerequisites
- Python 3.8+
- PostgreSQL database

### Backend Project Structure
A FastAPI application for managing plant genetic sources, plantings, and related botanical data.

```
# Add potential backend project structure, with routes defined

```

### Database Structure

```
# Add potential database structure, with directories

```

### 1. **Create Python Virtual Environment**
First, set up a Python virtual environment to isolate project dependencies:

```bash
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate
```
You should see `(venv)` in your terminal prompt when the environment is active.

### 2. **Install Dependencies**
With your virtual environment activated:

```bash
cd App
pip install -r requirements.txt
```

### 3. **Configure Environment Variables**
Return to main directory by running `cd ..`

Create a `.env` file based on the template in `.env.example`.

For security, actual credentials shall be sent separately. 

### 4. **Set up Database**
Connecting to Dockerized PostgreSQL
> Database Details: Available upon request.

#### a. Initialise Database
To set up the PostgreSQL environment locally, run:

```bash
# Make sure you are in the main directory, if not, run `cd` ... 
cd Infrastructure
```

#### b. Start the Docker daemon (open Docker Desktop or run `dockerd` if needed)
Use the appropriate command for your system:

```bash
## Mac / Windows (Docker Desktop)
docker compose up -d

## Linux (some distributions still use the old binary)
docker-compose up -d
```

#### c. Using pgAdmin within Docker Container

1. Open **pgAdmin** using either Docker Desktop or your local installation.  
2. Login using the credentials as defined in `.env` file:
   - Email Address / Username: `PGADMIN_DEFAULT_EMAIL`
   - Password: `PGADMIN_DEFAULT_PASSWORD`
2. **Click on:** Quick Links - Add New Server.  
3. **General tab:**  
   - Name: `CITS3200` (or any name you like)  
4. **Connection tab:**  
   - Host name/address: `postgres`  
   - Port: `5432`  or `5434` (if pgAdmin was installed locally)
   - Maintenance database: `postgres`  
   - Username: `Refer to DATABASE_USER as provided`
   - Password: `Refer to DATABASE_PASSWORD as provided` 
5. Click **Save**.  
6. You should now see the databases
7. Perform a right-click on "mydb_verVB" 
8. Select Query Tool (To create SQL Queries)
9. eg. SELECT * from location_type

### 5. Database Migrations with Alembic

Alembic is used for managing database schema migrations with SQLAlchemy and PostgreSQL.

#### a. **Initialize Alembic**
In your **project root** (where your database code lives): 

```bash
# Make sure you are in the main directory, if not, run `cd` ... 
alembic init alembic
```
This creates an `alembic/` directory and an `alembic.ini` config file.

#### b. **Configure Alembic**
- Open `alembic.ini` and set your database URL:

```ini
# line 66 of file
sqlalchemy.url = postgresql+psycopg2://<user>:<password>@localhost:5434/<databasename>
```

- In `alembic/env.py`, import your SQLAlchemy models and set metadata:
```python
from App.models import Base  
target_metadata = Base.metadata   # ~ line 24 of env file
```

#### c. **Create Initial Migration**
Using existing database schema (backup.sql), create an initial alembic migration version:
```bash
alembic revision -m "Initial migration"
```

### 6. **Run the API**
Ensure your PostgreSQL database is running and accessible with the credentials specified in your `.env` file.

API will be available at `http://localhost:8000`

#### API Documentation
Once the application is running, you can access:
   - Interactive docs: `http://localhost:8000/docs`
   - Alternative API docs: `http://localhost:8000/redoc`


## Frontend (Flutter) Setup
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
