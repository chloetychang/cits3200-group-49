from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter(
    prefix="/zone_aspect",
    tags=["Zone Aspect"]
)

@router.get("/", response_model=list[schemas.AspectResponse])
def get_zone_aspects(db: Session = Depends(get_db)):
    return db.query(models.Aspect).all()


@router.post("/", response_model=schemas.AspectResponse)
def create_zone_aspect(aspect: schemas.AspectCreate, db: Session = Depends(get_db)):
    existing = db.query(models.Aspect).filter_by(aspect=aspect.aspect).first()
    if existing:
        raise HTTPException(status_code=400, detail="Zone Aspect already exists")

    new_aspect = models.Aspect(**aspect.dict())
    db.add(new_aspect)
    db.commit()
    db.refresh(new_aspect)
    return new_aspect


@router.put("/{aspect_id}", response_model=schemas.AspectResponse)
def update_zone_aspect(aspect_id: int, aspect: schemas.AspectUpdate, db: Session = Depends(get_db)):
    db_aspect = db.query(models.Aspect).filter_by(aspect_id=aspect_id).first()
    if not db_aspect:
        raise HTTPException(status_code=404, detail="Zone Aspect not found")

    for key, value in aspect.dict(exclude_unset=True).items():
        setattr(db_aspect, key, value)

    db.commit()
    db.refresh(db_aspect)
    return db_aspect
