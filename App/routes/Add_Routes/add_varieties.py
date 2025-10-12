from fastapi import APIRouter, HTTPException, Depends, Body
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List

from App.database import get_db
from App import models, schemas, crud

# ================== ROUTER ==================

router = APIRouter(
    prefix="/varieties",
    tags=["varieties"]
)

# ================== ROUTES ==================
# Creation of a genus dropdown
@router.get("/genus", response_model=List[schemas.GenusResponse])
def get_genus_dropdown(db: Session = Depends(get_db)):
    """Get all genus names for dropdown (A→Z)."""
    genus_list = db.query(models.Genus).order_by(models.Genus.genus.asc()).all()
    return [schemas.GenusResponse.model_validate(g).model_dump() for g in genus_list]

# Creation of species dropdown

@router.get("/species", response_model=List[str])
def get_species_dropdown(db: Session = Depends(get_db)):
    """Get all species names with their genus for dropdown (A→Z)."""
    species_list = (
        db.query(models.Genus.genus, models.Species.species)
        .join(models.Genus, models.Species.genus_id == models.Genus.genus_id)
        .order_by(models.Genus.genus.asc(), models.Species.species.asc())
        .all()
    )
    return [f"{genus} {species}" for genus, species in species_list]

@router.get("/species/by_genus/{genus_id}")
def get_species_by_genus(genus_id: int, db: Session = Depends(get_db)):
    """Return species for a given genus id, including species_id and full display name.

    Response shape: [{ 'species_id': int, 'species': str, 'full_species_name': 'Genus species' }]
    """
    # Fetch genus name
    genus_name = (
        db.query(models.Genus.genus)
        .filter(models.Genus.genus_id == genus_id)
        .scalar()
    )
    if not genus_name:
        # Return empty list if genus not found
        return []

    rows = (
        db.query(models.Species)
        .filter(models.Species.genus_id == genus_id)
        .order_by(models.Species.species.asc())
        .all()
    )
    return [
        {
            'species_id': s.species_id,
            'species': s.species,
            'full_species_name': f"{genus_name} {s.species}",
        }
        for s in rows
    ]

@router.post("/", response_model=schemas.VarietyNestedResponse)
def create_variety(variety_in: schemas.VarietyCreate, db: Session = Depends(get_db)):
    """Create a new variety record.

    """
    try:
        # Validate species exists
        if not variety_in.species_id:
            raise HTTPException(status_code=400, detail="species_id is required")

        species = db.query(models.Species).filter(models.Species.species_id == variety_in.species_id).first()
        if not species:
            raise HTTPException(status_code=400, detail="species_id does not reference an existing species")

        # If the client provided a genus_id (UI convenience), ensure it matches the species' genus
        if getattr(variety_in, 'genus_id', None) is not None and variety_in.genus_id != species.genus_id:
            raise HTTPException(status_code=400, detail="Provided genus_id does not match the genus of the provided species_id")

        # Prepare dict for DB insertion — remove client-only fields (genus_id), any PK the client may have sent,
        # and strip genetic_source_id entirely (we're not attaching genetic sources at variety creation)
        obj_data = variety_in.model_dump() if hasattr(variety_in, 'model_dump') else variety_in
        if isinstance(obj_data, dict):
            obj_data.pop('genus_id', None)
            obj_data.pop('variety_id', None)
            obj_data.pop('genetic_source_id', None)

        variety = crud.variety.create(db, obj_in=obj_data)
        return variety

    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Database integrity error: Invalid foreign key reference or constraint violation")
    except HTTPException:
        # Re-raise HTTPExceptions as-is
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")




    