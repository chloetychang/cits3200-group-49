from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from sqlalchemy.exc import IntegrityError
from typing import List, Optional

from App.database import get_db
from App import models, schemas, crud

router = APIRouter(
    prefix="/provenances",
    tags=["provenances"]
)

# -------------------- Provenance --------------------
@router.get("/provenance/", response_model=List[schemas.ProvenanceResponse])
def get_provenances(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Get all provenance records with pagination"""
    return crud.provenance.get_multi(db=db, skip=skip, limit=limit)

@router.post("/provenance/", response_model=schemas.ProvenanceResponse)
def create_provenance(provenance_in: schemas.ProvenanceCreate, db: Session = Depends(get_db)):
    """Create a new provenance record"""
    try:
        # Validate required fields
        if not provenance_in.location or len(provenance_in.location.strip()) == 0:
            raise HTTPException(status_code=400, detail="Location is required and cannot be empty")
        
        # Check if provenance with same location already exists
        existing_provenance = crud.provenance.get_by_location(db, location=provenance_in.location.strip())
        if existing_provenance:
            raise HTTPException(status_code=400, detail=f"Provenance with location '{provenance_in.location}' already exists")
        
        # Validate bioregion_code if provided
        if provenance_in.bioregion_code:
            bioregion = crud.bioregion.get_by_code(db, code=provenance_in.bioregion_code)
            if not bioregion:
                raise HTTPException(status_code=400, detail=f"Invalid bioregion code: '{provenance_in.bioregion_code}'")
        
        # Validate location_type_id if provided
        if provenance_in.location_type_id:
            location_type = db.query(models.LocationType).filter(
                models.LocationType.location_type_id == provenance_in.location_type_id
            ).first()
            if not location_type:
                raise HTTPException(status_code=400, detail=f"Invalid location type ID: {provenance_in.location_type_id}")
        
        # Create new provenance record
        provenance = crud.provenance.create(db, obj_in=provenance_in)
        return provenance
        
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=400, detail="Database integrity error: Invalid foreign key reference")
    except HTTPException:
        # Re-raise HTTPExceptions as-is
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")


@router.get("/bioregion", response_model=List[schemas.BioregionResponse])
def get_bioregion_dropdown(db: Session = Depends(get_db)):
    """Get all bioregion codes for dropdown (A→Z)."""
    bioregions = db.query(models.Bioregion).order_by(models.Bioregion.bioregion_code.asc()).all()
    return [schemas.BioregionResponse.model_validate(b).model_dump() for b in bioregions]

@router.get("/location_type", response_model=List[schemas.LocationTypeResponse])
def get_location_type_dropdown(db: Session = Depends(get_db)):
    """Get all location types for dropdown (A→Z)."""
    location_types = db.query(models.LocationType).order_by(models.LocationType.location_type.asc()).all()
    return [schemas.LocationTypeResponse.model_validate(lt).model_dump() for lt in location_types]