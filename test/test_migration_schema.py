import pytest
from sqlalchemy import create_engine, inspect, text
import pyodbc

@pytest.fixture(scope="module")
def engine():
    eng = create_engine("postgresql+psycopg2://username:password@localhost:5432/database")
    yield eng
    eng.dispose()

@pytest.fixture(scope="module")
def inspector(engine):
    return inspect(engine)

@pytest.fixture(scope="module")
def access_cursor():
    ACCESS_DB_PATH = r'C:/Users/Tri/Desktop/Uni stuff/CITS3200/V02/Y-botanic.accdb'
    ACCESS_CONN_STR = r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=' + ACCESS_DB_PATH + ';'
    conn = pyodbc.connect(ACCESS_CONN_STR)
    cur = conn.cursor()
    yield cur
    cur.close()
    conn.close()

expected_schema = {
    "aspect": {
        "aspect_id": {"type": "INTEGER", "primary_key": True},
        "aspect": {"type": "VARCHAR", "nullable": False, "unique": True},
    },
    "bioregion": {
        "bioregion_code": {"type": "VARCHAR", "primary_key": True},
        "region_name": {"type": "VARCHAR", "nullable": False},
    },
    "conservation_status": {
        "conservation_status_id": {"type": "INTEGER", "primary_key": True},
        "status": {"type": "VARCHAR", "nullable": False, "unique": True},
        "status_short_name": {"type": "VARCHAR", "nullable": True},
    },
    "container": {
        "container_type_id": {"type": "INTEGER", "primary_key": True},
        "container_type": {"type": "VARCHAR", "nullable": False},
    },
    "family": {
        "family_id": {"type": "INTEGER", "primary_key": True},
        "famiy_name": {"type": "VARCHAR", "nullable": False, "unique": True}, # Typo in V02 accessDB
    },
    "genetic_source": {
        "genetic_source_id": {"type": "INTEGER", "primary_key": True},
        "acquisition_date": {"type": "TIMESTAMP", "nullable": False},
        "variety_id": {"type": "INTEGER", "nullable": False},
        "supplier_id": {"type": "INTEGER", "nullable": False},
        "supplier_lot_number": {"type": "VARCHAR", "nullable": True},
        "price": {"type": "DOUBLE PRECISION", "nullable": True},
        "gram_weight": {"type": "INTEGER", "nullable": True},
        "provenance_id": {"type": "INTEGER", "nullable": True},
        "viability": {"type": "INTEGER", "nullable": True},
        "propagation_type": {"type": "INTEGER", "nullable": True},
        "female_genetic_source": {"type": "INTEGER", "nullable": True},
        "male_genetic_source": {"type": "INTEGER", "nullable": True},
        "generation_number": {"type": "INTEGER", "nullable": False},
        "landscape_only": {"type": "BOOLEAN", "nullable": True},
        "research_notes": {"type": "TEXT", "nullable": True},
    },
    "genus": {
        "genus_id": {"type": "INTEGER", "primary_key": True},
        "family_id": {"type": "INTEGER", "nullable": False},
        "genus": {"type": "VARCHAR", "nullable": False, "unique": True},
    },
    "location_type": {
        "location_type_id": {"type": "INTEGER", "primary_key": True},
        "location_type": {"type": "VARCHAR", "nullable": True},
    },
    "plant_utility": {
        "plant_utility_id": {"type": "INTEGER", "primary_key": True},
        "utility": {"type": "VARCHAR", "nullable": False, "unique": True},
    },
    "planting": {
        "planting_id": {"type": "INTEGER", "primary_key": True},
        "date_planted": {"type": "TIMESTAMP", "nullable": False},
        "planted_by": {"type": "INTEGER", "nullable": True},
        "zone_id": {"type": "INTEGER", "nullable": False},
        "variety_id": {"type": "INTEGER", "nullable": False},
        "number_planted": {"type": "INTEGER", "nullable": False},
        "genetic_source_id": {"type": "INTEGER", "nullable": True},
        "container_type_id": {"type": "INTEGER", "nullable": False},
        "removal_date": {"type": "TIMESTAMP"},
        "number_removed": {"type": "INTEGER", "nullable": True},
        "removal_cause_id": {"type": "INTEGER", "nullable": True},
        "comments": {"type": "TEXT", "nullable": True},
    },
    "progeny": {
        "progeny_id": {"type": "INTEGER", "unique": True},
        "genetic_source_id": {"type": "INTEGER", "primary_key": True},
        "sibling_number": {"type": "INTEGER", "primary_key": True},
        "child_name": {"type": "VARCHAR", "nullable": False},
        "date_germinated": {"type": "TIMESTAMP", "nullable": False},
        "comments": {"type": "VARCHAR", "nullable": True},
    },
    "propagation_type": {
        "propagation_type_id": {"type": "INTEGER", "primary_key": True},
        "propagation_type": {"type": "VARCHAR", "nullable": True},
        "needs_two_parents": {"type": "BOOLEAN", "nullable": True},
        "can_cross_genera": {"type": "BOOLEAN", "nullable": True},
    },
    "provenance": {
        "provenance_id": {"type": "INTEGER"},
        "bioregion_code": {"type": "VARCHAR", "nullable": False},
        "location": {"type": "VARCHAR", "nullable": True},
        "location_type_id": {"type": "INTEGER", "nullable": True},
        "extra_details": {"type": "VARCHAR", "nullable": True},
    },
    "removal_cause": {
        "removal_cause_id": {"type": "INTEGER", "primary_key": True},
        "cause": {"type": "VARCHAR", "nullable": False, "unique": True},
    },
    "role": {
        "role_id": {"type": "INTEGER", "primary_key": True},
        "role": {"type": "VARCHAR", "nullable": False, "unique": True},
        "description": {"type": "VARCHAR", "nullable": True},
    },
    "species": {
        "species_id": {"type": "INTEGER", "primary_key": True},
        "genus_id": {"type": "INTEGER", "nullable": False},
        "species": {"type": "VARCHAR", "nullable": False},
        "conservation_status_id": {"type": "INTEGER", "nullable": True},
    },
    "species_utility_link": {
        "species_id": {"type": "INTEGER", "primary_key": True},
        "plant_utility_id": {"type": "INTEGER", "primary_key": True},
    },
    "sub_zone": {
        "sub_zone_id": {"type": "INTEGER", "primary_key": True},
        "zone_id": {"type": "INTEGER", "nullable": True},
        "sub_zone_code": {"type": "VARCHAR", "nullable": True},
        "aspect_id": {"type": "INTEGER", "nullable": True},
        "exposure_to_wind": {"type": "VARCHAR", "nullable": True},
        "shade": {"type": "VARCHAR", "nullable": True},
    },
    "supplier": {
        "supplier_id": {"type": "INTEGER", "primary_key": True},
        "supplier_name": {"type": "VARCHAR", "nullable": False, "unique": True},
        "short_name": {"type": "VARCHAR", "nullable": False, "unique": True},
        "web_site": {"type": "VARCHAR", "nullable": True},
        "is_a_research_breeder": {"type": "BOOLEAN", "nullable": True},
    },
    "user": {
        "user_id": {"type": "INTEGER", "primary_key": True},
        "title": {"type": "VARCHAR", "nullable": True},
        "surname": {"type": "VARCHAR", "nullable": False},
        "first_name": {"type": "VARCHAR", "nullable": False},
        "preferred_name": {"type": "VARCHAR", "nullable": True},
        "address_line_1": {"type": "VARCHAR", "nullable": True},
        "address_line_2": {"type": "VARCHAR", "nullable": True},
        "locality": {"type": "VARCHAR", "nullable": True},
        "postcode": {"type": "INTEGER", "nullable": True},
        "work_phone": {"type": "VARCHAR", "nullable": True},
        "mobile": {"type": "VARCHAR", "nullable": False},
        "email": {"type": "VARCHAR", "nullable": False},
        "full_name": {"type": "VARCHAR", "nullable": False},
        "password": {"type": "VARCHAR", "nullable": True},
    },
    "user_role_link": {
        "user_id": {"type": "INTEGER", "primary_key": True},
        "role_id": {"type": "INTEGER", "primary_key": True},
    },
    "variety": {
        "variety_id": {"type": "INTEGER", "primary_key": True},
        "species_id": {"type": "INTEGER", "nullable": True},
        "common_name": {"type": "VARCHAR", "nullable": True},
        "variety": {"type": "VARCHAR", "nullable": True},
        "genetic_source_id": {"type": "INTEGER", "unique": True, "nullable": True},
    },
    "zone": {
        "zone_id": {"type": "INTEGER", "primary_key": True},
        "zone_number": {"type": "VARCHAR", "nullable": False, "unique": True},
        "zone_name": {"type": "VARCHAR", "nullable": True},
        "aspect_id": {"type": "INTEGER", "nullable": True},
        "exposure_to_wind": {"type": "VARCHAR", "nullable": True},
        "shade": {"type": "VARCHAR", "nullable": True},
    },
}
expected_views = {
    "plantings_view": ["planted_by", "zone_number", "aspect", "taxon", "genus_and_species", "number_planted", "removal_date", "removal_cause", "number_removed", "comments", "date_planted"],
    "taxon": ["variety_id", "taxon", "genus", "species", "variety", "genus_and_species"],
}

# --- Table existence tests ---
def test_missing_tables(inspector):
    actual_tables = set(inspector.get_table_names())
    for table in expected_schema.keys():
        assert table in actual_tables, f"Table missing: {table}"

def test_extra_tables(inspector):
    actual_tables = set(inspector.get_table_names())
    for table in actual_tables:
        assert table in expected_schema, f"Extra table: {table}"

# --- Column and constraint tests ---
@pytest.mark.parametrize("table", list(expected_schema.keys()))
def test_table_columns_and_constraints(table, inspector):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    columns = expected_schema[table]
    actual_columns = {col["name"]: col for col in inspector.get_columns(table)}
    # Missing columns
    for col_name in columns:
        assert col_name in actual_columns, f"Column missing: {col_name} in {table}"
    # Extra columns
    for col_name in actual_columns:
        assert col_name in columns, f"Extra column: {col_name} in {table}"
    # Datatype and nullable mismatches
    for col_name, props in columns.items():
        if col_name in actual_columns:
            actual_type = str(actual_columns[col_name]["type"]).upper()
            expected_type = props["type"].upper()
            assert expected_type in actual_type, f"Datatype mismatch for {col_name} in {table}: found {actual_type}, expected {expected_type}"
            if "nullable" in props:
                assert props["nullable"] == actual_columns[col_name]["nullable"], f"Nullable mismatch for {col_name} in {table}"
    # Primary key
    pk = inspector.get_pk_constraint(table)
    pk_cols = set(pk["constrained_columns"])
    for col_name, props in columns.items():
        if props.get("primary_key") and col_name in actual_columns:
            assert col_name in pk_cols, f"Primary key missing for {col_name} in {table}"
    # Unique
    uniques = inspector.get_unique_constraints(table)
    unique_cols = set()
    for uq in uniques:
        unique_cols.update(uq["column_names"])
    for col_name, props in columns.items():
        if props.get("unique") and col_name in actual_columns:
            assert col_name in unique_cols, f"Unique constraint missing for {col_name} in {table}"


# --- View tests ---
@pytest.mark.parametrize("view_name,expected_columns", list(expected_views.items()))
def test_views(view_name, expected_columns, inspector):
    actual_views = set(inspector.get_view_names())
    assert view_name in actual_views, f"View missing: {view_name}"
    columns = inspector.get_columns(view_name)
    actual_col_names = [col["name"] for col in columns]
    for col in expected_columns:
        assert col in actual_col_names, f"Column missing in view {view_name}: {col}"
    for col in actual_col_names:
        assert col in expected_columns, f"Extra column in view {view_name}: {col}"

# --- Foreign key tests ---
expected_foreign_keys = {
    "planting": [
        ("zone_id", "zone", "zone_id"),
        ("container_type_id", "container", "container_type_id"),
        ("removal_cause_id", "removal_cause", "removal_cause_id"),
        ("planted_by", "user", "user_id"),
        ("variety_id", "variety", "variety_id"),
        ("genetic_source_id", "genetic_source", "genetic_source_id"),
    ],
    "zone": [
        ("aspect_id", "aspect", "aspect_id"),
    ],
    "sub_zone": [
        ("zone_id", "zone", "zone_id"),
    ],
    "user_role_link": [
        ("user_id", "user", "user_id"),
        ("role_id", "role", "role_id"),
    ],
    "variety": [
        ("species_id", "species", "species_id"),
        ("genetic_source_id", "genetic_source", "genetic_source_id"),
    ],
    "species": [
        ("genus_id", "genus", "genus_id"),
        ("conservation_status_id", "conservation_status", "conservation_status_id"),
    ],
    "species_utility_link": [
        ("species_id", "species", "species_id"),
        ("plant_utility_id", "plant_utility", "plant_utility_id"),
    ],
    "genus": [
        ("family_id", "family", "family_id"),
    ],
    "progeny": [
        ("genetic_source_id", "genetic_source", "genetic_source_id"),
    ],
    "genetic_source": [
        ("supplier_id", "supplier", "supplier_id"),
        ("variety_id", "variety", "variety_id"),
        ("provenance_id", "provenance", "provenance_id"),
        ("propagation_type", "propagation_type", "propagation_type_id"),
        ("female_genetic_source", "genetic_source", "genetic_source_id"),
        ("male_genetic_source", "genetic_source", "genetic_source_id"),
    ],
    "provenance": [
        ("bioregion_code", "bioregion", "bioregion_code"),
        ("location_type_id", "location_type", "location_type_id"),
    ],
}

@pytest.mark.parametrize("table,expected_fks", list(expected_foreign_keys.items()))
def test_foreign_keys_present(table, expected_fks, inspector):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    fks = inspector.get_foreign_keys(table)
    actual_fks = set((fk['constrained_columns'][0], fk['referred_table'], fk['referred_columns'][0]) for fk in fks)
    expected_fks_set = set(expected_fks)
    for fk in expected_fks_set:
        assert fk in actual_fks, f"Missing foreign key in {table}: {fk}"

@pytest.mark.parametrize("table,expected_fks", list(expected_foreign_keys.items()))
def test_no_extra_foreign_keys(table, expected_fks, inspector):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    fks = inspector.get_foreign_keys(table)
    actual_fks = set((fk['constrained_columns'][0], fk['referred_table'], fk['referred_columns'][0]) for fk in fks)
    expected_fks_set = set(expected_fks)
    for fk in actual_fks:
        assert fk in expected_fks_set, f"Extra foreign key in {table}: {fk}"

# --- Row count and data tests ---
@pytest.mark.parametrize("table", list(expected_schema.keys()))
def test_row_counts_and_data(table, inspector, access_cursor, engine):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    access_cursor.execute(f'SELECT COUNT(*) FROM [{table}]')
    access_count = access_cursor.fetchone()[0]
    with engine.connect() as conn:
        pg_count = conn.execute(text(f'SELECT COUNT(*) FROM "{table}"')).fetchone()[0]
        assert access_count == pg_count, f"Row count mismatch in table {table}: Access={access_count}, Postgres={pg_count}"
        # Get column names in order for both databases
        access_cursor.execute(f'SELECT * FROM [{table}]')
        access_desc = [desc[0] for desc in access_cursor.description]
        pg_desc = [col['name'] for col in inspector.get_columns(table)]
        access_rows = access_cursor.fetchmany(5)
        pg_rows = conn.execute(text(f'SELECT * FROM "{table}" LIMIT 5')).fetchall()
        # Reorder Postgres rows to match Access column order
        pg_rows_reordered = []
        for row in pg_rows:
            row_dict = dict(zip(pg_desc, row))
            pg_rows_reordered.append(tuple(row_dict[col] for col in access_desc))
        def rows_equal(rows1, rows2):
            if len(rows1) != len(rows2):
                return False
            for r1, r2 in zip(rows1, rows2):
                if len(r1) != len(r2):
                    return False
                for v1, v2 in zip(r1, r2):
                    if str(v1) != str(v2):
                        return False
            return True
        assert rows_equal(access_rows, pg_rows_reordered), f"First 5 rows mismatch in table {table}: Access={access_rows}, Postgres={pg_rows_reordered}"
