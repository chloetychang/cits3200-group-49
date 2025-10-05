from fastapi import APIRouter, HTTPException, Depends, Body
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List

from App.database import get_db
from App import models, schemas, crud

# ================== ROUTER ==================

router = APIRouter(
    prefix="/acquisition",
    tags=["acquisitions"]
)

# ================== ROUTES ==================

# Creation of a genus dropdown
@router.get("/genus", response_model=List[schemas.GenusResponse])
def get_genus_dropdown(db: Session = Depends(get_db)):
    """Get all genus names for dropdown (A→Z)."""
    genus_list = db.query(models.Genus).order_by(models.Genus.genus.asc()).all()
    return [schemas.GenusResponse.model_validate(g).model_dump() for g in genus_list]

# Creation of varieties with full species names dropdown (replaces separate genus/species)
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

# Creation of a supplier dropdown
@router.get("/suppliers", response_model=List[schemas.SupplierResponse])
def get_supplier_dropdown(db: Session = Depends(get_db)):
    """Get all supplier names for dropdown (A→Z)."""
    suppliers = db.query(models.Supplier).order_by(models.Supplier.supplier_name.asc()).all()
    return [schemas.SupplierResponse.model_validate(s).model_dump() for s in suppliers]

# Creation of a provenance dropdown
@router.get("/provenance_locations", response_model=List[schemas.ProvenanceResponse])
def get_provenance_location_dropdown(db: Session = Depends(get_db)):
    """Get all provenance locations for dropdown (A→Z)."""
    provenances = db.query(models.Provenance).order_by(models.Provenance.location.asc()).all()
    return [schemas.ProvenanceResponse.model_validate(p).model_dump() for p in provenances]

@router.get("/bioregion_code", response_model=List[schemas.BioregionResponse])
def get_bioregion_dropdown(db: Session = Depends(get_db)):
    """Get all bioregion codes for dropdown (A→Z)."""
    bioregions = db.query(models.Bioregion).order_by(models.Bioregion.bioregion_code.asc()).all()
    return [schemas.BioregionResponse.model_validate(b).model_dump() for b in bioregions]

# TODO: Family name dropdown - Missing due to data model changes [left as placeholder]

@router.get("/generation_numbers", response_model=List[int])
def get_generation_number_dropdown(db: Session = Depends(get_db)):
    """Get generation numbers for dropdown (0-4)."""
    return [0, 1, 2, 3, 4]

# Create new genetic_source record (acquisition)
@router.post("/", response_model=schemas.GeneticSourceResponse)
def create_acquisition(
    genetic_source_data: schemas.GeneticSourceCreate = Body(...),
    db: Session = Depends(get_db)
):
    
    # Validate required fields
    if not genetic_source_data.variety_id:
        raise HTTPException(status_code=400, detail="variety_id is required")
    if not genetic_source_data.supplier_id:
        raise HTTPException(status_code=400, detail="supplier_id is required")
    if not genetic_source_data.supplier_lot_number:
        raise HTTPException(status_code=400, detail="supplier_lot_number is required")
    
    try:
        # Create the genetic source record
        genetic_source_obj = crud.genetic_source.create(db, obj_in=genetic_source_data)
        return genetic_source_obj
    except IntegrityError as e:
        raise HTTPException(status_code=400, detail=f"Failed to create acquisition: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")
