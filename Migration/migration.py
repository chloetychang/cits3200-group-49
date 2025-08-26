# Script to migrate an Access database to PostgreSQL, preserving constraints
# Requires: pyodbc, psycopg2
import pyodbc
import psycopg2
import psycopg2.extras
import win32com.client

# Placeholders for connection strings
db_address = "C:\Users\Tri\Desktop\Uni stuff\CITS3200\V02\Y-botanic.accdb"
ACCESS_CONN_STR = r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=' + db_address + ';'
POSTGRES_CONN_STR = "host='localhost' dbname='' user='' password=''"

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

def get_table_schema(cursor, table):
	# Get columns and constraints
	columns = []
	pk = set()
	uniques = set()
	for row in cursor.columns(table):
		columns.append({
			'name': row.column_name,
			'type': row.type_name,
			'nullable': row.nullable,
			'column_size': row.column_size
		})
	# Primary keys
	for row in cursor.primaryKeys(table):
		pk.add(row.column_name)
	# Unique constraints
	for row in cursor.statistics(table, unique=True, best_row=False):
		if row.index_name and not row.non_unique:
			uniques.add(row.column_name)
	return columns, pk, uniques

def get_table_schema_win32(table, access_db):
    cat = win32com.client.Dispatch('ADOX.Catalog')
    cat.ActiveConnection = f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={access_db};'
    table_obj = None
    for t in cat.Tables:
        if t.Name == table and t.Type == 'TABLE':
            table_obj = t
            break
    if not table_obj:
        return [], set(), set()
    columns = []
    pk = set()
    uniques = set()
    for col in table_obj.Columns:
        columns.append({
            'name': col.Name,
            'type': col.Type,
            'nullable': col.Attributes & 0x20 == 0x20,  # adColNullable
            'column_size': getattr(col, 'DefinedSize', None)
        })
    for idx in table_obj.Keys:
        if idx.Type == 1:  # adKeyPrimary
            for c in idx.Columns:
                pk.add(c.Name)
    for idx in table_obj.Indexes:
        if idx.Unique:
            for c in idx.Columns:
                uniques.add(c.Name)
    return columns, pk, uniques

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

def create_pg_table(pg_cur, table, columns, pk, uniques):
	col_defs = []
	for col in columns:
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

def copy_table_data(access_cur, pg_cur, table, columns):
	col_names = [col['name'] for col in columns]
	access_cur.execute(f'SELECT {", ".join([f"[{c}]" for c in col_names])} FROM [{table}]')
	rows = access_cur.fetchall()
	if not rows:
		return
	insert_sql = f'INSERT INTO "{table}" ({", ".join([f"\"{c}\"" for c in col_names])}) VALUES (' + ', '.join(['%s'] * len(col_names)) + ')'
	psycopg2.extras.execute_batch(pg_cur, insert_sql, rows)

def migrate():
	access_conn = pyodbc.connect(ACCESS_CONN_STR)
	access_cur = access_conn.cursor()
	pg_conn = psycopg2.connect(POSTGRES_CONN_STR)
	pg_cur = pg_conn.cursor()

	tables = get_access_tables(access_cur)
	for table in tables:
		print(f'Migrating table: {table}')
		columns, pk, uniques = get_table_schema_win32(table, db_address)
		create_pg_table(pg_cur, table, columns, pk, uniques)
		copy_table_data(access_cur, pg_cur, table, columns)
		pg_conn.commit()

	access_cur.close()
	access_conn.close()
	pg_cur.close()
	pg_conn.close()
	print('Migration complete.')

if __name__ == '__main__':
	migrate()
