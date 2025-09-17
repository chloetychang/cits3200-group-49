from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from database import engine, get_db
from config import settings
import models
import schemas
import uvicorn
from typing import List
import crud

# Create all database tables
# models.Base.metadata.create_all(bind=engine)

# Initialize FastAPI app
app = FastAPI(
    title=settings.API_TITLE,
    description=settings.API_DESCRIPTION,
    version=settings.API_VERSION
)

app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"https?://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
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

@app.get("/users/", response_model=List[schemas.UserResponse])
def get_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Get all users with pagination"""
    users = crud.user.get_multi(db=db, skip=skip, limit=limit)
    return users

@app.post("/users/", response_model=schemas.UserResponse)
def create_user(user_in: schemas.UserCreate, db: Session = Depends(get_db)):
    """Create a new user"""
    db_user = crud.user.create(db, obj_in=user_in)
    return db_user


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)
