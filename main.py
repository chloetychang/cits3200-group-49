from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session, selectinload, joinedload

import uvicorn
from typing import List, Optional

from App.database import engine, get_db
from App.config import settings
from App import models
from App import schemas
from App import crud
from App.routes import auth
from App.routes.View_Routes import view_users
from App.routes.View_Routes import view_species
from App.routes.View_Routes import view_genetic_sources

app = FastAPI(
    title=settings.API_TITLE,
    description=settings.API_DESCRIPTION,
    version=settings.API_VERSION
)

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(view_users.router)
app.include_router(view_species.router)
app.include_router(view_genetic_sources.router)

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

# -------------------- Varieties --------------------
@app.get("/varieties/", response_model=List[schemas.VarietyResponse])
def get_varieties(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    """Get all varieties with pagination (A→Z)."""
    q = db.query(models.Variety).order_by(models.Variety.variety.asc())
    q = apply_pagination(q, skip=skip, limit=limit)
    return q.all()


# -------------------- Suppliers --------------------
@app.get("/suppliers/", response_model=List[schemas.SupplierResponse])
def get_suppliers(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    return crud.supplier.get_multi(db=db, skip=skip, limit=limit)

# -------------------- Users --------------------
@app.post("/users/", response_model=schemas.UserResponse)
def create_user(user_in: schemas.UserCreate, db: Session = Depends(get_db)):
    return crud.user.create(db, obj_in=user_in)

# -------------------- Plantings Create --------------------
@app.post("/plantings/", response_model=schemas.PlantingResponse)
def create_planting(planting_in: schemas.PlantingCreate, db: Session = Depends(get_db)):
    return crud.planting.create(db, obj_in=planting_in)
# -------------------- genetic_sources --------------------
@app.get("/genetic_sources_full/", response_model=List[schemas.GeneticSourceFullResponse])
def get_genetic_sources_full(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    """
    Get genetic sources with joined data from species, provenance, supplier, and propagation type
    """
    q = (
        db.query(models.GeneticSource)
        .options(
            joinedload(models.GeneticSource.variety).joinedload(models.Variety.species),
            joinedload(models.GeneticSource.provenance).joinedload(models.Provenance.location_type_rel),
            joinedload(models.GeneticSource.supplier),
            joinedload(models.GeneticSource.propagation_type_rel),
        )
        .order_by(models.GeneticSource.genetic_source_id.asc())
    )

    q = q.offset(skip)
    if limit:
        q = q.limit(limit)

    results = []
    for gs in q.all():
        results.append(
    schemas.GeneticSourceFullResponse(
        genetic_source_id=gs.genetic_source_id,
        acquisition_date=gs.acquisition_date,
        viability=gs.viability,
        female_genetic_source=gs.female_genetic_source,
        male_genetic_source=gs.male_genetic_source,
        price=gs.price,
        gram_weight=gs.gram_weight,
        landscape_only=gs.landscape_only,
        research_notes=gs.research_notes,
        supplier_lot_number=gs.supplier_lot_number,
        generation_number=gs.generation_number,
        species=schemas.SpeciesSimpleResponse.model_validate(gs.variety.species) if gs.variety and gs.variety.species else None,

        provenance=schemas.ProvenanceResponse.model_validate(gs.provenance) if gs.provenance else None,
        supplier=schemas.SupplierResponse.model_validate(gs.supplier) if gs.supplier else None,
        propagation_type=schemas.PropagationTypeResponse.model_validate(gs.propagation_type_rel) if gs.propagation_type_rel else None,
    )
)

    return results

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)