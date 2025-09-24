import pytest
import httpx
import os
import time
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# Integration/backend patterns notes
# add pages, update pages, manage view tables, view table
# View table likely can be generalised, manage view tables and add/update will likely have subpatterns

# Load test environment variables
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../App/.env'))
DB_HOST = os.getenv("DATABASE_HOST")
DB_PORT = os.getenv("DATABASE_PORT")
DB_NAME = os.getenv("DATABASE_NAME")
DB_USER = os.getenv("DATABASE_USER")
DB_PASSWORD = os.getenv("DATABASE_PASSWORD")

POSTGRES_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
API_URL = "http://localhost:8000"

@pytest.fixture(scope="function")
def db_engine():
	engine = create_engine(POSTGRES_URL)
	yield engine
	engine.dispose()

@pytest.fixture(scope="function")
def client():
	with httpx.Client(base_url=API_URL) as c:
		yield c

def test_create_and_fetch_planting(client, db_engine):
	# Create a planting via API
	payload = {
		"date_planted": "2025-09-17T12:00:00",
		"number_planted": 5,
		"genetic_source_id": 2,
		"variety_id": 1,
		"planted_by": 1,
		"zone_id": 1,
		"container_type_id": 1,
		"comments": "Integration test planting"
	}
	start = time.time()
	response = client.post("/plantings/", json=payload)
	duration = time.time() - start
	assert duration < 3.0, f"API interaction took too long: {duration:.2f} seconds"
	assert response.status_code in (200, 201)
	data = response.json()
	# Check response matches payload
	for key in payload:
		assert data[key] == payload[key]
	# Check DB for inserted planting
	with db_engine.connect() as conn:
		result = conn.execute(text("SELECT * FROM planting WHERE comments=:comments"), {"comments": payload["comments"]})
		row = result.mappings().fetchone()
		assert row is not None, "Planting not found in DB after API creation"
		assert row["number_planted"] == payload["number_planted"]
		assert row["comments"] == payload["comments"]

	# Teardown: remove the test planting
	with db_engine.connect() as conn:
		conn.execute(text("DELETE FROM planting WHERE comments=:comments"), {"comments": payload["comments"]})
		conn.commit()

# --- Acquisitions: Add/Update ---
def test_create_and_update_acquisition(client, db_engine):
	# Create acquisition via API
	payload = {
		"acquisition_date": "2025-09-17T12:00:00",
		"variety_id": 1,
		"supplier_id": 1,
		"generation_number": 1,
		"landscape_only": True
	}
	start = time.time()
	response = client.post("/acquisitions/", json=payload)
	duration = time.time() - start
	assert duration < 3.0, f"API interaction took too long: {duration:.2f} seconds"
	assert response.status_code in (200, 201)
	data = response.json()
	for key in payload:
		assert data[key] == payload[key]
	acquisition_id = data.get("genetic_source_id")
	# Check DB for inserted acquisition
	with db_engine.connect() as conn:
		result = conn.execute(text("SELECT * FROM genetic_source WHERE generation_number=:generation_number AND variety_id=:variety_id AND supplier_id=:supplier_id"), {
			"generation_number": payload["generation_number"],
			"variety_id": payload["variety_id"],
			"supplier_id": payload["supplier_id"]
		})
		row = result.mappings().fetchone()
		assert row is not None, "Acquisition not found in DB after API creation"
		assert row["generation_number"] == payload["generation_number"]
	# Update acquisition
	update_payload = payload.copy()
	update_payload["generation_number"] = 2
	start = time.time()
	response = client.put(f"/acquisitions/{acquisition_id}", json=update_payload)
	duration = time.time() - start
	assert duration < 3.0, f"API interaction took too long: {duration:.2f} seconds"
	assert response.status_code in (200, 201)
	updated = response.json()
	assert updated["generation_number"] == 2
	# Check DB for update
	with db_engine.connect() as conn:
		result = conn.execute(text("SELECT * FROM genetic_source WHERE genetic_source_id=:id"), {"id": acquisition_id})
		row = result.mappings().fetchone()
		assert row is not None
		assert row["generation_number"] == 2
	# Teardown: remove the test acquisition
	with db_engine.connect() as conn:
		conn.execute(text("DELETE FROM genetic_source WHERE genetic_source_id=:id"), {"id": acquisition_id})
		conn.commit()
		assert row["generation_number"] == 2

# --- Conservation Status ---
def test_create_conservation_status(client, db_engine):
	payload = {"status": "Endangered"}
	start = time.time()
	response = client.post("/conservation-status/", json=payload)
	duration = time.time() - start
	assert duration < 3.0, f"API interaction took too long: {duration:.2f} seconds"
	assert response.status_code in (200, 201)
	data = response.json()
	assert data["status"] == "Endangered"
	# DB check
	with db_engine.connect() as conn:
		result = conn.execute(text("SELECT * FROM conservation_status WHERE status=:status"), {"status": payload["status"]})
		row = result.mappings().fetchone()
		assert row is not None, "ConservationStatus not found in DB after creation"
	# Teardown: remove the test conservation status
	with db_engine.connect() as conn:
		conn.execute(text("DELETE FROM conservation_status WHERE status=:status"), {"status": payload["status"]})
		conn.commit()

# --- Container Type ---
def test_create_container_type(client, db_engine):
	payload = {"container_type": "Tray"}
	start = time.time()
	response = client.post("/container-types/", json=payload)
	duration = time.time() - start
	assert duration < 3.0, f"API interaction took too long: {duration:.2f} seconds"
	assert response.status_code in (200, 201)
	data = response.json()
	assert data["container_type"] == "Tray"
	# DB check
	with db_engine.connect() as conn:
		result = conn.execute(text("SELECT * FROM container WHERE container_type=:container_type"), {"container_type": payload["container_type"]})
		row = result.mappings().fetchone()
		assert row is not None, "ContainerType not found in DB after creation"
	# Teardown: remove the test container type
	with db_engine.connect() as conn:
		conn.execute(text("DELETE FROM container WHERE container_type=:container_type"), {"container_type": payload["container_type"]})
		conn.commit()

# --- View Users ---
def test_view_users(client, db_engine):
	# Query via API only, do not insert test data
	start = time.time()
	response = client.get("/users/")
	duration = time.time() - start
	assert duration < 3.0, f"API interaction took too long: {duration:.2f} seconds"
	assert response.status_code == 200
	data = response.json()
	assert isinstance(data, list)
	# Check that user_id 1, 2, 3 exist anywhere in the response
	expected_ids = {1, 3}
	actual_ids = {user.get("user_id") for user in data}
	missing = expected_ids - actual_ids
	assert not missing, f"User IDs {missing} not found in response"

# --- View Species ---
def test_view_species(client, db_engine):
	# Query via API only, do not insert test data
	start = time.time()
	response = client.get("/species/")
	duration = time.time() - start
	assert duration < 3.0, f"API interaction took too long: {duration:.2f} seconds"
	assert response.status_code == 200
	data = response.json()
	assert isinstance(data, list)
	# Check that species_id 1, 2, 3, 4, 5 exist anywhere in the response
	expected_ids = {1, 2, 3, 4, 5}
	actual_ids = {species.get("species_id") for species in data}
	missing = expected_ids - actual_ids
	assert not missing, f"Species IDs {missing} not found in response"