from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
import uvicorn
from typing import List

from App.database import engine, get_db
from App.config import settings
from App import models
from App import schemas
from App import crud

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

@app.get("/plantings/", response_model=List[schemas.PlantingResponse])
def get_plantings(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Get all plantings with pagination"""
    plantings = crud.planting.get_multi(db=db, skip=skip, limit=limit)
    return plantings

@app.get("/families/", response_model=List[schemas.FamilyResponse])
def get_families(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Get all plant families with pagination"""
    families = crud.family.get_multi(db=db, skip=skip, limit=limit)
    return families

@app.get("/species/", response_model=List[schemas.SpeciesResponse])
def get_species(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Get all species with pagination"""
    species = crud.species.get_multi(db=db, skip=skip, limit=limit)
    return species

@app.get("/suppliers/", response_model=List[schemas.SupplierResponse])
def get_suppliers(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Get all suppliers with pagination"""
    suppliers = crud.supplier.get_multi(db=db, skip=skip, limit=limit)
    return suppliers

@app.post("/plantings/", response_model=schemas.PlantingResponse)
def create_planting(planting_in: schemas.PlantingCreate, db: Session = Depends(get_db)):
    db_planting = crud.planting.create(db, obj_in=planting_in)
    return db_planting

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)
