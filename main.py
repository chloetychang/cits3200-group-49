from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session, selectinload
import uvicorn
from typing import List, Optional

from App.database import engine, get_db
from App.config import settings
from App import models
from App import schemas
from App import crud

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

def apply_pagination(query, skip: int = 0, limit: Optional[int] = None):
    if skip:
        query = query.offset(skip)
    if isinstance(limit, int) and limit > 0:
        query = query.limit(limit)
    return query

# -------------------- Plantings --------------------
@app.get("/plantings/", response_model=List[schemas.PlantingResponse])
def get_plantings(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    return crud.planting.get_multi(db=db, skip=skip, limit=limit)

# -------------------- Families --------------------
@app.get("/families/", response_model=List[schemas.FamilyResponse])
def get_families(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    return crud.family.get_multi(db=db, skip=skip, limit=limit)

# -------------------- Species --------------------
@app.get("/species/", response_model=List[schemas.SpeciesResponse])
def get_species(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    q = db.query(models.Species).order_by(models.Species.species.asc())
    q = apply_pagination(q, skip=skip, limit=limit)
    return q.all()

@app.get("/species_with_varieties/", response_model=List[schemas.SpeciesWithVarietyResponse])
def get_species_with_varieties(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    q = (
        db.query(models.Species)
        .options(selectinload(models.Species.varieties))
        .order_by(models.Species.species.asc())
    )
    species_list = apply_pagination(q, skip=skip, limit=limit).all()

    result = []
    for s in species_list:
        sorted_vars = sorted(s.varieties or [], key=lambda v: (v.variety or "").lower())
        result.append({
            "species_id": s.species_id,
            "species": s.species,
            "varieties": sorted_vars,
        })
    return result

# -------------------- Varieties --------------------
@app.get("/varieties/", response_model=List[schemas.VarietyResponse])
def get_varieties(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    """Get all varieties with pagination (A→Z)."""
    q = db.query(models.Variety).order_by(models.Variety.variety.asc())
    q = apply_pagination(q, skip=skip, limit=limit)
    return q.all()

@app.get("/varieties/{variety_id}", response_model=schemas.VarietyResponse)
def get_variety(variety_id: int, db: Session = Depends(get_db)):
    v = crud.variety.get(db=db, id=variety_id)
    if not v:
        raise HTTPException(status_code=404, detail="Variety not found")
    return v

@app.get("/varieties/by_species/{species_id}", response_model=List[schemas.VarietyResponse])
def get_varieties_by_species(species_id: int, db: Session = Depends(get_db)):
    """Get all varieties under a specific species (A→Z)."""
    sp = crud.species.get(db=db, id=species_id)
    if not sp:
        raise HTTPException(status_code=404, detail="Species not found")
    q = (
        db.query(models.Variety)
        .filter(models.Variety.species_id == species_id)
        .order_by(models.Variety.variety.asc())
    )
    return q.all()

# -------------------- Suppliers --------------------
@app.get("/suppliers/", response_model=List[schemas.SupplierResponse])
def get_suppliers(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    return crud.supplier.get_multi(db=db, skip=skip, limit=limit)

# -------------------- Users --------------------
@app.get("/users/", response_model=List[schemas.UserResponse])
def get_users(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    return crud.user.get_multi(db=db, skip=skip, limit=limit)

@app.post("/users/", response_model=schemas.UserResponse)
def create_user(user_in: schemas.UserCreate, db: Session = Depends(get_db)):
    return crud.user.create(db, obj_in=user_in)

# -------------------- Plantings Create --------------------
@app.post("/plantings/", response_model=schemas.PlantingResponse)
def create_planting(planting_in: schemas.PlantingCreate, db: Session = Depends(get_db)):
    return crud.planting.create(db, obj_in=planting_in)

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)