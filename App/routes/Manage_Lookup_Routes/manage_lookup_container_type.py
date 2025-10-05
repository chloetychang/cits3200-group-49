from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter(
    prefix="/container_type",
    tags=["Container Type"]
)

@router.get("/", response_model=list[schemas.ContainerResponse])
def get_container_types(db: Session = Depends(get_db)):
    return db.query(models.Container).all()

@router.post("/", response_model=schemas.ContainerResponse)
def create_container_type(container: schemas.ContainerCreate, db: Session = Depends(get_db)):
    db_container = models.Container(**container.dict())
    db.add(db_container)
    db.commit()
    db.refresh(db_container)
    return db_container

@router.put("/{container_type_id}", response_model=schemas.ContainerResponse)
def update_container_type(container_type_id: int, container: schemas.ContainerCreate, db: Session = Depends(get_db)):
    db_container = db.query(models.Container).filter(
        models.Container.container_type_id == container_type_id
    ).first()
    if not db_container:
        raise HTTPException(status_code=404, detail="Container type not found")
    for key, value in container.dict().items():
        setattr(db_container, key, value)
    db.commit()
    db.refresh(db_container)
    return db_container
