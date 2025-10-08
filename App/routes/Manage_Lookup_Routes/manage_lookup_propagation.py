from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter(
    prefix="/propagation_type",
    tags=["Propagation Type"]
)


@router.get("/", response_model=list[schemas.PropagationTypeResponse])
def get_propagation_types(db: Session = Depends(get_db)):
    return db.query(models.PropagationType).all()


@router.post("/", response_model=schemas.PropagationTypeResponse)
def create_propagation_type(
    propagation_type: schemas.PropagationTypeCreate,
    db: Session = Depends(get_db),
):
    existing = db.query(models.PropagationType).filter_by(
        propagation_type=propagation_type.propagation_type
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Propagation type already exists")

    new_type = models.PropagationType(**propagation_type.dict())
    db.add(new_type)
    db.commit()
    db.refresh(new_type)
    return new_type


@router.put("/{propagation_type_id}", response_model=schemas.PropagationTypeResponse)
def update_propagation_type(
    propagation_type_id: int,
    propagation_type: schemas.PropagationTypeUpdate,
    db: Session = Depends(get_db),
):
    db_type = db.query(models.PropagationType).filter_by(
        propagation_type_id=propagation_type_id
    ).first()
    if not db_type:
        raise HTTPException(status_code=404, detail="Propagation type not found")

    db_type.propagation_type = propagation_type.propagation_type
    db_type.needs_two_parents = propagation_type.needs_two_parents
    db_type.can_cross_genera = propagation_type.can_cross_genera

    db.commit()
    db.refresh(db_type)
    return db_type
