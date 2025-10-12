from fastapi import FastAPI, Depends, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session, selectinload, joinedload

from sqlalchemy.exc import IntegrityError
import uvicorn
from typing import List, Optional
from fastapi.middleware.cors import CORSMiddleware
from App.database import engine, get_db
from App.config import settings
from App import models
from App import schemas
from App import crud
from App.routes import auth
from App.routes.View_Routes import view_users
from App.routes.View_Routes import view_species
from App.routes.View_Routes import view_genetic_sources
from App.routes.View_Routes import view_progeny
from App.routes.View_Routes import view_suppliers
from App.routes.View_Routes import view_plantings
from App.routes.View_Routes import view_provenances
from App.routes.View_Routes import view_zone
from App.routes.View_Routes import view_subzones
from App.routes.Manage_Lookup_Routes import manage_lookup_conservation_status
from App.routes.Manage_Lookup_Routes import manage_lookup_container_type
from App.routes.Manage_Lookup_Routes import manage_plant_utility
from App.routes.Manage_Lookup_Routes import manage_removal_cause
from App.routes.Manage_Lookup_Routes import manage_lookup_provenance
from App.routes.Manage_Lookup_Routes import manage_lookup_propagation
from App.routes.Manage_Lookup_Routes import manage_lookup_species_utility
from App.routes.Manage_Lookup_Routes import manage_zone_aspect
from App.routes.Manage_Lookup_Routes import manage_zone_aspect
from App.routes.Add_Routes import add_acquisitions
from App.routes.Add_Routes import add_new_family
from App.routes.Add_Routes import add_provenances
from App.routes.Add_Routes import add_plantings
from App.routes.Add_Routes import add_varieties
from App.routes.Update_Routes import update_new_family
app = FastAPI(
    title=settings.API_TITLE,
    description=settings.API_DESCRIPTION,
    version=settings.API_VERSION
    
)

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(view_users.router)
app.include_router(view_species.router)
app.include_router(view_genetic_sources.router)
app.include_router(view_progeny.router)
app.include_router(view_suppliers.router)
app.include_router(view_plantings.router)
app.include_router(view_provenances.router)
app.include_router(view_zone.router)
app.include_router(view_subzones.router)
app.include_router(manage_lookup_conservation_status.router)
app.include_router(manage_lookup_container_type.router)
app.include_router(manage_plant_utility.router)
app.include_router(manage_removal_cause.router)
app.include_router(manage_lookup_provenance.router)
app.include_router(manage_lookup_propagation.router)
app.include_router(manage_lookup_species_utility.router_su) 
app.include_router(manage_lookup_species_utility.router_s)
app.include_router(manage_zone_aspect.router)
app.include_router(add_acquisitions.router)
app.include_router(add_new_family.router)
app.include_router(add_provenances.router)
app.include_router(add_plantings.router)
app.include_router(add_varieties.router)
app.include_router(update_new_family.router)


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


# -------------------- Add Screens --------------------------
# -------------------- API for Planting Source Page --------------------------
# TODO: Creation of Genetic Source dropdown (To be done - currently missing data 25/09/25)

# Creation of Planted Full name by dropdown
@app.get("/plantings/planted_by", response_model=List[schemas.UserResponse])
def get_planted_by_dropdown(db: Session = Depends(get_db)):
    """Get all planted by options for dropdown (A→Z), returning only full_name."""
    users = db.query(models.User).order_by(models.User.full_name.asc()).all()
    return [schemas.UserResponse.model_validate(user).model_dump() for user in users]

# Creation of Zone Number dropdown
@app.get("/plantings/zone_number", response_model=List[schemas.ZoneResponse])
def get_zone_dropdown(db: Session = Depends(get_db)):
    """Get all zones for dropdown (A→Z)."""
    zone_list = db.query(models.Zone).order_by(models.Zone.zone_number.asc()).all()
    return [schemas.ZoneResponse.model_validate(zone).model_dump() for zone in zone_list]

# Creation of Container Type dropdown
@app.get("/plantings/container_type", response_model=List[schemas.ContainerResponse])
def get_container_type_dropdown(db: Session = Depends(get_db)):
    """Get all container types for dropdown (A→Z)."""
    container_type_list = db.query(models.Container).order_by(models.Container.container_type.asc()).all()
    return [schemas.ContainerResponse.model_validate(ct).model_dump() for ct in container_type_list]

# -------------------- API for Progeny Source Page --------------------------
# Creation of a Family name dropdown 
@app.get("/progeny/family_name", response_model=List[schemas.FamilyResponse])
def get_family_name_dropdown(db: Session = Depends(get_db)):
    """Get all family names for dropdown (A→Z)."""
    family_list = db.query(models.Family).order_by(models.Family.famiy_name.asc()).all()
    return [schemas.FamilyResponse.model_validate(f).model_dump() for f in family_list]


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)