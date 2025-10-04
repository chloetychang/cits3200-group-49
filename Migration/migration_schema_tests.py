from sqlalchemy import create_engine, inspect, text
from sqlalchemy.dialects import postgresql
import pyodbc

# Connect to your database
# username: postgres username
# password: postgres password
# database: database name
# localhost:5432: PostgreSQL server address
engine = create_engine("postgresql+psycopg2://username:password@localhost:5432/database")

# Expected schema
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
    # Plantings_view is a view, so we skip it for now
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
    # Taxon is empty, skipping
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

inspector = inspect(engine)

# Dictionary to count each type of mismatch
mismatch_counts = {
    'missing_tables': 0,
    'extra_tables': 0,
    'missing_columns': 0,
    'extra_columns': 0,
    'datatype_mismatches': 0,
    'nullable_mismatches': 0,
    'unique_mismatches': 0,
    'primary_key_mismatches': 0,
    'missing_views': 0,
    'view_column_mismatches': 0,
}

actual_tables = set(inspector.get_table_names())
expected_tables = set(expected_schema.keys())

# --- View tests ---
expected_views = {
    "plantings_view": ["planted_by", "zone_number", "aspect", "taxon", "genus_and_species", "number_planted", "removal_date", "removal_cause", "number_removed", "comments", "date_planted"],
    "taxon": ["variety_id", "taxon", "genus", "species", "variety", "genus_and_species"],
}
actual_views = set(inspector.get_view_names())

# Check for missing and extra tables
for table in expected_tables:
    if table not in actual_tables:
        print(f"Table missing: {table}")
        mismatch_counts['missing_tables'] += 1
for table in actual_tables:
    if table not in expected_tables:
        print(f"Extra table: {table}")
        mismatch_counts['extra_tables'] += 1

# Check columns and constraints for tables that exist in both
for table in expected_tables & actual_tables:
    print(f"\nChecking table: {table}")
    columns = expected_schema[table]
    actual_columns = {col["name"]: col for col in inspector.get_columns(table)}

    # Missing columns
    for col_name in columns:
        if col_name not in actual_columns:
            print(f"    Column missing: {col_name}")
            mismatch_counts['missing_columns'] += 1
    # Extra columns
    for col_name in actual_columns:
        if col_name not in columns:
            print(f"    Extra column: {col_name}")
            mismatch_counts['extra_columns'] += 1
    # Datatype and nullable mismatches
    for col_name, props in columns.items():
        if col_name in actual_columns:
            actual_type = str(actual_columns[col_name]["type"]).upper()
            expected_type = props["type"].upper()
            if expected_type not in actual_type:
                print(f"    Datatype mismatch for {col_name}: found {actual_type}, expected {expected_type}")
                mismatch_counts['datatype_mismatches'] += 1
            if "nullable" in props and props["nullable"] != actual_columns[col_name]["nullable"]:
                print(f"    Nullable mismatch for {col_name}: found {actual_columns[col_name]['nullable']}, expected {props['nullable']}")
                mismatch_counts['nullable_mismatches'] += 1
    # Primary key mismatches
    pk = inspector.get_pk_constraint(table)
    pk_cols = set(pk["constrained_columns"])
    for col_name, props in columns.items():
        if props.get("primary_key") and col_name in actual_columns and col_name not in pk_cols:
            print(f"    Primary key missing for {col_name}")
            mismatch_counts['primary_key_mismatches'] += 1
    # Unique mismatches
    uniques = inspector.get_unique_constraints(table)
    unique_cols = set()
    for uq in uniques:
        unique_cols.update(uq["column_names"])
    for col_name, props in columns.items():
        if props.get("unique") and col_name in actual_columns and col_name not in unique_cols:
            print(f"    Unique constraint missing for {col_name}")
            mismatch_counts['unique_mismatches'] += 1

# Check views
for view_name, expected_columns in expected_views.items():
    print(f"\nChecking view: {view_name}")
    if view_name not in actual_views:
        print(f"View missing: {view_name}")
        mismatch_counts['missing_views'] += 1
    else:
        columns = inspector.get_columns(view_name)
        actual_col_names = [col["name"] for col in columns]
        # Check for missing columns
        for col in expected_columns:
            if col not in actual_col_names:
                print(f"    Column missing in view {view_name}: {col}")
                mismatch_counts['view_column_mismatches'] += 1
        # Check for extra columns
        for col in actual_col_names:
            if col not in expected_columns:
                print(f"    Extra column in view {view_name}: {col}")
                mismatch_counts['view_column_mismatches'] += 1

print("\nDatabase mismatch summary:")
for k, v in mismatch_counts.items():
    print(f"  {k.replace('_', ' ').capitalize()}: {v}")

# Row count and first 5 row comparison tests

ACCESS_DB_PATH = r'C:/Users/Tri/Desktop/Uni stuff/CITS3200/V02/Y-botanic.accdb'
ACCESS_CONN_STR = r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=' + ACCESS_DB_PATH + ';'
access_conn = pyodbc.connect(ACCESS_CONN_STR)
access_cur = access_conn.cursor()

for table in expected_tables & actual_tables:
    # Row count comparison
    access_cur.execute(f'SELECT COUNT(*) FROM [{table}]')
    access_count = access_cur.fetchone()[0]
    with engine.connect() as conn:
        pg_count = conn.execute(text(f'SELECT COUNT(*) FROM "{table}"')).fetchone()[0]
        # Get column names in order for both databases
        access_cur.execute(f'SELECT * FROM [{table}]')
        access_desc = [desc[0] for desc in access_cur.description]
        pg_desc = [col['name'] for col in inspector.get_columns(table)]
        # First 5 rows comparison
        access_rows = access_cur.fetchmany(5)
        pg_rows = conn.execute(text(f'SELECT * FROM "{table}" LIMIT 5')).fetchall()
        # Reorder Postgres rows to match Access column order
        pg_rows_reordered = []
        for row in pg_rows:
            row_dict = dict(zip(pg_desc, row))
            pg_rows_reordered.append(tuple(row_dict[col] for col in access_desc))
    if access_count != pg_count:
        print(f"Row count mismatch in table {table}: Access={access_count}, Postgres={pg_count}")
    # Type-agnostic row comparison: compare string representations
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
        print(f"First 5 rows mismatch in table {table}:")
        print(f"  Access:   {access_rows}")
        print(f"  Postgres: {pg_rows_reordered}")

engine.dispose()