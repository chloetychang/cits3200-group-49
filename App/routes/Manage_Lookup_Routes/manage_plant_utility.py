from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter(prefix="/plant_utility", tags=["Plant Utility"])

@router.get("/", response_model=list[schemas.PlantUtilityOut])
def get_plant_utilities(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 50
):
    return db.query(models.PlantUtility).offset(skip).limit(limit).all()

@router.post("/", response_model=schemas.PlantUtilityOut)
def create_plant_utility(plant_util: schemas.PlantUtilityCreate, db: Session = Depends(get_db)):
    existing = db.query(models.PlantUtility).filter_by(utility=plant_util.utility).first()
    if existing:
        raise HTTPException(status_code=400, detail="Plant utility already exists")
    new_util = models.PlantUtility(**plant_util.dict())
    db.add(new_util)
    db.commit()
    db.refresh(new_util)
    return new_util

@router.put("/{plant_utility_id}", response_model=schemas.PlantUtilityOut)
def update_plant_utility(plant_utility_id: int, plant_util: schemas.PlantUtilityUpdate, db: Session = Depends(get_db)):
    db_util = db.query(models.PlantUtility).filter_by(plant_utility_id=plant_utility_id).first()
    if not db_util:
        raise HTTPException(status_code=404, detail="Plant utility not found")
    db_util.utility = plant_util.utility
    db.commit()
    db.refresh(db_util)
    return db_util