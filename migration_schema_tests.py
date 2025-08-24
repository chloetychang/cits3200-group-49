from sqlalchemy import create_engine, inspect
from sqlalchemy.dialects import postgresql

# Define your expected schema
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
        "family_name": {"type": "VARCHAR", "nullable": False, "unique": True},
    },
    "genetic_source": {
        "genetic_source_id": {"type": "INTEGER", "primary_key": True},
        "acquisition_date": {"type": "TIMESTAMP", "nullable": False},
        "variety_id": {"type": "INTEGER", "nullable": False},
        "supplier_id": {"type": "INTEGER", "nullable": False},
        "supplier_lot_number": {"type": "VARCHAR", "nullable": True},
        "price": {"type": "NUMERIC", "nullable": True},
        "gram_weight": {"type": "NUMERIC", "nullable": True},
        "provenance_id": {"type": "INTEGER", "nullable": True},
        "viability": {"type": "NUMERIC", "nullable": True},
        "propogation_type": {"type": "NUMERIC", "nullable": True},
        "female_genetic_source": {"type": "NUMERIC", "nullable": True},
        "male_genetic_source": {"type": "NUMERIC", "nullable": True},
        "generation_number": {"type": "NUMERIC", "nullable": False},
        "lanscape_only": {"type": "BOOLEAN", "nullable": False},
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
        "planted_by": {"type": "NUMERIC", "nullable": True},
        "zone_id": {"type": "INTEGER", "nullable": False},
        "variety_id": {"type": "INTEGER", "nullable": False},
        "number_planted": {"type": "INTEGER", "nullable": False},
        "genetic_source": {"type": "NUMERIC", "nullable": True},
        "container_type_id": {"type": "INTEGER", "nullable": False},
        "number_removed": {"type": "INTEGER", "nullable": True},
        "removal_cause_id": {"type": "INTEGER", "nullable": True},
        "comments": {"type": "TEXT", "nullable": True},
    },
    # Plantings_view is a view, so we skip it for now
    "progeny": {
        "progeny_id": {"type": "INTEGER", "unique": True, "nullable": True},
        "genetic_source_id": {"type": "INTEGER", "primary_key": True},
        "sibling_number": {"type": "INTEGER", "primary_key": True},
        "child_name": {"type": "VARCHAR", "nullable": False},
        "date_germinated": {"type": "TIMESTAMP", "nullable": False},
        "comments": {"type": "VARCHAR", "nullable": True},
    },
    "propogation_type": {
        "propogation_type_id": {"type": "INTEGER", "primary_key": True},
        "propogation_type": {"type": "VARCHAR", "nullable": True},
        "needs_two_parents": {"type": "BOOLEAN", "nullable": False},
        "can_cross_genera": {"type": "BOOLEAN", "nullable": False},
    },
    "provenance": {
        "provenance_id": {"type": "INTEGER", "nullable": True},
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
        "is_a_research_breeder": {"type": "BOOLEAN", "nullable": False},
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

# Connect to your database
engine = create_engine("postgresql+psycopg2://username:password@localhost:5432/your_db")
inspector = inspect(engine)

for table, columns in expected_schema.items():
    print(f"\nChecking table: {table}")
    if table not in inspector.get_table_names():
        print(f"  Table {table} is missing!")
        continue

    actual_columns = {col["name"]: col for col in inspector.get_columns(table)}
    for col_name, props in columns.items():
        if col_name not in actual_columns:
            print(f"    Column {col_name} missing in {table}")
            continue
        actual_type = str(actual_columns[col_name]["type"]).upper()
        expected_type = props["type"].upper()
        if expected_type not in actual_type:
            print(f"    Column {col_name} type mismatch: found {actual_type}, expected {expected_type}")
        if "nullable" in props and props["nullable"] != actual_columns[col_name]["nullable"]:
            print(f"    Column {col_name} nullability mismatch: found {actual_columns[col_name]['nullable']}, expected {props['nullable']}")
    # Check for extra columns
    for col_name in actual_columns:
        if col_name not in columns:
            print(f"    Extra column {col_name} found in {table}")

    # Check primary keys
    pk = inspector.get_pk_constraint(table)
    pk_cols = set(pk["constrained_columns"])
    for col_name, props in columns.items():
        if props.get("primary_key") and col_name not in pk_cols:
            print(f"    Column {col_name} should be PRIMARY KEY but is not.")

    # Check unique constraints
    uniques = inspector.get_unique_constraints(table)
    unique_cols = set()
    for uq in uniques:
        unique_cols.update(uq["column_names"])
    for col_name, props in columns.items():
        if props.get("unique") and col_name not in unique_cols:
            print(f"    Column {col_name} should be UNIQUE but is not.")

engine.dispose()