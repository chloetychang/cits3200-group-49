from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter(
    prefix="/species_utility",
    tags=["Species Utility"]
)


@router.get("/", response_model=list[schemas.SpeciesUtilityLinkResponse])
def get_species_utilities(
    db: Session = Depends(get_db), 
    skip: int = 0, 
    limit: int = 50
):
    return db.query(models.SpeciesUtilityLink).offset(skip).limit(limit).all()


@router.post("/", response_model=schemas.SpeciesUtilityLinkResponse)
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


@router.put("/{species_id}/{plant_utility_id}", response_model=schemas.SpeciesUtilityLinkResponse)
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


