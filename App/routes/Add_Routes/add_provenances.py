from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional

from App.database import get_db
from App import models, schemas

router = APIRouter(
    prefix="/provenances",
    tags=["provenances"]
)

@router.get("/bioregion", response_model=List[schemas.BioregionResponse])
def get_bioregion_dropdown(db: Session = Depends(get_db)):
    """Get all bioregion codes for dropdown (A→Z)."""
    bioregions = db.query(models.Bioregion).order_by(models.Bioregion.bioregion_code.asc()).all()
    return [schemas.BioregionResponse.model_validate(b).model_dump() for b in bioregions]