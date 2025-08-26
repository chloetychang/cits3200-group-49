# Migration test checklist
**These tests were designed with V02 of the prototype in mind**
Last updated: 24/08/25

Ideas: Python (psycopg2/SQLAlchemy) and query schema

## Initial migration (postgres created) tests
* Tables migrated
Note: To test column types and constraints, may be only necessary to check one of each datatype, and every combination of Primary, Required (not NULL) and Unique available. 
    - Aspect
        - aspect_id: integer Primary
        - aspect: string Required, Unique
    - Bioregion
        - bioregion_code: string Primary
        - region_name: string Required
    - Conservation_status
        - conservation_status_id: integer Primary
        - status: string Required, Unique
        - status_short_name: string
    - Container
        - container_type_id: Primary
        - container_type: string Required
    - Family
        - family_id: integer Primary
        - family_name: string Required, Unique
    - Genetic_source
        - genetic_source_id: integer Primary
        - acquisition_date: date/time Required
        - variety_id: integer? Required
        - supplier_id: integer? Required
        - supplier_lot_number: string
        - price: currency
        - gram_weight: number
        - provenance_id: integer
        - viability: number
        - propogation_type: number
        - female_genetic_source: number
        - male_genetic_source: number
        - generation_number: number Required
        - lanscape_only: boolean Required
        - research_notes: long_text
    - Genus
        - genus_id: integer Primary
        - family_id: integer? Required
        - genus: string Required, Unique
    - Location_type
        - location_type_id: Integer Primary
        - location_type: string
    - Plant_utility
        - plant_utility_id: integer Primary
        - utility: string Required, Unique
    - Planting
        - planting_id: integer, Primary
        - date_planted: date/time Required
        - planted_by: number 
        - zone_id: integer? Required
        - variety_id: integer? Required
        - number_planted: integer Required
        - genetic_source: number
        - container_type_id: integer? Required
        - number_removed: integer
        - removal_cause_id: integer
        - comments: long_text
    - Plantings_view
        - 
    - Progeny
        - progeny_id: integer Unique
        - genetic_source_id: integer Primary
        - sibling_number: integer Primary
        - child_name: string Required
        - date_germinated: date/time Required
        - comments: string
    - Propogation_type
        - propogation_type_id: integer Primary
        - propogation_type: string
        - needs_two_parents: boolean Required
        - can_cross_genera: boolean Required
    - Provenance
        - provenance_id: integer
        - bioregion_code: string Required
        - location: string
        - location_type_id: integer? 
        - extra_details: string
    - Removal_cause
        - removal_cause_id: integer Primary
        - cause: string Required, Unique
    - Role
        - role_id: integer Primary
        - role: string Required, Unique
        - description: string
    - Species
        - species_id: integer Primary
        - genus_id: integer Required
        - species: string Required
        - conservation_status_id: integer
    - Species_utility_link
        - species_id: integer Primary
        - plant_utility_id: integer Primary
    - Sub_zone
        - sub_zone_id: integer Primary
        - zone_id: integer
        - sub_zone_code: string
        - aspect_id: integer
        - exposure_to_wind: string
        - shade: string
    - Supplier
        - supplier_id: integer Primary
        - supplier_name: string Required, Unique
        - short_name: string Required, Unique
        - web_site: string
        - is_a_research_breeder: boolean Required
    - Taxon
        - 
    - User
        - user_id: integer Primary
        - title: string
        - surname: string Required
        - first_name: string Required
        - preferred_name: string
        - address_line_1: string
        - address_line_2: string
        - locality: string
        - postcode: integer
        - work_phone: string
        - mobile: string Required
        - email: string Required
        - full_name: string Required
        - password: string
    - User_role_link
        - user_id: integer Primary
        - role_id: integer Primary
    - Variety
        - variety_id: integer Primary
        - species_id: integer?
        - common_name: string
        - variety: string
        - genetic_source_id: integer Unique
    - Zone
        - zone_id: integer Primary
        - zone_number: string Required, Unique
        - zone_name: string
        - aspect_id: integer
        - exposure_to_wind: string
        - shade: string
* Data migrated tests
    - First 5 rows match
    - Number of rows match
* Foreign key tests
    - Refer to the relationships diagram

## Migrating to existing postgres tests (sprint 3)
* Additional data test
    - New data added to accessDB is reflected in migrated database
* Modified column
    - Column datatype/constraint is modified, and is reflected in migration
* Removed column
    - Column is removed, and is not present after migration
* Removed table
    - Table is removed, and is not present after migration
