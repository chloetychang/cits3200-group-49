from fastapi import APIRouter, HTTPException, Depends, Body
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List

from App.database import get_db
from App import models, schemas, crud

# ================== ROUTER ==================

router = APIRouter(
    prefix="/updateFamily",
    tags=["updateFamily"]
)

# ================== ROUTES ==================

# Genus dropdown (families have genera)
@router.get("/genus", response_model=List[schemas.GenusResponse])
def get_genus_dropdown(db: Session = Depends(get_db)):
    """Get all genus names for dropdown (A→Z)."""
    genus_list = db.query(models.Genus).order_by(models.Genus.genus.asc()).all()
    return [schemas.GenusResponse.model_validate(g).model_dump() for g in genus_list]

# Varieties with full species names dropdown
@router.get("/varieties_with_species")
def get_varieties_with_species_dropdown(db: Session = Depends(get_db)):
    """Get all varieties with their full species names for dropdown (A→Z)."""
    varieties = (
        db.query(models.Variety)
        .join(models.Species)
        .join(models.Genus)
        .order_by(models.Genus.genus.asc(), models.Species.species.asc(), models.Variety.variety.asc())
        .all()
    )
    result = []
    for variety in varieties:
        result.append({
            "variety_id": variety.variety_id,
            "variety": variety.variety,
            "full_species_name": f"{variety.species.genus.genus} {variety.species.species}",
            "species_id": variety.species_id
        })
    return result

# Propagation type dropdown
@router.get("/propagation_types", response_model=List[schemas.PropagationTypeResponse])
def get_propagation_type_dropdown(db: Session = Depends(get_db)):
    """Get all propagation types for dropdown (A→Z)."""
    types = db.query(models.PropagationType).order_by(models.PropagationType.propagation_type.asc()).all()
    return [schemas.PropagationTypeResponse.model_validate(t).model_dump() for t in types]

# Generation number dropdown
@router.get("/generation_numbers", response_model=List[int])
def get_generation_number_dropdown(db: Session = Depends(get_db)):
    """Get generation numbers for dropdown (0-4)."""
    return [0, 1, 2, 3, 4]

# Female parent dropdown (existing genetic sources with full species name and provenance)
@router.get("/female_parents")
def get_female_parent_dropdown(db: Session = Depends(get_db)):
    """Get all genetic sources for female parent dropdown (A→Z by id), with full species name and provenance location."""
    sources = (
        db.query(models.GeneticSource)
        .join(models.Variety, models.GeneticSource.variety_id == models.Variety.variety_id)
        .join(models.Species, models.Variety.species_id == models.Species.species_id)
        .join(models.Genus, models.Species.genus_id == models.Genus.genus_id)
        .outerjoin(models.Provenance, models.GeneticSource.provenance_id == models.Provenance.provenance_id)
        .order_by(models.GeneticSource.genetic_source_id.asc())
        .all()
    )
    result = []
    for s in sources:
        result.append({
            "genetic_source_id": s.genetic_source_id,
            "full_species_name": f"{s.variety.species.genus.genus} {s.variety.species.species}",
            "variety": s.variety.variety if s.variety else None,
            "provenance_location": s.provenance.location if s.provenance else None,
            "supplier_lot_number": s.supplier_lot_number,
            "generation_number": s.generation_number,
        })
    return result

# Male parent dropdown (existing genetic sources with full species name and provenance)
@router.get("/male_parents")
def get_male_parent_dropdown(db: Session = Depends(get_db)):
    """Get all genetic sources for male parent dropdown (A→Z by id), with full species name and provenance location."""
    sources = (
        db.query(models.GeneticSource)
        .join(models.Variety, models.GeneticSource.variety_id == models.Variety.variety_id)
        .join(models.Species, models.Variety.species_id == models.Species.species_id)
        .join(models.Genus, models.Species.genus_id == models.Genus.genus_id)
        .outerjoin(models.Provenance, models.GeneticSource.provenance_id == models.Provenance.provenance_id)
        .order_by(models.GeneticSource.genetic_source_id.asc())
        .all()
    )
    result = []
    for s in sources:
        result.append({
            "genetic_source_id": s.genetic_source_id,
            "full_species_name": f"{s.variety.species.genus.genus} {s.variety.species.species}",
            "variety": s.variety.variety if s.variety else None,
            "provenance_location": s.provenance.location if s.provenance else None,
            "supplier_lot_number": s.supplier_lot_number,
            "generation_number": s.generation_number,
        })
    return result

# Breeding team dropdown (users with breeder role)
@router.get("/breeding_teams", response_model=List[schemas.UserResponse])
def get_breeding_team_dropdown(db: Session = Depends(get_db)):
    """Get all users for breeding team dropdown (A→Z by surname)."""
    users = db.query(models.User).order_by(models.User.surname.asc()).all()
    return [schemas.UserResponse.model_validate(u).model_dump() for u in users]

# Update genetic source record (used for updating a family)
@router.put("/{genetic_source_id}", response_model=schemas.GeneticSourceResponse)
def update_genetic_source(
    genetic_source_id: int,
    genetic_source_data: schemas.NewFamilyUpdate = Body(...),
    db: Session = Depends(get_db)
):
    try:
        updated_obj = crud.genetic_source.update(db, db_obj_id=genetic_source_id, obj_in=genetic_source_data)
        return updated_obj
    except IntegrityError as e:
        raise HTTPException(status_code=400, detail=f"Failed to update family: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")
