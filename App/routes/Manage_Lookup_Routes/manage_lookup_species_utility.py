from typing import Optional, List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from App import models, schemas
from App.database import get_db

router_su = APIRouter(
    prefix="/species_utility",
    tags=["Species Utility"]
)

router_s = APIRouter(
    prefix="/species",
    tags=["Species"]
)


def apply_pagination(query, skip: int = 0, limit: Optional[int] = None):
    if skip:
        query = query.offset(skip)
    if isinstance(limit, int) and limit > 0:
        query = query.limit(limit)
    return query


@router_s.get("/", response_model=List[schemas.SpeciesResponse])
def get_species(
    db: Session = Depends(get_db),
    skip: int = 0, 
    limit: Optional[int] = 50,
    search: Optional[str] = None
):
    """
    Get a list of species with pagination and search functionality.
    This is intended for management tables.
    """
    q = db.query(models.Species).order_by(models.Species.species.asc())

    if search:
        q = q.filter(models.Species.species.ilike(f"{search}%"))

    q = apply_pagination(q, skip=skip, limit=limit)
    return q.all()



@router_su.get("/", response_model=List[schemas.SpeciesUtilityLinkResponse]) 
def get_species_utilities(
    db: Session = Depends(get_db), 
    skip: int = 0, 
    limit: int = 50
):
    query = db.query(models.SpeciesUtilityLink).options(
        joinedload(models.SpeciesUtilityLink.species),
        joinedload(models.SpeciesUtilityLink.plant_utility)
    ).offset(skip).limit(limit)
    
    results = query.all()
    
    return results

@router_su.post("/", response_model=schemas.SpeciesUtilityLinkResponse)
def create_species_utility(
    link: schemas.SpeciesUtilityLinkCreate,
    db: Session = Depends(get_db),
):
    existing = db.query(models.SpeciesUtilityLink).filter_by(
        species_id=link.species_id,
        plant_utility_id=link.plant_utility_id,
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Species-Utility link already exists")

    new_link = models.SpeciesUtilityLink(**link.dict())
    db.add(new_link)
    db.commit()
    db.refresh(new_link)
    return new_link


@router_su.put("/{species_id}/{plant_utility_id}", response_model=schemas.SpeciesUtilityLinkResponse)
def update_species_utility(
    species_id: int,
    plant_utility_id: int,
    link: schemas.SpeciesUtilityLinkUpdate,
    db: Session = Depends(get_db),
):
    db_link = db.query(models.SpeciesUtilityLink).filter_by(
        species_id=species_id,
        plant_utility_id=plant_utility_id,
    ).first()
    if not db_link:
        raise HTTPException(status_code=404, detail="Species-Utility link not found")

    if link.species_id:
        db_link.species_id = link.species_id
    if link.plant_utility_id:
        db_link.plant_utility_id = link.plant_utility_id

    db.commit()
    db.refresh(db_link)
    return db_link
