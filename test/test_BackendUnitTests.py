import pytest
from fastapi.testclient import TestClient
from App.main import app
from datetime import datetime

client = TestClient(app)

def test_create_planting_request_response():
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