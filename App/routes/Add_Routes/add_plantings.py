from fastapi import APIRouter, HTTPException, Depends, Body
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List, Optional

from App.database import get_db
from App import models, schemas, crud

# ================== ROUTER ==================

router = APIRouter(
    prefix="/planting",
    tags=["plantings"]
)

# ================== DROPDOWN ROUTES ==================

# Creation of a zones dropdown
@router.get("/zones", response_model=List[schemas.ZoneResponse])
def get_zones_dropdown(db: Session = Depends(get_db)):
    """Get all zones for dropdown (ordered by zone_number)."""
    zones = db.query(models.Zone).order_by(models.Zone.zone_number.asc()).all()
    return [schemas.ZoneResponse.model_validate(z).model_dump() for z in zones]

# Creation of varieties with full species names dropdown (consistent with acquisitions)
@router.get("/varieties_with_species")
def get_varieties_with_species_dropdown(
    skip: int = 0, 
    limit: int = 100, 
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get varieties with their full species names for dropdown (A→Z) with pagination and search."""
    query = (
        db.query(models.Variety)
        .join(models.Species)
        .join(models.Genus)
        .order_by(models.Genus.genus.asc(), models.Species.species.asc(), models.Variety.variety.asc())
    )
    
    # Add search functionality if search term is provided
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            models.Genus.genus.ilike(search_term) |
            models.Species.species.ilike(search_term) |
            models.Variety.variety.ilike(search_term)
        )
    
    # Apply pagination
    varieties = query.offset(skip).limit(limit).all()
    
    result = []
    for variety in varieties:
        result.append({
            "variety_id": variety.variety_id,
            "variety": variety.variety,
            "full_species_name": f"{variety.species.genus.genus} {variety.species.species}",
            "species_id": variety.species_id
        })
    
    return result

# Get total count of varieties for pagination
@router.get("/varieties_with_species/count")
def get_varieties_count(search: Optional[str] = None, db: Session = Depends(get_db)):
    """Get total count of varieties for pagination."""
    query = (
        db.query(models.Variety)
        .join(models.Species)
        .join(models.Genus)
    )
    
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            models.Genus.genus.ilike(search_term) |
            models.Species.species.ilike(search_term) |
            models.Variety.variety.ilike(search_term)
        )
    
    return {"total": query.count()}

# Creation of a containers dropdown
@router.get("/containers", response_model=List[schemas.ContainerResponse])
def get_containers_dropdown(db: Session = Depends(get_db)):
    """Get all container types for dropdown (A→Z)."""
    containers = db.query(models.Container).order_by(models.Container.container_type.asc()).all()
    return [schemas.ContainerResponse.model_validate(c).model_dump() for c in containers]

# Creation of a users dropdown
@router.get("/users", response_model=List[schemas.UserResponse])
def get_users_dropdown(db: Session = Depends(get_db)):
    """Get all users for dropdown (ordered by full_name)."""
    users = db.query(models.User).order_by(models.User.full_name.asc()).all()
    return [schemas.UserResponse.model_validate(u).model_dump() for u in users]

# Creation of genetic sources dropdown
@router.get("/genetic_sources", response_model=List[schemas.GeneticSourceResponse])
def get_genetic_sources_dropdown(db: Session = Depends(get_db)):
    """Get all genetic sources for dropdown (ordered by genetic_source_id)."""
    genetic_sources = db.query(models.GeneticSource).order_by(models.GeneticSource.genetic_source_id.asc()).all()
    return [schemas.GeneticSourceResponse.model_validate(gs).model_dump() for gs in genetic_sources]

# Creation of removal causes dropdown
@router.get("/removal_causes", response_model=List[schemas.RemovalCauseResponse])
def get_removal_causes_dropdown(db: Session = Depends(get_db)):
    """Get all removal causes for dropdown (A→Z)."""
    removal_causes = db.query(models.RemovalCause).order_by(models.RemovalCause.cause.asc()).all()
    return [schemas.RemovalCauseResponse.model_validate(rc).model_dump() for rc in removal_causes]

# ================== MAIN ROUTES ==================

# Create new planting record
@router.post("/", response_model=schemas.PlantingResponse)
def create_planting(
    planting_data: schemas.PlantingCreate = Body(...),
    db: Session = Depends(get_db)
):
    """Create a new planting record"""
    
    # Validate required fields
    if not planting_data.zone_id:
        raise HTTPException(status_code=400, detail="zone_id is required")
    if not planting_data.variety_id:
        raise HTTPException(status_code=400, detail="variety_id is required")
    if not planting_data.container_type_id:
        raise HTTPException(status_code=400, detail="container_type_id is required")
    if not planting_data.number_planted or planting_data.number_planted <= 0:
        raise HTTPException(status_code=400, detail="number_planted must be greater than 0")
    if not planting_data.date_planted:
        raise HTTPException(status_code=400, detail="date_planted is required")
    
    # Validate foreign key references
    
    # Check if zone exists
    zone = db.query(models.Zone).filter(models.Zone.zone_id == planting_data.zone_id).first()
    if not zone:
        raise HTTPException(status_code=400, detail=f"Zone with ID {planting_data.zone_id} does not exist")
    
    # Check if variety exists
    variety = db.query(models.Variety).filter(models.Variety.variety_id == planting_data.variety_id).first()
    if not variety:
        raise HTTPException(status_code=400, detail=f"Variety with ID {planting_data.variety_id} does not exist")
    
    # Check if container type exists
    container = db.query(models.Container).filter(models.Container.container_type_id == planting_data.container_type_id).first()
    if not container:
        raise HTTPException(status_code=400, detail=f"Container type with ID {planting_data.container_type_id} does not exist")
    
    # Check if user exists (if provided)
    if planting_data.planted_by:
        user = db.query(models.User).filter(models.User.user_id == planting_data.planted_by).first()
        if not user:
            raise HTTPException(status_code=400, detail=f"User with ID {planting_data.planted_by} does not exist")
    
    # Check if genetic source exists (if provided)
    if planting_data.genetic_source_id:
        genetic_source = db.query(models.GeneticSource).filter(
            models.GeneticSource.genetic_source_id == planting_data.genetic_source_id
        ).first()
        if not genetic_source:
            raise HTTPException(status_code=400, detail=f"Genetic source with ID {planting_data.genetic_source_id} does not exist")
    
    # Check if removal cause exists (if provided)
    if planting_data.removal_cause_id:
        removal_cause = db.query(models.RemovalCause).filter(
            models.RemovalCause.removal_cause_id == planting_data.removal_cause_id
        ).first()
        if not removal_cause:
            raise HTTPException(status_code=400, detail=f"Removal cause with ID {planting_data.removal_cause_id} does not exist")
    
    # Validate removal logic
    if planting_data.removal_date and not planting_data.removal_cause_id:
        raise HTTPException(status_code=400, detail="removal_cause_id is required when removal_date is provided")
    
    if planting_data.number_removed and not planting_data.removal_date:
        raise HTTPException(status_code=400, detail="removal_date is required when number_removed is provided")
    
    if planting_data.number_removed and planting_data.number_removed > planting_data.number_planted:
        raise HTTPException(status_code=400, detail="number_removed cannot be greater than number_planted")
    
    try:
        # Create the planting record
        planting_obj = crud.planting.create(db, obj_in=planting_data)
        return planting_obj
    except IntegrityError as e:
        raise HTTPException(status_code=400, detail=f"Failed to create planting: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")
