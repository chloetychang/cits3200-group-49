import pyodbc
import psycopg2
import pandas as pd

#Set-up for PG4Admin
ACCESS_FILE = r"C:\UWA\PROFCOM\DB_Migration\V2.accdb"
PG_DB = "db1"
PG_USER = "postgres"
PG_PASS = "1234"
PG_HOST = "localhost"
PG_PORT = "5432"

#Access Connection (pyobdc)
access_conn = pyodbc.connect(
    r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=' + ACCESS_FILE + ';'
)
access_cursor = access_conn.cursor()

#Postgress Conncection (psycopg2)
pg_conn = psycopg2.connect(
    dbname=PG_DB, user=PG_USER, password=PG_PASS, host=PG_HOST, port=PG_PORT
)
pg_cursor = pg_conn.cursor()

## Intitiation of script 
#Accesing all tables from the original DB
tables = [row.table_name for row in access_cursor.tables(tableType='TABLE')]

## Getting primary keys (STILL BROKEN (SOMEHOW IT WONT MATCH UP))
def get_primary_keys(cursor, table_name):
    try:
        query = f"""
        SELECT i.Name AS IndexName, c.Name AS ColumnName
        FROM MSysIndexes i
        INNER JOIN MSysObjects o ON i.ObjectId = o.Id
        INNER JOIN MSysIndexInfo ii ON i.Id = ii.IndexId
        INNER JOIN MSysColumns c ON ii.ColumnId = c.Id
        WHERE o.Name = '{table_name}' AND i.Primary = True
        """
        cursor.execute(query)
        return [row.ColumnName for row in cursor.fetchall()]
    except Exception:
        return []

## Getting primary keys (STILL BROKEN (SOMEHOW IT WONT MATCH UP))
def get_foreign_keys(cursor):
    try:
        query = """
        SELECT szRelationship, szReferencedObject, szReferencedColumn, szObject, szColumn
        FROM MSysRelationships
        WHERE szRelationship IS NOT NULL
        """
        cursor.execute(query)
        return cursor.fetchall()
    except Exception:
        return []

# Analysing Datatypes 
def data_type(series):
    if pd.api.types.is_bool_dtype(series):
        return "BOOLEAN"
    elif pd.api.types.is_integer_dtype(series):
        return "BIGINT" if series.max() > 2**31 - 1 else "INTEGER"
    elif pd.api.types.is_float_dtype(series):
        return "NUMERIC(19,4)"   # safer than REAL/DOUBLE
    elif pd.api.types.is_datetime64_any_dtype(series):
        return "TIMESTAMP"
    else:
        try:
            max_len = series.dropna().astype(str).map(len).max()
            if max_len and max_len < 255:
                return f"VARCHAR({max_len})"
            else:
                return "TEXT"
        except Exception:
            return "TEXT"

# Migrating each tables (Extractions)
for table in tables:
    print(f"Migrating table: {table}")
    df = pd.read_sql(f"SELECT * FROM [{table}]", access_conn)

    # Normalize datetime columns #Possibble issues 
    for col in df.columns:
        if df[col].dtype == "object":
            try:
                df[col] = pd.to_datetime(df[col])
            except Exception:
                pass

    # Infer column types
    col_defs = []
    for col in df.columns:
        pg_type = data_type(df[col])
        col_defs.append(f'"{col}" {pg_type}')

    # Get primary keys #Broken
    pk_cols = get_primary_keys(access_cursor, table)
    pk_clause = (
        ", PRIMARY KEY (" + ", ".join([f'"{col}"' for col in pk_cols]) + ")"
        if pk_cols else ""
    )

    # Creating new table in postgress
    pg_cursor.execute(f'DROP TABLE IF EXISTS "{table}" CASCADE;')
    create_stmt = f'CREATE TABLE "{table}" ({", ".join(col_defs)}{pk_clause});'
    pg_cursor.execute(create_stmt)

    # Migrating data to postgress
    for _, row in df.iterrows():
        values = []
        for v in row.values:
            if pd.isna(v):
                values.append(None)
            elif isinstance(v, pd.Timestamp):
                values.append(v.to_pydatetime())
            elif hasattr(v, "item"):  # NumPy scalar
                values.append(v.item())
            else:
                values.append(v)

        placeholders = ", ".join(["%s"] * len(values))
        insert_stmt = f'INSERT INTO "{table}" VALUES ({placeholders});'
        pg_cursor.execute(insert_stmt, values)

    pg_conn.commit()
    print(f"Table {table} migrated.")

# Application of foreign keys to postgress
foreign_keys = get_foreign_keys(access_cursor)

for fk in foreign_keys:
    rel_name, parent_table, parent_col, child_table, child_col = fk
    constraint_name = f'"fk_{child_table}_{child_col}"'

    alter_stmt = (
        f'ALTER TABLE "{child_table}" '
        f'ADD CONSTRAINT {constraint_name} FOREIGN KEY ("{child_col}") '
        f'REFERENCES "{parent_table}" ("{parent_col}");'
    )

    try:
        pg_cursor.execute(alter_stmt)
        pg_conn.commit()
        print(f"🔗 Foreign key added: {child_table}.{child_col} → {parent_table}.{parent_col}")
    except Exception as e:
        print(f"Failed to add foreign key {constraint_name}: {e}")


access_cursor.close()
access_conn.close()
pg_cursor.close()
pg_conn.close()

print("Script done")
