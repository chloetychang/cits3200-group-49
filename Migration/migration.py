# Script to migrate an Access database to PostgreSQL, preserving constraints
# Requires: pyodbc, psycopg2
import pyodbc
import psycopg2
import psycopg2.extras
import win32com.client
import re

# Database connection strings
db_address = r'C:\path\to\your\database.accdb'  # Update with your Access DB path
ACCESS_CONN_STR = r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=' + db_address + ';'
POSTGRES_CONN_STR = "host='localhost' dbname='your_db_name' user='your_username' password='your_password'"

# Map Access types to PostgreSQL types
ACCESS_TO_PG_TYPES = {
	'VARCHAR': 'VARCHAR',
	'CHAR': 'CHAR',
	'LONGCHAR': 'TEXT',
	'TEXT': 'TEXT',
	'BYTE': 'SMALLINT',
	'INTEGER': 'INTEGER',
	'LONG': 'BIGINT',
	'COUNTER': 'SERIAL',
	'DOUBLE': 'DOUBLE PRECISION',
	'SINGLE': 'REAL',
	'DATETIME': 'TIMESTAMP',
	'CURRENCY': 'NUMERIC',
	'YESNO': 'BOOLEAN',
	'NUMERIC': 'NUMERIC',
}

# Add this mapping for ADOX type codes
ADOX_TYPE_TO_PG = {
    3: 'INTEGER',
    4: 'SINGLE',
    5: 'DOUBLE PRECISION',
    6: 'FLOAT',
    7: 'TIMESTAMP',
    11: 'BOOLEAN',
    130: lambda s: f'VARCHAR({s})',
    202: lambda s: f'VARCHAR({s})',
    203: 'TEXT',
    131: 'NUMERIC',
}

def get_access_tables(cursor):
	# Get user tables only
	return [row.table_name for row in cursor.tables(tableType='TABLE')]

def drop_all_tables_and_views(pg_conn):
    with pg_conn.cursor() as cur:
        # Drop all tables
        cur.execute("""
            DO $$
            DECLARE
                r RECORD;
            BEGIN
                FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
                    EXECUTE 'DROP TABLE IF EXISTS public.' || quote_ident(r.tablename) || ' CASCADE';
                END LOOP;
            END $$;
        """)
        # Drop all views
        cur.execute("""
            DO $$
            DECLARE
                v RECORD;
            BEGIN
                FOR v IN (SELECT viewname FROM pg_views WHERE schemaname = 'public') LOOP
                    EXECUTE 'DROP VIEW IF EXISTS public.' || quote_ident(v.viewname) || ' CASCADE';
                END LOOP;
            END $$;
        """)
    pg_conn.commit()

# Get schema details from Access using win32
def get_table_schema_win32(table, access_db):
    cat = win32com.client.Dispatch('ADOX.Catalog')
    cat.ActiveConnection = f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={access_db};'
    table_obj = None
    for t in cat.Tables:
        if t.Name == table and t.Type == 'TABLE':
            table_obj = t
            break
    if not table_obj:
        return [], set(), set(), []
    columns = []
    pk = set()
    uniques = set()
    foreign_keys = []
    for col in table_obj.Columns:
        is_nullable = False
        try:
            is_nullable = col.Properties("Nullable").Value
        except Exception:
            is_nullable = True  # Default to nullable if property not found
        columns.append({
            'name': col.Name,
            'type': col.Type,
            'nullable': is_nullable,
            'column_size': getattr(col, 'DefinedSize', None)
        })
    for idx in table_obj.Keys:
        if idx.Type == 1:  # adKeyPrimary
            for c in idx.Columns:
                pk.add(c.Name)
        elif idx.Type == 2:  # adKeyForeign
            ref_table = idx.RelatedTable
            for c in idx.Columns:
                fk_col = c.Name
                try:
                    ref_col = c.RelatedColumn
                except Exception:
                    print(f"Could not find related column for foreign key {fk_col} in table {table}")
                    ref_col = None
                if ref_table and ref_table != table and ref_col:
                    foreign_keys.append({
                        'table': table,
                        'column': fk_col,
                        'ref_table': ref_table,
                        'ref_column': ref_col
                    })
    for idx in table_obj.Indexes:
        if idx.Unique:
            for c in idx.Columns:
                uniques.add(c.Name)
    return columns, pk, uniques, foreign_keys

# Map Access data types to PostgreSQL data types
def map_type(access_type, size):
    if isinstance(access_type, int):
        t = ADOX_TYPE_TO_PG.get(access_type, 'TEXT')
        if callable(t):
            return t(size)
        return t
    else:
        pg_type = ACCESS_TO_PG_TYPES.get(access_type.upper(), 'TEXT')
        if pg_type in ('VARCHAR', 'CHAR') and size:
            return f"{pg_type}({size})"
        return pg_type

# Create PostgreSQL table with constraints
def create_pg_table(pg_cur, table, columns, pk, uniques, foreign_keys):
    col_defs = []
    for col in columns:
        # Detect auto-increment PK: Access 'COUNTER' type or ADOX type code 3, and is PK
        is_auto_inc = (col['name'] in pk) and (col['type'] == 'COUNTER' or col['type'] == 3)
        if is_auto_inc:
            col_def = f'"{col["name"]}" INTEGER GENERATED ALWAYS AS IDENTITY'
        else:
            col_def = f'"{col["name"]}" {map_type(col["type"], col["column_size"])}'
        if not col['nullable']:
            col_def += ' NOT NULL'
        col_defs.append(col_def)
    constraints = []
    if pk:
        constraints.append(f'PRIMARY KEY ({", ".join([f"\"{c}\"" for c in pk])})')
    for uq in uniques:
        if uq not in pk:
            constraints.append(f'UNIQUE ("{uq}")')
    sql = f'CREATE TABLE IF NOT EXISTS "{table}" (\n  ' + ',\n  '.join(col_defs + constraints) + '\n);'
    pg_cur.execute(sql)

# Copy data from Access to PostgreSQL
def copy_table_data(access_cur, pg_cur, table, columns):
    col_names = [col['name'] for col in columns]
    access_cur.execute(f'SELECT {", ".join([f"[{c}]" for c in col_names])} FROM [{table}]')
    rows = access_cur.fetchall()
    if not rows:
        return
    # Detect if any column is auto-increment PK (identity)
    auto_inc_cols = [col['name'] for col in columns if (col['name'] in col_names) and (col['type'] == 'COUNTER' or col['type'] == 3)]
    if auto_inc_cols:
        insert_sql = f'INSERT INTO "{table}" ({", ".join([f"\"{c}\"" for c in col_names])}) OVERRIDING SYSTEM VALUE VALUES (' + ', '.join(['%s'] * len(col_names)) + ')'
    else:
        insert_sql = f'INSERT INTO "{table}" ({", ".join([f"\"{c}\"" for c in col_names])}) VALUES (' + ', '.join(['%s'] * len(col_names)) + ')'
    psycopg2.extras.execute_batch(pg_cur, insert_sql, rows)

# Function to fix sequences after data migration
def fix_sequences(pg_cur):
    """
    Fix PostgreSQL sequences to start from the maximum existing ID + 1.
    This is crucial after using OVERRIDING SYSTEM VALUE during data insertion.
    """
    print('Fixing sequences...')
    
    # Get all sequences and their associated table/column info
    pg_cur.execute("""
        SELECT 
            c.table_name,
            c.column_name,
            pg_get_serial_sequence(c.table_name, c.column_name) as sequence_name
        FROM information_schema.columns c
        WHERE c.table_schema = 'public' 
        AND c.is_identity = 'YES'
        AND pg_get_serial_sequence(c.table_name, c.column_name) IS NOT NULL
    """)
    
    sequences = pg_cur.fetchall()
    
    for table_name, column_name, sequence_name in sequences:
        try:
            # Simple approach: set sequence to max value in table
            pg_cur.execute(f"""
                SELECT setval('{sequence_name}', 
                    COALESCE((SELECT MAX("{column_name}") FROM "{table_name}"), 1)
                )
            """)
            print(f'Fixed sequence {sequence_name} for {table_name}.{column_name}')
        except Exception as e:
            print(f'Error fixing sequence {sequence_name}: {e}')

def fix_single_sequence(pg_cur, table_name, column_name, seq_name):
    """Fix a single sequence by setting it to max(column_value) + 1"""
    try:
        # Get the maximum value from the table
        pg_cur.execute(f'SELECT COALESCE(MAX("{column_name}"), 0) FROM "{table_name}"')
        max_id = pg_cur.fetchone()[0]
        
        if max_id > 0:
            # Set the sequence to max_id + 1
            pg_cur.execute(f"SELECT setval('{seq_name}', %s, true)", (max_id,))
            print(f'Fixed sequence {seq_name}: set to {max_id} (next value will be {max_id + 1})')
        else:
            print(f'Table {table_name} is empty, leaving sequence {seq_name} as is')
            
    except Exception as e:
        print(f'Error fixing sequence {seq_name} for {table_name}.{column_name}: {e}')

# Function to create views in PostgreSQL
def create_views(pg_cur):
    print('Creating views...')
    pg_keywords = {'user', 'table', 'group', 'limit', 'primary', 'key', 'column', 'constraint', 'references', 'unique', 'index', 'view', 'sequence', 'trigger', 'procedure', 'function', 'database', 'schema', 'transaction', 'real', 'double', 'precision', 'numeric', 'decimal', 'money', 'char', 'varchar', 'text', 'bytea', 'timestamp', 'date', 'time', 'interval', 'boolean', 'enum', 'json', 'jsonb', 'xml', 'uuid', 'inet', 'cidr', 'macaddr', 'tsvector', 'tsquery', 'box', 'circle', 'line', 'lseg', 'path', 'point', 'polygon', 'bit', 'varbit', 'serial', 'bigserial', 'identity', 'pg_catalog', 'information_schema'}
    cat = win32com.client.Dispatch('ADOX.Catalog')
    cat.ActiveConnection = f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={db_address};'
    views = [(view.Name, view.Command.CommandText) for view in cat.Views]
    views.sort(key=lambda v: 0 if v[0].lower() == 'taxon' else 1)
    for view_name, sql in views:
        sql_pg = sql.replace('[', '"').replace(']', '"')
        # Replace & with || for string concatenation
        sql_pg = re.sub(r'\s*&\s*', ' || ', sql_pg)
        # Replace double-quoted string literals with single-quoted ones
        sql_pg = re.sub(r'"([^"]+)"', lambda m: f"'{m.group(1)}'" if m.group(1).strip() == '' or not m.group(1).isidentifier() else f'"{m.group(1)}"', sql_pg)
        # Quote reserved words in table/column patterns (e.g., user.col)
        def quote_table(match):
            table = match.group(1)
            col = match.group(2)
            if table.lower() in pg_keywords and not (table.startswith('"') and table.endswith('"')):
                return f'"{table}".{col}'
            return match.group(0)
        sql_pg = re.sub(r'\b([A-Za-z_][A-Za-z0-9_]*)\b\.([A-Za-z_][A-ZaZ0-9_]*)', quote_table, sql_pg)
        # Quote reserved keywords if not already quoted (standalone)
        def quote_reserved(match):
            word = match.group(0)
            if word.lower() in pg_keywords and not (word.startswith('"') and word.endswith('"')):
                return f'"{word}"'
            return word
        sql_pg = re.sub(r'(?<!")\b([A-Za-z_][A-ZaZ0-9_]*)\b(?!")', quote_reserved, sql_pg)
        pg_cur.execute(f'CREATE OR REPLACE VIEW "{view_name}" AS {sql_pg}')
    pg_cur.connection.commit()

# Main migration function
def migrate():
    access_conn = pyodbc.connect(ACCESS_CONN_STR)
    access_cur = access_conn.cursor()
    pg_conn = psycopg2.connect(POSTGRES_CONN_STR)
    pg_cur = pg_conn.cursor()
    drop_all_tables_and_views(pg_conn)

    tables = get_access_tables(access_cur)
    all_foreign_keys = []
    table_schemas = {}
    for table in tables:
        print(f'Migrating table: {table}')
        columns, pk, uniques, foreign_keys = get_table_schema_win32(table, db_address)
        create_pg_table(pg_cur, table, columns, pk, uniques, foreign_keys)
        copy_table_data(access_cur, pg_cur, table, columns)
        pg_conn.commit()
        # Store schema info for uniqueness checks
        table_schemas[table] = {'pk': pk, 'uniques': uniques}
        all_foreign_keys.extend(foreign_keys)
    
    # Fix all sequences after data migration
    fix_sequences(pg_cur)
    pg_conn.commit()
    
    # Add all foreign keys after all tables are created
    for fk in all_foreign_keys:
        alter_sql = f'ALTER TABLE "{fk["table"]}" ADD FOREIGN KEY ("{fk["column"]}") REFERENCES "{fk["ref_table"]}"("{fk["ref_column"]}")'
        try:
            pg_cur.execute("SAVEPOINT fk_savepoint")
            pg_cur.execute(alter_sql)
            pg_cur.execute("RELEASE SAVEPOINT fk_savepoint")
        except Exception as e:
            print(f'Skipping foreign key for {fk["table"]}.{fk["column"]} referencing {fk["ref_table"]}.{fk["ref_column"]}: {e}')
            pg_cur.execute("ROLLBACK TO SAVEPOINT fk_savepoint")
    
    # Manually add the correct foreign key from variety to genetic_source
    # (The Access DB has this backwards)
    try:
        pg_cur.execute("SAVEPOINT manual_fk_savepoint")
        pg_cur.execute('ALTER TABLE "variety" ADD FOREIGN KEY ("genetic_source_id") REFERENCES "genetic_source"("genetic_source_id")')
        print("Successfully added manual FK: variety.genetic_source_id -> genetic_source.genetic_source_id")
        pg_cur.execute("RELEASE SAVEPOINT manual_fk_savepoint")
    except Exception as e:
        print(f'Could not add manual foreign key variety.genetic_source_id -> genetic_source.genetic_source_id: {e}')
        pg_cur.execute("ROLLBACK TO SAVEPOINT manual_fk_savepoint")
    
    # Add foreign key constraints for male_genetic_source and female_genetic_source
    try:
        pg_cur.execute("SAVEPOINT explicit_fk_savepoint")
        pg_cur.execute('ALTER TABLE "genetic_source" ADD FOREIGN KEY ("male_genetic_source") REFERENCES "genetic_source"("genetic_source_id")')
        pg_cur.execute("RELEASE SAVEPOINT explicit_fk_savepoint")
        print('Successfully added foreign key: genetic_source.male_genetic_source -> genetic_source.genetic_source_id')
    except Exception as e:
        print(f'Failed to add explicit foreign key for genetic_source.male_genetic_source: {e}')
        pg_cur.execute("ROLLBACK TO SAVEPOINT explicit_fk_savepoint")
    
    try:
        pg_cur.execute("SAVEPOINT explicit_fk_savepoint2")
        pg_cur.execute('ALTER TABLE "genetic_source" ADD FOREIGN KEY ("female_genetic_source") REFERENCES "genetic_source"("genetic_source_id")')
        pg_cur.execute("RELEASE SAVEPOINT explicit_fk_savepoint2")
        print('Successfully added foreign key: genetic_source.female_genetic_source -> genetic_source.genetic_source_id')
    except Exception as e:
        print(f'Failed to add explicit foreign key for genetic_source.female_genetic_source: {e}')
        pg_cur.execute("ROLLBACK TO SAVEPOINT explicit_fk_savepoint2")
    
    pg_conn.commit()

    # Migrate views after tables
    create_views(pg_cur)

    access_cur.close()
    access_conn.close()
    pg_cur.close()
    pg_conn.close()
    print('Migration complete.')

if __name__ == '__main__':
	migrate()
