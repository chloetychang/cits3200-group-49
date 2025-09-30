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
app = FastAPI(
    title=settings.API_TITLE,
    description=settings.API_DESCRIPTION,
    version=settings.API_VERSION
    
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
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


# -------------------- Add Screens --------------------------
# -------------------- API for Acquistion Source Page --------------------------
# For Old Species + Variety - It requires "genus" and "species"
# Creation of a genus dropdown
@app.get("/acquisition/genus", response_model=List[schemas.GenusResponse])
def get_genus_dropdown(db: Session = Depends(get_db)):
    """Get all genus names for dropdown (A→Z)."""
    genus_list = db.query(models.Genus).order_by(models.Genus.genus.asc()).all()
    return [schemas.GenusResponse.model_validate(g).model_dump() for g in genus_list]

# Creation of a species dropdown
@app.get("/acquisition/species", response_model=List[schemas.SpeciesResponse])
def get_species_dropdown(db: Session = Depends(get_db)):
    """Get all species names for dropdown (A→Z)."""
    species = db.query(models.Species).order_by(models.Species.species.asc()).all()
    return [schemas.SpeciesResponse.model_validate(s).model_dump() for s in species]

# Creation of a supplier dropdown
@app.get("/acquisition/suppliers", response_model=List[schemas.SupplierResponse])
def get_supplier_dropdown(db: Session = Depends(get_db)):
    """Get all supplier names for dropdown (A→Z)."""
    suppliers = db.query(models.Supplier).order_by(models.Supplier.supplier_name.asc()).all()
    return [schemas.SupplierResponse.model_validate(s).model_dump() for s in suppliers]

# Creation of a provenance dropdown
@app.get("/acquisition/provenance_locations", response_model=List[schemas.ProvenanceResponse])
def get_provenance_location_dropdown(db: Session = Depends(get_db)):
    """Get all provenance locations for dropdown (A→Z)."""
    provenances = db.query(models.Provenance).order_by(models.Provenance.location.asc())
    return [schemas.ProvenanceResponse.model_validate(p).model_dump() for p in provenances]

@app.get("/acquisition/bioregion_code", response_model=List[schemas.BioregionResponse])
def get_bioregion_dropdown(db: Session = Depends(get_db)):
    """Get all bioregion codes for dropdown (A→Z)."""
    bioregions = db.query(models.Bioregion).order_by(models.Bioregion.bioregion_code.asc()).all()
    return [schemas.BioregionResponse.model_validate(b).model_dump() for b in bioregions]

# TODO: Family name dropdown - Missing due to data model changes [left as placeholder]

# TODO: Generation number dropdown - Missing due to data model changes [left as placeholder]

# TODO: Fix POST Request on Acquisition model
@app.post("/acquisition/", response_model=List[schemas.GeneticSourceResponse])
def create_acquisition(
    acquisition: schemas.AcquisitionCreate = Body(...),
    db: Session = Depends(get_db)
):
    genetic_source = acquisition.genetic_source
    supplier = acquisition.supplier
    provenance = acquisition.provenance

    # Lookup or create supplier
    supplier_obj = crud.supplier.get_by_name(db, name=supplier.supplier_name)
    if not supplier_obj:
        supplier_obj = crud.supplier.create(db, obj_in=supplier)
    supplier_id = supplier_obj.supplier_id

    # Lookup or create provenance
    provenance_obj = crud.provenance.get_by_location(db, location=provenance.location)
    if not provenance_obj:
        provenance_obj = crud.provenance.create(db, obj_in=provenance)
    provenance_id = provenance_obj.provenance_id

    # Lookup or create variety (if needed)
    variety_id = getattr(genetic_source, "variety_id", None)
    if not variety_id:
        variety_name = getattr(genetic_source, "variety", None)
        species_name = getattr(genetic_source, "species", None)
        if variety_name and species_name:
            # Lookup species by name
            species_obj = crud.species.get_by_name(db, name=species_name)
            if not species_obj:
                # Create species if not found
                species_obj = crud.species.create(db, obj_in={"species": species_name})
            species_id = species_obj.species_id
            # Lookup variety by name and species_id
            variety_obj = crud.variety.get_by_name_and_species(db, name=variety_name, species_id=species_id)
            if not variety_obj:
                variety_obj = crud.variety.create(db, obj_in={"variety": variety_name, "species_id": species_id})
            variety_id = variety_obj.variety_id
        elif variety_name:
            # Fallback: create variety without species
            variety_obj = crud.variety.get_by_name(db, name=variety_name)
            if not variety_obj:
                variety_obj = crud.variety.create(db, obj_in={"variety": variety_name})
            variety_id = variety_obj.variety_id
        else:
            raise HTTPException(status_code=400, detail="Variety info required (provide variety and species names if new)")

    # Lookup or create family (if needed)
    family_id = None
    if hasattr(genetic_source, "family_name") and genetic_source.family_name:
        family_obj = crud.family.get_by_name(db, name=genetic_source.family_name)
        if not family_obj:
            family_obj = crud.family.create(db, obj_in={"famiy_name": genetic_source.family_name})
        family_id = family_obj.family_id

    gs_data = genetic_source.model_dump()
    gs_data["supplier_id"] = supplier_id
    gs_data["provenance_id"] = provenance_id
    gs_data["variety_id"] = variety_id
    if family_id:
        gs_data["family_id"] = family_id

    try:
        gs_obj = crud.genetic_source.create(db, obj_in=schemas.GeneticSourceCreate(**gs_data))
    except IntegrityError:
        raise HTTPException(status_code=400, detail="Failed to create Acquisition")
    return gs_obj

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

# -------------------- API for New Family Source Page --------------------------
# Creation of a Propagation Type dropdown
@app.get("/newfamily/propagation_type", response_model=List[schemas.PropagationTypeResponse])
def get_propagation_type_dropdown(db: Session = Depends(get_db)):
    """Get all propagation types for dropdown (A→Z)."""
    propagation_type_list = db.query(models.PropagationType).order_by(models.PropagationType.propagation_type.asc()).all()
    return [schemas.PropagationTypeResponse.model_validate(pt).model_dump() for pt in propagation_type_list]

# TODO: Creation of a Breeding Team dropdown (To be done - currently missing data 25/09/25)

# Creation of a provenance dropdown
@app.get("/newfamily/provenance_locations", response_model=List[schemas.ProvenanceResponse])
def get_provenance_location_dropdown(db: Session = Depends(get_db)):
    """Get all provenance locations for dropdown (A→Z)."""
    provenances = db.query(models.Provenance).order_by(models.Provenance.location.asc())
    return [schemas.ProvenanceResponse.model_validate(p).model_dump() for p in provenances]

# -------------------- API for Progeny Source Page --------------------------
# Creation of a Family name dropdown 
@app.get("/progeny/family_name", response_model=List[schemas.FamilyResponse])
def get_family_name_dropdown(db: Session = Depends(get_db)):
    """Get all family names for dropdown (A→Z)."""
    family_list = db.query(models.Family).order_by(models.Family.famiy_name.asc()).all()
    return [schemas.FamilyResponse.model_validate(f).model_dump() for f in family_list]


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)