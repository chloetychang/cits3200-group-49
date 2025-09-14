import os
import pytest
import pyodbc
import subprocess
from sqlalchemy import create_engine, inspect, text

ACCESS_DB_PATH = os.path.abspath("test_genetic_source.accdb")
POSTGRES_CONN_STR = "postgresql+psycopg2://username:password@localhost:5432/your_db"
MIGRATION_SCRIPT = os.path.abspath("migration_test.py")

def create_access_db():
    # Create Access DB file
    if not os.path.exists(ACCESS_DB_PATH):
        # Create new Access DB file using ADOX
        import win32com.client
        adox = win32com.client.Dispatch('ADOX.Catalog')
        conn_str = f"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={ACCESS_DB_PATH};"
        adox.Create(conn_str)
    # Now connect and clear tables if needed
    conn = pyodbc.connect(r"DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=" + ACCESS_DB_PATH)
    cur = conn.cursor()
    tables = [row.table_name for row in cur.tables(tableType='TABLE')]
    for table in tables:
        try:
            cur.execute(f"DELETE FROM [{table}]")
        except Exception:
            pass
    conn.commit()
    # Create extra table
    cur.execute("CREATE TABLE extra_table (extra_id INTEGER PRIMARY KEY, extra_value TEXT)")
    cur.execute("INSERT INTO extra_table (extra_id, extra_value) VALUES (?, ?)", (1, 'foo'))
    # Create referenced tables
    cur.execute("CREATE TABLE supplier (supplier_id INTEGER PRIMARY KEY, supplier_name TEXT)")
    cur.execute("INSERT INTO supplier (supplier_id, supplier_name) VALUES (?, ?)", (1, 'Supplier1'))
    cur.execute("CREATE TABLE provenance (provenance_id INTEGER PRIMARY KEY, details TEXT)")
    cur.execute("INSERT INTO provenance (provenance_id, details) VALUES (?, ?)", (1, 'Provenance1'))
    cur.execute("CREATE TABLE propagation_type (propagation_type_id INTEGER PRIMARY KEY, type_name TEXT)")
    cur.execute("INSERT INTO propagation_type (propagation_type_id, type_name) VALUES (?, ?)", (1, 'Seed'))
    cur.execute("CREATE TABLE variety (variety_id INTEGER PRIMARY KEY, name TEXT)")
    cur.execute("INSERT INTO variety (variety_id, name) VALUES (?, ?)", (1, 'Variety1'))
    # Create genetic_source table with references
    cur.execute("""
        CREATE TABLE genetic_source (
            genetic_source_id INTEGER PRIMARY KEY,
            supplier_id INTEGER,
            extra_id INTEGER,
            provenance_id INTEGER,
            propagation_type INTEGER,
            variety_id INTEGER,
            FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
            FOREIGN KEY (extra_id) REFERENCES extra_table(extra_id),
            FOREIGN KEY (provenance_id) REFERENCES provenance(provenance_id),
            FOREIGN KEY (propagation_type) REFERENCES propagation_type(propagation_type_id),
            FOREIGN KEY (variety_id) REFERENCES variety(variety_id)
        )
    """)
    cur.execute("INSERT INTO genetic_source (genetic_source_id, supplier_id, extra_id, provenance_id, propagation_type, variety_id) VALUES (?, ?, ?, ?, ?, ?)", (1, 1, 1, 1, 1, 1))
    cur.execute("INSERT INTO genetic_source (genetic_source_id, supplier_id, extra_id, provenance_id, propagation_type, variety_id) VALUES (?, ?, ?, ?, ?, ?)", (2, 1, 1, 1, 1, 1))
    cur.execute("INSERT INTO genetic_source (genetic_source_id, supplier_id, extra_id, provenance_id, propagation_type, variety_id) VALUES (?, ?, ?, ?, ?, ?)", (3, 1, 1, 1, 1, 1))
    conn.commit()
    # Debug: print inserted genetic_source rows
    try:
        cur.execute("SELECT * FROM genetic_source ORDER BY genetic_source_id")
        print("[DEBUG] Access genetic_source rows:", cur.fetchall())
    except Exception as e:
        print("[DEBUG] Error printing Access genetic_source rows:", e)
    cur.close()
    conn.close()

@pytest.fixture(scope="module", autouse=True)
def setup_access_db():
    create_access_db()
    os.environ["ACCESS_DB_PATH"] = ACCESS_DB_PATH
    subprocess.run(["python", MIGRATION_SCRIPT], check=True)
    yield
    # Teardown: drop all tables and delete Access DB file
    try:
        conn = pyodbc.connect(r"DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=" + ACCESS_DB_PATH)
        cur = conn.cursor()
        tables = [row.table_name for row in cur.tables(tableType='TABLE')]
        for table in tables:
            try:
                cur.execute(f"DROP TABLE [{table}]")
            except Exception:
                pass
        conn.commit()
        cur.close()
        conn.close()
    except Exception:
        pass
    if os.path.exists(ACCESS_DB_PATH):
        os.remove(ACCESS_DB_PATH)

@pytest.fixture(scope="module")
def engine():
    eng = create_engine(POSTGRES_CONN_STR)
    yield eng
    eng.dispose()

@pytest.fixture(scope="module")
def inspector(engine):
    return inspect(engine)

def test_tables_exist(inspector):
    expected_tables = {"genetic_source", "supplier", "extra_table", "provenance", "propagation_type", "variety"}
    tables = set(inspector.get_table_names())
    assert tables == expected_tables, f"Tables mismatch. Expected: {expected_tables}, Found: {tables}"

def test_genetic_source_columns(inspector):
    expected_cols = {"genetic_source_id", "supplier_id", "extra_id", "provenance_id", "propagation_type", "variety_id"}
    cols = {col["name"] for col in inspector.get_columns("genetic_source")}
    assert cols == expected_cols, f"Columns mismatch in genetic_source. Expected: {expected_cols}, Found: {cols}"

def test_foreign_keys(inspector):
    fks = inspector.get_foreign_keys("genetic_source")
    fk_set = set((fk['constrained_columns'][0], fk['referred_table'], fk['referred_columns'][0]) for fk in fks)
    expected = set([
        ("supplier_id", "supplier", "supplier_id"),
        ("extra_id", "extra_table", "extra_id"),
        ("provenance_id", "provenance", "provenance_id"),
        ("propagation_type", "propagation_type", "propagation_type_id"),
        ("variety_id", "variety", "variety_id")
    ])
    missing = [fk for fk in expected if fk not in fk_set]
    assert not missing, f"Missing foreign keys: {missing}"

def test_data(engine):
    with engine.connect() as conn:
        result = conn.execute(text("SELECT * FROM genetic_source ORDER BY genetic_source_id"))
        rows = result.fetchall()
        col_names = result.keys()
        assert len(rows) == 3, f"Expected 3 rows in genetic_source, found {len(rows)}"
        for i, row in enumerate(rows, start=1):
            row_dict = dict(zip(col_names, row))
            print(f"Row {i}: {row_dict}")
            assert row_dict["genetic_source_id"] == i, f"Row genetic_source_id mismatch: expected {i}, got {row_dict['genetic_source_id']}"
            for col in ["supplier_id", "extra_id", "provenance_id", "propagation_type", "variety_id"]:
                assert row_dict[col] == 1, f"Unexpected value for {col} in row {i}: {row_dict[col]}"
