from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import engine, get_db
from config import settings
import models
import schemas
import uvicorn
from typing import List

# Create all database tables
models.Base.metadata.create_all(bind=engine)

# Initialize FastAPI app
app = FastAPI(
    title=settings.API_TITLE,
    description=settings.API_DESCRIPTION,
    version=settings.API_VERSION
)

@app.get("/")
async def root():
    return {"message": "Welcome to Yanchep Plant Database API"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Example endpoints for testing
@app.get("/families/", response_model=List[schemas.FamilyResponse])
def read_families(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    families = db.query(models.Family).offset(skip).limit(limit).all()
    return families

@app.post("/families/", response_model=schemas.FamilyResponse)
def create_family(family: schemas.FamilyCreate, db: Session = Depends(get_db)):
    db_family = models.Family(**family.dict())
    db.add(db_family)
    db.commit()
    db.refresh(db_family)
    return db_family

@app.get("/species/", response_model=List[schemas.SpeciesResponse])
def read_species(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    species = db.query(models.Species).offset(skip).limit(limit).all()
    return species

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
