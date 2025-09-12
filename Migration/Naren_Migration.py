import pyodbc
import psycopg2
import pandas as pd

# Seting up the database
ACCESS_FILE = r"C:\UWA\PROFCOM\DB_Migration\V2.accdb"
PG_DB = "mydb"
PG_USER = "postgres"
PG_PASS = "postgres"
PG_HOST = "localhost"
PG_PORT = "5432"

# Importing the Expected Schema 
from expected_schema import expected_schema

# Establishing Access Connections
access_conn = pyodbc.connect(
    r"DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=" + ACCESS_FILE + ";"
)

# Establishing Access Connections
pg_conn = psycopg2.connect(
    dbname=PG_DB, user=PG_USER, password=PG_PASS, host=PG_HOST, port=PG_PORT
)
pg_cur = pg_conn.cursor()


def quote_ident(name: str) -> str:
    return f'"{name}"'


# Creating Table from the expected Schema 
def build_create_table(table_name, schema):
    cols = []
    pk = []
    uniques = []
    fks = []

    for col, props in schema.items():
        col_def = f'{quote_ident(col)} {props["type"]}'
        if not props.get("nullable", True):
            col_def += " NOT NULL"
        if props.get("unique", False) and not props.get("primary_key", False):
            uniques.append(col)
        if props.get("primary_key", False):
            pk.append(col)
        if "foreign_key" in props:
            ref_table, ref_col = props["foreign_key"]
            fks.append(
                f'FOREIGN KEY ({quote_ident(col)}) REFERENCES {quote_ident(ref_table)}({quote_ident(ref_col)})'
            )
        cols.append(col_def)

    statement = f"CREATE TABLE {quote_ident(table_name)} (\n  " + ",\n  ".join(cols)
    if pk:
        statement += f",\n  PRIMARY KEY ({', '.join(quote_ident(c) for c in pk)})"
    if uniques:
        for u in uniques:
            statement += f",\n  UNIQUE ({quote_ident(u)})"
    if fks:
        for fk in fks:
            statement += f",\n  {fk}"
    statement += "\n);"
    return statement

for table, schema in expected_schema.items():
    pg_cur.execute(f"DROP TABLE IF EXISTS {quote_ident(table)} CASCADE;")
    create_stmt = build_create_table(table, schema)
    print(f"Creating table {table}...")
    pg_cur.execute(create_stmt)
pg_conn.commit()


# Access to Postgresql
for table in expected_schema.keys():
    print(f"Migrating {table}...")
    try:
        df = pd.read_sql(f"SELECT * FROM {table}", access_conn)
        if df.empty:
            continue
        cols = list(df.columns)
        placeholders = ", ".join(["%s"] * len(cols))
        insert_stmt = f"INSERT INTO {quote_ident(table)} ({', '.join(quote_ident(c) for c in cols)}) VALUES ({placeholders})"

        for _, row in df.iterrows():
            values = [None if pd.isna(v) else v for v in row]
            pg_cur.execute(insert_stmt, values)

        pg_conn.commit()
    except Exception as e:
        print(f"Skipping {table} due to error: {e}")

print("Script Complete")
