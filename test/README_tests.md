# Test Suite Instructions

This folder contains several tests. To run them, ensure you have followed all the other README's in the project.
The instructions here assume you are running the tests from the root directory.

## 1. Activate your Python environment

On Windows (PowerShell):
```bash
"venv/Scripts/Activate"
```
On macOS/Linux:
```bash
source venv/bin/activate
```

## 2. Install dependencies associated with the tests

```bash
pip install -r test/requirements.txt
```

## 3. Run the tests

### Run backend unit tests
This test checks that the backend is creating the correct http requests using a mock in the place of the postgres.
```bash
pytest test/test_BackendUnitTests.py
```

### Run integration tests
These tests checks the interactions between the frontend, backend and database.

The first set of tests checks the integration between the backend and database
- Make sure that the backend and database are running on the Infrastructure Docker container. See README.md.
- To run this, open one instance of the terminal and venv, and run the backend using:

```bash
pytest test/test_IntegrationTests.py
```

The second set of tests checks the integration between the frontend and the backend. 
- This can be ran by using:

```bash
flutter test
```

### Run Postgres connection test
This test checks that the Postgres database outlined in the .env file has the correct database features.
This includes tables, columns, keys and constraints.

```bash
pytest test/test_postgresConnection.py
```

## Notes
- Make sure your database (Postgres) and backend server are running if required by the tests. See README.md at the root directory.
- Environment variables should be set in `.env` for database connection.
- Flutter integration tests require the Flutter SDK to be installed and configured.
