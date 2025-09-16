import pytest
from sqlalchemy import create_engine, inspect, text
from sqlalchemy.exc import OperationalError
import os
from dotenv import load_dotenv


# Load environment variables from .env file
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../App/.env'))
DB_HOST = os.getenv("DATABASE_HOST")
DB_PORT = os.getenv("DATABASE_PORT")
DB_NAME = os.getenv("DATABASE_NAME")
DB_USER = os.getenv("DATABASE_USER")
DB_PASSWORD = os.getenv("DATABASE_PASSWORD")

def build_postgres_url():
    if not all([DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD]):
        return None
    return f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

POSTGRES_URL = build_postgres_url()

expected_tables = [
    "aspect", "bioregion", "conservation_status", "container", "family", "genetic_source", "genus",
    "location_type", "plant_utility", "planting", "progeny", "propagation_type", "provenance", "removal_cause",
    "role", "species", "species_utility_link", "sub_zone", "supplier", "user", "user_role_link", "variety", "zone"
]

@pytest.fixture(scope="module")
def engine():
    if not POSTGRES_URL:
        pytest.fail("DATABASE_URL environment variable not set.")
    try:
        eng = create_engine(POSTGRES_URL)
        # Try connecting to the database
        conn = eng.connect()
        conn.close()
        yield eng
    except OperationalError as e:
        pytest.fail(f"Could not connect to Postgres: {e}")
    finally:
        if 'eng' in locals():
            eng.dispose()

@pytest.fixture(scope="module")
def inspector(engine):
    return inspect(engine)

def test_postgres_tables_exist(inspector):
    actual_tables = set(inspector.get_table_names())
    for table in expected_tables:
        assert table in actual_tables, f"Table missing: {table}"

def test_postgres_no_extra_tables(inspector):
    actual_tables = set(inspector.get_table_names())
    for table in actual_tables:
        assert table in expected_tables, f"Extra table: {table}"


# --- Detailed schema checks ---
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
        "famiy_name": {"type": "VARCHAR", "nullable": False, "unique": True},
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

# --- Row count and first 5 row tests ---
@pytest.mark.parametrize("table", list(expected_schema.keys()))
def test_row_counts_and_first_rows(table, inspector, engine):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    with engine.connect() as conn:
        pg_count = conn.execute(text(f'SELECT COUNT(*) FROM "{table}"')).fetchone()[0]
        assert pg_count >= 0, f"Row count negative in table {table}: {pg_count}"
        # Get column names in order
        pg_desc = [col['name'] for col in inspector.get_columns(table)]
        pg_rows = conn.execute(text(f'SELECT * FROM "{table}" LIMIT 5')).fetchall()
        # Just check that rows can be fetched and have correct columns
        for row in pg_rows:
            assert len(row) == len(pg_desc), f"Row column count mismatch in table {table}: {row}"