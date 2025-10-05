from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter(prefix="/location_type", tags=["Location Type"])

@router.get("/", response_model=list[schemas.LocationTypeResponse])
def get_location_types(db: Session = Depends(get_db)):
    return db.query(models.LocationType).all()

@router.post("/", response_model=schemas.LocationTypeResponse)
def create_location_type(
    location_type: schemas.LocationTypeCreate, db: Session = Depends(get_db)
):
    existing = db.query(models.LocationType).filter_by(
        location_type=location_type.location_type
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Location type already exists")

    new_type = models.LocationType(**location_type.dict())
    db.add(new_type)
    db.commit()
    db.refresh(new_type)
    return new_type

@router.put("/{location_type_id}", response_model=schemas.LocationTypeResponse)
def update_location_type(
    location_type_id: int,
    location_type: schemas.LocationTypeUpdate,
    db: Session = Depends(get_db),
):
    db_type = db.query(models.LocationType).filter_by(
        location_type_id=location_type_id
    ).first()
    if not db_type:
        raise HTTPException(status_code=404, detail="Location type not found")

    db_type.location_type = location_type.location_type
    db.commit()
    db.refresh(db_type)
    return db_type
