import pytest
from sqlalchemy import create_engine, inspect, text
import pyodbc

@pytest.fixture(scope="module")
def engine():
    # Update with actual connection details
    eng = create_engine("postgresql+psycopg2://username:password@localhost:5432/database")
    yield eng
    eng.dispose()

@pytest.fixture(scope="module")
def inspector(engine):
    return inspect(engine)

@pytest.fixture(scope="module")
def access_cursor():
    ACCESS_DB_PATH = r'path' # Update with actual path to Access DB
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
    missing_tables = []
    for table in expected_schema.keys():
        if table not in actual_tables:
            missing_tables.append(table)
    
    if missing_tables:
        pytest.fail(f"Missing tables: {missing_tables}")

def test_extra_tables(inspector):
    actual_tables = set(inspector.get_table_names())
    extra_tables = []
    for table in actual_tables:
        if table not in expected_schema:
            extra_tables.append(table)
    
    if extra_tables:
        pytest.fail(f"Extra tables: {extra_tables}")

# --- Column and constraint tests ---
@pytest.mark.parametrize("table", list(expected_schema.keys()))
def test_table_columns_and_constraints(table, inspector):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    columns = expected_schema[table]
    actual_columns = {col["name"]: col for col in inspector.get_columns(table)}
    
    # Collect all issues instead of failing on the first one
    issues = []
    
    # Missing columns
    missing_columns = []
    for col_name in columns:
        if col_name not in actual_columns:
            missing_columns.append(col_name)
    if missing_columns:
        issues.append(f"Missing columns: {missing_columns}")
    
    # Extra columns
    extra_columns = []
    for col_name in actual_columns:
        if col_name not in columns:
            extra_columns.append(col_name)
    if extra_columns:
        issues.append(f"Extra columns: {extra_columns}")
    
    # Datatype and nullable mismatches
    datatype_mismatches = []
    nullable_mismatches = []
    for col_name, props in columns.items():
        if col_name in actual_columns:
            actual_type = str(actual_columns[col_name]["type"]).upper()
            expected_type = props["type"].upper()
            if expected_type not in actual_type:
                datatype_mismatches.append(f"{col_name}: found {actual_type}, expected {expected_type}")
            if "nullable" in props:
                if props["nullable"] != actual_columns[col_name]["nullable"]:
                    nullable_mismatches.append(f"{col_name}: found nullable={actual_columns[col_name]['nullable']}, expected nullable={props['nullable']}")
    
    if datatype_mismatches:
        issues.append(f"Datatype mismatches: {datatype_mismatches}")
    if nullable_mismatches:
        issues.append(f"Nullable mismatches: {nullable_mismatches}")
    
    # Primary key
    pk = inspector.get_pk_constraint(table)
    pk_cols = set(pk["constrained_columns"])
    missing_primary_keys = []
    for col_name, props in columns.items():
        if props.get("primary_key") and col_name in actual_columns:
            if col_name not in pk_cols:
                missing_primary_keys.append(col_name)
    if missing_primary_keys:
        issues.append(f"Missing primary keys: {missing_primary_keys}")
    
    # Unique
    uniques = inspector.get_unique_constraints(table)
    unique_cols = set()
    for uq in uniques:
        unique_cols.update(uq["column_names"])
    missing_unique_constraints = []
    for col_name, props in columns.items():
        if props.get("unique") and col_name in actual_columns:
            if col_name not in unique_cols:
                missing_unique_constraints.append(col_name)
    if missing_unique_constraints:
        issues.append(f"Missing unique constraints: {missing_unique_constraints}")
    
    # Report all issues at once
    if issues:
        pytest.fail(f"Issues in table {table}: " + "; ".join(issues))


# --- View tests ---
@pytest.mark.parametrize("view_name,expected_columns", list(expected_views.items()))
def test_views(view_name, expected_columns, inspector):
    actual_views = set(inspector.get_view_names())
    assert view_name in actual_views, f"View missing: {view_name}"
    columns = inspector.get_columns(view_name)
    actual_col_names = [col["name"] for col in columns]
    
    issues = []
    
    # Missing columns
    missing_columns = []
    for col in expected_columns:
        if col not in actual_col_names:
            missing_columns.append(col)
    if missing_columns:
        issues.append(f"Missing columns: {missing_columns}")
    
    # Extra columns
    extra_columns = []
    for col in actual_col_names:
        if col not in expected_columns:
            extra_columns.append(col)
    if extra_columns:
        issues.append(f"Extra columns: {extra_columns}")
    
    if issues:
        pytest.fail(f"Issues in view {view_name}: " + "; ".join(issues))

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
    
    missing_fks = []
    for fk in expected_fks_set:
        if fk not in actual_fks:
            missing_fks.append(fk)
    
    if missing_fks:
        pytest.fail(f"Missing foreign keys in {table}: {missing_fks}")

@pytest.mark.parametrize("table,expected_fks", list(expected_foreign_keys.items()))
def test_no_extra_foreign_keys(table, expected_fks, inspector):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    fks = inspector.get_foreign_keys(table)
    actual_fks = set((fk['constrained_columns'][0], fk['referred_table'], fk['referred_columns'][0]) for fk in fks)
    expected_fks_set = set(expected_fks)
    
    extra_fks = []
    for fk in actual_fks:
        if fk not in expected_fks_set:
            extra_fks.append(fk)
    
    if extra_fks:
        pytest.fail(f"Extra foreign keys in {table}: {extra_fks}")

# --- Row count and data tests ---
@pytest.mark.parametrize("table", list(expected_schema.keys()))
def test_row_counts_and_data(table, inspector, access_cursor, engine):
    if table not in inspector.get_table_names():
        pytest.skip(f"Table {table} missing")
    
    issues = []
    
    try:
        access_cursor.execute(f'SELECT COUNT(*) FROM [{table}]')
        access_count = access_cursor.fetchone()[0]
    except Exception as e:
        issues.append(f"Failed to get Access row count: {e}")
        access_count = None
    
    try:
        with engine.connect() as conn:
            pg_count = conn.execute(text(f'SELECT COUNT(*) FROM "{table}"')).fetchone()[0]
    except Exception as e:
        issues.append(f"Failed to get PostgreSQL row count: {e}")
        pg_count = None
    
    # Row count comparison
    if access_count is not None and pg_count is not None:
        if access_count != pg_count:
            issues.append(f"Row count mismatch: Access={access_count}, Postgres={pg_count}")
    
    # Data comparison for first 5 rows
    if access_count is not None and pg_count is not None and access_count == pg_count:
        try:
            # Get column names in order for both databases
            access_cursor.execute(f'SELECT * FROM [{table}]')
            access_desc = [desc[0] for desc in access_cursor.description]
            pg_desc = [col['name'] for col in inspector.get_columns(table)]
            access_rows = access_cursor.fetchmany(5)
            
            with engine.connect() as conn:
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
                
                if not rows_equal(access_rows, pg_rows_reordered):
                    issues.append(f"First 5 rows data mismatch: Access={access_rows}, Postgres={pg_rows_reordered}")
                    
        except Exception as e:
            issues.append(f"Failed to compare row data: {e}")
    
    if issues:
        pytest.fail(f"Issues in table {table}: " + "; ".join(issues))
