from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session, selectinload
from typing import List, Optional

from App.database import get_db
from App import models, schemas

router = APIRouter(
    prefix="/species",
    tags=["species"]
)

def apply_pagination(query, skip: int = 0, limit: Optional[int] = None):
    if skip:
        query = query.offset(skip)
    if isinstance(limit, int) and limit > 0:
        query = query.limit(limit)
    return query

# -------------------- GET species with varieties --------------------
@router.get("/View_Species", response_model=List[schemas.SpeciesWithVarietyResponse])
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
