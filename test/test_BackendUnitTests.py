import os
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
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

    # Insert minimal seed data for required foreign keys
    db = TestingSessionLocal()
    db.add(models.User(user_id=1, surname="Test", first_name="User", mobile="000", email="test@example.com", full_name="Test User"))
    db.add(models.Zone(zone_id=1, zone_number="Z1"))
    db.add(models.Variety(variety_id=1))
    db.add(models.GeneticSource(genetic_source_id=1, acquisition_date=datetime.now(), variety_id=1, supplier_id=1, generation_number=1, landscape_only=True))
    db.add(models.Container(container_type_id=1, container_type="Pot"))
    db.add(models.Supplier(supplier_id=1, supplier_name="Supplier", short_name="Sup", is_a_research_breeder=True))
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
        # Suppress cyclic FK warning during drop_all
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            models.Base.metadata.drop_all(bind=engine)
        # Dispose engine to close all connections
        engine.dispose()
        # Remove the temp database file
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