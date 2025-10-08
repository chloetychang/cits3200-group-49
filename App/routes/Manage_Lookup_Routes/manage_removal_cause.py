from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter(prefix="/removal_cause", tags=["Removal Cause"])

@router.get("/", response_model=list[schemas.RemovalCauseResponse])
def get_removal_causes(db: Session = Depends(get_db)):
    return db.query(models.RemovalCause).all()

@router.post("/", response_model=schemas.RemovalCauseResponse)
def create_removal_cause(removal_cause: schemas.RemovalCauseCreate, db: Session = Depends(get_db)):
    db_item = db.query(models.RemovalCause).filter(models.RemovalCause.cause == removal_cause.cause).first()
    if db_item:
        raise HTTPException(status_code=400, detail="Removal cause already exists")
    new_item = models.RemovalCause(cause=removal_cause.cause)
    db.add(new_item)
    db.commit()
    db.refresh(new_item)
    return new_item

@router.put("/{removal_cause_id}", response_model=schemas.RemovalCauseResponse)
def update_removal_cause(removal_cause_id: int, removal_cause: schemas.RemovalCauseCreate, db: Session = Depends(get_db)):
    db_item = db.query(models.RemovalCause).filter(models.RemovalCause.removal_cause_id == removal_cause_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Removal cause not found")
    db_item.cause = removal_cause.cause
    db.commit()
    db.refresh(db_item)
    return db_item
