import os
import sys
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add the parent directory to Python path to allow imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import App.models as models
from main import app
from App.database import get_db
from datetime import datetime
import warnings

SQLALCHEMY_DATABASE_URL = "sqlite:///./test_temp.db"
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="function")
def setup_db():
    models.Base.metadata.create_all(bind=engine)

    # Insert minimal seed data for required foreign keys and lookup tables
    db = TestingSessionLocal()
    # Users
    db.add(models.User(user_id=1, surname="Test", first_name="User", mobile="000", email="test@example.com", full_name="Test User"))
    # Zones
    db.add(models.Zone(zone_id=1, zone_number="Z1"))
    # Varieties
    db.add(models.Variety(variety_id=1))
    # Suppliers
    db.add(models.Supplier(supplier_id=1, supplier_name="Supplier", short_name="Sup", is_a_research_breeder=True))
    # Genetic Source (Acquisitions)
    db.add(models.GeneticSource(genetic_source_id=1, acquisition_date=datetime.now(), variety_id=1, supplier_id=1, generation_number=1, landscape_only=True))
    # Containers
    db.add(models.Container(container_type_id=1, container_type="Pot"))
    # Conservation Status
    if hasattr(models, "ConservationStatus"):
        db.add(models.ConservationStatus(status="Least Concern"))
    # Container Types
    if hasattr(models, "ContainerType"):
        db.add(models.ContainerType(container_type_id=2, container_type="Tray"))
    # Species
    if hasattr(models, "Species") and hasattr(models, "Genus"):
        # Insert a genus first (required FK)
        db.add(models.Genus(genus_id=1, family_id=1, genus="TestGenus"))
        db.commit()
        db.add(models.Species(species_id=1, species="Test Species", genus_id=1))
    db.commit()
    db.close()

    def override_get_db():
        db = TestingSessionLocal()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_get_db

    client = TestClient(app)
    try:
        yield client
    finally:
        # Teardown: drop all tables and clean up
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            models.Base.metadata.drop_all(bind=engine)
        engine.dispose()
        if os.path.exists("./test_temp.db"):
            os.remove("./test_temp.db")

def test_create_planting_request_response(setup_db):
    client = setup_db
    payload = {
        "date_planted": datetime.now().isoformat(),
        "number_planted": 10,
        "genetic_source_id": 1,
        "variety_id": 1,
        "planted_by": 1,
        "zone_id": 1,
        "container_type_id": 1,
        "comments": "Test planting"
    }
    response = client.post("/plantings/", json=payload)
    assert response.status_code in (200, 201)
    data = response.json()
    # Check that each field in the response matches the payload
    assert data["number_planted"] == payload["number_planted"]
    assert data["genetic_source_id"] == payload["genetic_source_id"]
    assert data["variety_id"] == payload["variety_id"]
    assert data["planted_by"] == payload["planted_by"]
    assert data["zone_id"] == payload["zone_id"]
    assert data["container_type_id"] == payload["container_type_id"]
    assert data["comments"] == payload["comments"]

    # Additional check: verify the planting exists in the database
    db = TestingSessionLocal()
    planting = db.query(models.Planting).filter_by(
        number_planted=payload["number_planted"],
        genetic_source_id=payload["genetic_source_id"],
        variety_id=payload["variety_id"],
        planted_by=payload["planted_by"],
        zone_id=payload["zone_id"],
        container_type_id=payload["container_type_id"],
        comments=payload["comments"]
    ).first()
    db.close()
    assert planting is not None, "Planting not found in database after creation"

# --- Acquisitions: Add/Update ---
def test_create_acquisition_request_response(setup_db):
    client = setup_db
    payload = {
        "acquisition_date": datetime.now().isoformat(),
        "variety_id": 1,
        "supplier_id": 1,
        "generation_number": 1,
        "landscape_only": True
    }
    response = client.post("/acquisitions/", json=payload)
    assert response.status_code in (200, 201)
    data = response.json()
    assert data["variety_id"] == payload["variety_id"]
    assert data["supplier_id"] == payload["supplier_id"]
    assert data["generation_number"] == payload["generation_number"]
    # DB check
    db = TestingSessionLocal()
    acquisition = db.query(models.GeneticSource).filter_by(
        variety_id=payload["variety_id"],
        supplier_id=payload["supplier_id"],
        generation_number=payload["generation_number"],
        landscape_only=payload["landscape_only"]
    ).first()
    db.close()
    assert acquisition is not None, "Acquisition not found in database after creation"

def test_update_acquisition_request_response(setup_db):
    client = setup_db
    # First, create
    payload = {
        "acquisition_date": datetime.now().isoformat(),
        "variety_id": 1,
        "supplier_id": 1,
        "generation_number": 1,
        "landscape_only": True
    }
    response = client.post("/acquisitions/", json=payload)
    assert response.status_code in (200, 201)
    data = response.json()
    acquisition_id = data.get("genetic_source_id")
    # Now, update
    update_payload = payload.copy()
    update_payload["generation_number"] = 2
    response = client.put(f"/acquisitions/{acquisition_id}", json=update_payload)
    assert response.status_code in (200, 201)
    updated = response.json()
    assert updated["generation_number"] == 2
    # DB check
    db = TestingSessionLocal()
    acquisition = db.query(models.GeneticSource).filter_by(
        genetic_source_id=acquisition_id
    ).first()
    db.close()
    assert acquisition is not None, "Acquisition not found in database after update"
    assert acquisition.generation_number == 2

# --- Plantings: Update ---
def test_update_planting_request_response(setup_db):
    client = setup_db
    # First, create
    payload = {
        "date_planted": datetime.now().isoformat(),
        "number_planted": 10,
        "genetic_source_id": 1,
        "variety_id": 1,
        "planted_by": 1,
        "zone_id": 1,
        "container_type_id": 1,
        "comments": "Test planting update"
    }
    response = client.post("/plantings/", json=payload)
    assert response.status_code in (200, 201)
    data = response.json()
    planting_id = data.get("planting_id")
    # Now, update
    update_payload = payload.copy()
    update_payload["number_planted"] = 20
    response = client.put(f"/plantings/{planting_id}", json=update_payload)
    assert response.status_code in (200, 201)
    updated = response.json()
    assert updated["number_planted"] == 20
    # DB check
    db = TestingSessionLocal()
    planting = db.query(models.Planting).filter_by(
        planting_id=planting_id
    ).first()
    db.close()
    assert planting is not None, "Planting not found in database after update"
    assert planting.number_planted == 20

# --- Manage Lookup Tables ---
def test_create_conservation_status(setup_db):
    client = setup_db
    payload = {"status": "Endangered"}
    response = client.post("/conservation-status/", json=payload)
    assert response.status_code in (200, 201)
    data = response.json()
    assert data["status"] == "Endangered"
    # DB check
    if hasattr(models, "ConservationStatus"):
        db = TestingSessionLocal()
        status = db.query(models.ConservationStatus).filter_by(status="Endangered").first()
        db.close()
        assert status is not None, "ConservationStatus not found in database after creation"

def test_create_container_type(setup_db):
    client = setup_db
    payload = {"container_type": "Tray"}
    response = client.post("/container-types/", json=payload)
    assert response.status_code in (200, 201)
    data = response.json()
    assert data["container_type"] == "Tray"
    # DB check
    if hasattr(models, "ContainerType"):
        db = TestingSessionLocal()
        ct = db.query(models.ContainerType).filter_by(container_type="Tray").first()
        db.close()
        assert ct is not None, "ContainerType not found in database after creation"

# --- View Tables ---
def test_view_users(setup_db):
    client = setup_db
    # Insert a user row directly
    db = TestingSessionLocal()
    new_user = models.User(user_id=2, surname="ViewTest", first_name="Unit", mobile="123", email="viewtest@example.com", full_name="Unit ViewTest")
    db.add(new_user)
    db.commit()
    db.close()
    # Query via API
    response = client.get("/users/")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    # Check that the inserted user is present
    assert any(user.get("surname") == "ViewTest" and user.get("email") == "viewtest@example.com" for user in data)

def test_view_species(setup_db):
    client = setup_db
    # Insert a species row directly
    if hasattr(models, "Species") and hasattr(models, "Genus"):
        db = TestingSessionLocal()
        # Insert a genus if not present
        genus = db.query(models.Genus).filter_by(genus_id=2).first()
        if not genus:
            db.add(models.Genus(genus_id=2, family_id=1, genus="ViewGenus"))
            db.commit()
        new_species = models.Species(species_id=2, species="ViewSpeciesTest", genus_id=2)
        db.add(new_species)
        db.commit()
        db.close()
    # Query via API
    response = client.get("/species/")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    # Check that the inserted species is present
    if hasattr(models, "Species"):
        assert any(species.get("species") == "ViewSpeciesTest" for species in data)