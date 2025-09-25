# Migration and Schema Test Instructions

## Prerequisites
- Python 3.x
- Install required packages:
  - pyodbc
  - psycopg2
  - sqlalchemy
  - pytest
  - pywin32 (for Windows/Access)

You can install all dependencies using:
```
pip install pyodbc psycopg2 sqlalchemy pytest pywin32
```

## How to Run the Migration
1. Set the access database address in db_address in 'migration.py'.
2. Update PostgreSQL connection details in POSTGRES_CONN_STR if needed.
3. Run the migration script:
```
python "migration.py"
```
This will migrate the Access database to PostgreSQL, including tables, data, and constraints.

## How to Run Schema Tests
1. Ensure the migration has completed and the PostgreSQL database is populated.
2. Update the PostgreSQL connection details in eng = create_engine if needed.
3. Run the schema test script using "pytest test_migration_schema.py":

This will check that the migrated schema matches the expected design, including tables, columns, constraints, and foreign keys.

## Notes
- The migration script is designed for Windows and requires Microsoft Access Driver and pywin32.
- If any foreign key constraints fail due to data issues, the script will skip those constraints and continue.
- Make sure your PostgreSQL server is running and accessible.

## Troubleshooting
- If you encounter errors about missing drivers, install the Microsoft Access Database Engine.
- For connection issues, verify your database credentials and network settings.
- For foreign key errors, check your access database for orphaned references.
