import pyodbc
import psycopg2
import psycopg2.extras
import win32com.client
import re
import sys

# Config
ACCESS_FILE = r"C:\UWA\PROFCOM\DB_Migration\V2.accdb"
ACCESS_CONN_STR = r"DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=C:\UWA\PROFCOM\DB_Migration\V2.accdb;"
POSTGRES_CONN_STR = "host='localhost' dbname='mydb_ver2' user='postgres' password='1234'"


# Type mapping
ACCESS_TO_PG = {
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

# Mapping
def quote_pg_ident(name):
    return f'"{name}"'

def map_type(access_type, size=None):
    if isinstance(access_type, int):
        t = ADOX_TYPE_TO_PG.get(access_type, 'TEXT')
        return t(size) if callable(t) else t
    else:
        t = ACCESS_TO_PG.get(access_type.upper(), 'TEXT')
        if t in ('VARCHAR', 'CHAR') and size:
            return f"{t}({size})"
        return t

def get_access_tables(cursor):
    return [row.table_name for row in cursor.tables(tableType='TABLE')]

def get_table_schema_win32(table, access_db):
    cat = win32com.client.Dispatch('ADOX.Catalog')
    cat.ActiveConnection = f'Provider=Microsoft.ACE.OLEDB.12.0;Data Source={access_db};'
    table_obj = next((t for t in cat.Tables if t.Name == table and t.Type == 'TABLE'), None)
    if not table_obj:
        return [], set(), set(), []

    columns, pk, uniques, foreign_keys = [], set(), set(), []
    for col in table_obj.Columns:
        try:
            nullable = col.Properties("Nullable").Value
        except:
            nullable = True
        columns.append({
            'name': col.Name,
            'type': col.Type,
            'nullable': nullable,
            'size': getattr(col, 'DefinedSize', None)
        })

    for key in table_obj.Keys:
        if key.Type == 1:  # primary
            pk.update([c.Name for c in key.Columns])
        elif key.Type == 2:  # foreign
            ref_table = key.RelatedTable
            for c in key.Columns:
                try:
                    ref_col = c.RelatedColumn
                except:
                    ref_col = None
                if ref_table and ref_table != table and ref_col:
                    foreign_keys.append({'table': table, 'column': c.Name,
                                         'ref_table': ref_table, 'ref_column': ref_col})
    for idx in table_obj.Indexes:
        if getattr(idx, 'Unique', False):
            for c in idx.Columns:
                uniques.add(c.Name)
    return columns, pk, uniques, foreign_keys

def drop_all_tables_and_views(pg_conn):
    with pg_conn.cursor() as cur:
        cur.execute("""
        DO $$
        DECLARE r RECORD;
        BEGIN
            FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname='public') LOOP
                EXECUTE 'DROP TABLE IF EXISTS public.'||quote_ident(r.tablename)||' CASCADE';
            END LOOP;
            FOR r IN (SELECT viewname FROM pg_views WHERE schemaname='public') LOOP
                EXECUTE 'DROP VIEW IF EXISTS public.'||quote_ident(r.viewname)||' CASCADE';
            END LOOP;
        END $$;
        """)
    pg_conn.commit()

def create_pg_table(pg_cur, table, columns, pk, uniques, foreign_keys):
    col_defs = [
        f"{quote_pg_ident(col['name'])} {map_type(col['type'], col['size'])}{' NOT NULL' if not col['nullable'] else ''}"
        for col in columns
    ]
    constraints = []
    if pk:
        constraints.append(f"PRIMARY KEY ({', '.join([quote_pg_ident(c) for c in pk])})")
    for uq in uniques:
        if uq not in pk:
            constraints.append(f"UNIQUE ({quote_pg_ident(uq)})")
    sql = f"CREATE TABLE {quote_pg_ident(table)} (\n  " + ',\n  '.join(col_defs + constraints) + "\n);"
    pg_cur.execute(sql)

def copy_table_data(access_cur, pg_cur, table, columns):
    col_names = [c['name'] for c in columns]
    access_cur.execute(f"SELECT {', '.join([f'[{c}]' for c in col_names])} FROM [{table}]")
    rows = access_cur.fetchall()
    if not rows:
        return
    insert_sql = f"INSERT INTO {quote_pg_ident(table)} ({', '.join([quote_pg_ident(c) for c in col_names])}) VALUES ({', '.join(['%s']*len(col_names))})"
    psycopg2.extras.execute_batch(pg_cur, insert_sql, rows)


# Step 1: Migrate Tables + Data + FKs
def migrate():
    access_conn = pyodbc.connect(ACCESS_CONN_STR)
    access_cur = access_conn.cursor()
    pg_conn = psycopg2.connect(POSTGRES_CONN_STR)
    pg_cur = pg_conn.cursor()

    drop_all_tables_and_views(pg_conn)

    tables = get_access_tables(access_cur)
    all_fks = []

    for table in tables:
        print(f"Processing table {table}...")
        columns, pk, uniques, fks = get_table_schema_win32(table, ACCESS_FILE)
        create_pg_table(pg_cur, table, columns, pk, uniques, fks)
        copy_table_data(access_cur, pg_cur, table, columns)
        pg_conn.commit()
        all_fks.extend(fks)

    # Add foreign keys
    for fk in all_fks:
        try:
            pg_cur.execute("SAVEPOINT fk_savepoint")
            pg_cur.execute(
                f'ALTER TABLE {quote_pg_ident(fk["table"])} ADD FOREIGN KEY ({quote_pg_ident(fk["column"])}) '
                f'REFERENCES {quote_pg_ident(fk["ref_table"])}({quote_pg_ident(fk["ref_column"])})'
            )
            pg_cur.execute("RELEASE SAVEPOINT fk_savepoint")
        except Exception as e:
            print(f"Skipping FK {fk['table']}.{fk['column']} -> {fk['ref_table']}.{fk['ref_column']}: {e}")
            pg_cur.execute("ROLLBACK TO SAVEPOINT fk_savepoint")
    pg_conn.commit()

    access_cur.close()
    access_conn.close()
    pg_cur.close()
    pg_conn.close()
    print("Tables migrated successfully.")


# Step 2: Create Views 
def create_views():
    pg_conn = psycopg2.connect(POSTGRES_CONN_STR)
    pg_cur = pg_conn.cursor()

    # Taxon view
    taxon_sql = """
    CREATE OR REPLACE VIEW "taxon" AS
    SELECT
        v.variety_id,
        v.species_id AS taxon,
        g.genus,
        s.species,
        v.variety,
        g.genus || ' ' || s.species AS genus_and_species
    FROM variety v
    JOIN genus g ON g.genus_id = g.genus_id
    JOIN species s ON v.species_id = s.species_id;
    """
    try:
        pg_cur.execute(taxon_sql)
        print("Created view Taxon")
    except Exception as e:
        print(f"Failed to create view Taxon: {e}")

    # Plantings_view
    plantings_sql = """
    CREATE OR REPLACE VIEW "plantings_view" AS
    SELECT
        u.full_name AS planted_by,
        z.zone_number,
        a.aspect,
        v.species_id AS taxon,
        g.genus || ' ' || s.species AS genus_and_species,
        p.number_planted,
        p.removal_date,
        rc.cause AS removal_cause,
        p.number_removed,
        p.comments,
        p.date_planted
    FROM planting p
    INNER JOIN variety v ON p.variety_id = v.variety_id
    INNER JOIN species s ON v.species_id = s.species_id
    INNER JOIN genus g ON s.genus_id = g.genus_id
    LEFT JOIN removal_cause rc ON p.removal_cause_id = rc.removal_cause_id
    LEFT JOIN "user" u ON p.planted_by = u.user_id
    LEFT JOIN zone z ON p.zone_id = z.zone_id
    LEFT JOIN aspect a ON z.aspect_id = a.aspect_id;   
    """
    try:
        pg_cur.execute(plantings_sql)
        print("Created view plantings_view")
    except Exception as e:
        print(f"Failed to create view plantings_view: {e}")

    pg_conn.commit()
    pg_cur.close()
    pg_conn.close()
    print("View creation complete.")

if __name__ == "__main__":
    if "--views" in sys.argv:
        create_views()
    else:
        migrate()
        create_views()
