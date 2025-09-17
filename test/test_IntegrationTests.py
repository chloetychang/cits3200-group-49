import pytest
import httpx
import os
import time
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# Load test environment variables
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../App/.env'))
DB_HOST = os.getenv("DATABASE_HOST")
DB_PORT = os.getenv("DATABASE_PORT")
DB_NAME = os.getenv("DATABASE_NAME")
DB_USER = os.getenv("DATABASE_USER")
DB_PASSWORD = os.getenv("DATABASE_PASSWORD")

POSTGRES_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
API_URL = "http://localhost:8000"

@pytest.fixture(scope="module")
def db_engine():
	engine = create_engine(POSTGRES_URL)
	yield engine
	engine.dispose()

@pytest.fixture(scope="module")
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