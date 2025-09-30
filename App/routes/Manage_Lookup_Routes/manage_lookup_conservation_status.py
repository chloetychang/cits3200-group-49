from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from App import models, schemas
from App.database import get_db

router = APIRouter(
    prefix="/conservation_status",
    tags=["Conservation Status"]
)

@router.get("/", response_model=list[schemas.ConservationStatusOut])
def get_conservation_status(db: Session = Depends(get_db)):
    return db.query(models.ConservationStatus).all()

@router.post("/", response_model=schemas.ConservationStatusOut)
def create_conservation_status(status: schemas.ConservationStatusCreate, db: Session = Depends(get_db)):
    db_status = models.ConservationStatus(**status.dict())
    db.add(db_status)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Conservation status already exists")
    db.refresh(db_status)
    return db_status

@router.put("/{status_id}", response_model=schemas.ConservationStatusOut)
def update_conservation_status(status_id: int, status: schemas.ConservationStatusUpdate, db: Session = Depends(get_db)):
    db_status = db.query(models.ConservationStatus).filter(
        models.ConservationStatus.conservation_status_id == status_id
    ).first()
    if not db_status:
        raise HTTPException(status_code=404, detail="Status not found")
    for key, value in status.dict().items():
        setattr(db_status, key, value)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Conservation status with same name already exists")
    db.refresh(db_status)
    return db_status
