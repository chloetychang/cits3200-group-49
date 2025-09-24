# Test Suite Instructions

This folder contains several tests. To run them, ensure you have followed all the other README's in the project.
The instructions here assume you are running the tests from the root directory.

## 1. Activate your Python environment

On Windows (PowerShell):
```
& "venv/Scripts/Activate"
```
On macOS/Linux:
```
source venv/bin/activate
```

## 2. Install dependencies associated with the tests

```
pip install -r test/requirements.txt
```

## 3. Run the tests

### Run backend unit tests
This test checks that the backend is creating the correct http requests using a mock in the place of the postgres.
```
pytest test/test_BackendUnitTests.py
```

### Run integration tests
These tests checks the interactions between the frontend, backend and database.
The first test checks the integration between the backend and database
- To run this, open one instance of the terminal and venv, and run the backend using:
```bash
python -m App.main
```
- Then, on a second instance of the terminal abd vebvm run the integration test using
```
pytest test/test_IntegrationTests.py
```

### Run Postgres connection test
This test checks that the Postgres database outlined in the .env file has the correct database features.
This includes tables, columns, keys and constraints.
```
pytest test/test_postgresConnection.py
```

## Notes
- Make sure your database (Postgres) and backend server are running if required by the tests.
- Environment variables should be set in `App/.env` for database connection.
- Flutter integration tests require the Flutter SDK to be installed and configured.

## 4. Flutter Frontend-Backend Integration Tests

**Requirements:**
1. Add `integration_test` package to `pubspec.yaml`:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

2. Run `flutter pub get`

3. Start your PostgreSQL database

4. Start your FastAPI backend:
```bash
python main.py
```

5. Run the frontend-backend integration tests:
```bash
flutter test test/test_flutter_integration.dart
```
