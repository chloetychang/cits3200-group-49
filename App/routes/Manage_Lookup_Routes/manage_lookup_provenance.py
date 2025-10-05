from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db

router = APIRouter()

# ==============================================================
# Provenance Routes
# ==============================================================
provenance_router = APIRouter(
    prefix="/provenance",
    tags=["Provenance"]
)
@router.get("/provenance", response_model=list[schemas.ProvenanceOut])
def get_provenances(db: Session = Depends(get_db)):
    records = (
        db.query(
            models.Provenance.provenance_id,
            models.Provenance.bioregion_code,
            models.Provenance.location,
            models.Provenance.location_type_id,
            models.LocationType.location_type,
            models.Provenance.extra_details,
        )
        .join(
            models.LocationType,
            models.Provenance.location_type_id == models.LocationType.location_type_id,
        )
        .all()
    )

    return [
        schemas.ProvenanceOut(
            provenance_id=r.provenance_id,
            bioregion_code=r.bioregion_code,
            location=r.location,
            location_type_id=r.location_type_id,
            location_type=r.location_type,
            extra_details=r.extra_details,
        )
        for r in records
    ]


@router.post("/provenance", response_model=schemas.ProvenanceOut)
def create_provenance(prov: schemas.ProvenanceCreate, db: Session = Depends(get_db)):
    new_prov = models.Provenance(**prov.dict())
    db.add(new_prov)
    db.commit()
    db.refresh(new_prov)

    location_type = (
        db.query(models.LocationType.location_type)
        .filter(models.LocationType.location_type_id == new_prov.location_type_id)
        .scalar()
    )

    return schemas.ProvenanceOut(
        provenance_id=new_prov.provenance_id,
        bioregion_code=new_prov.bioregion_code,
        location=new_prov.location,
        location_type_id=new_prov.location_type_id,
        location_type=location_type,
        extra_details=new_prov.extra_details,
    )


@router.put("/provenance/{provenance_id}", response_model=schemas.ProvenanceOut)
def update_provenance(provenance_id: int, prov: schemas.ProvenanceUpdate, db: Session = Depends(get_db)):
    db_prov = db.query(models.Provenance).filter_by(provenance_id=provenance_id).first()
    if not db_prov:
        raise HTTPException(status_code=404, detail="Provenance not found")

    db_prov.bioregion_code = prov.bioregion_code
    db_prov.location = prov.location
    db_prov.location_type_id = prov.location_type_id
    db_prov.extra_details = prov.extra_details
    db.commit()
    db.refresh(db_prov)

    location_type = (
        db.query(models.LocationType.location_type)
        .filter(models.LocationType.location_type_id == db_prov.location_type_id)
        .scalar()
    )

    return schemas.ProvenanceOut(
        provenance_id=db_prov.provenance_id,
        bioregion_code=db_prov.bioregion_code,
        location=db_prov.location,
        location_type_id=db_prov.location_type_id,
        location_type=location_type,
        extra_details=db_prov.extra_details,
    )

# ==============================================================
# Location Type Routes
# ==============================================================
location_type_router = APIRouter(
    prefix="/location_type",
    tags=["Location Type"]
)
@router.get("/location_type", response_model=list[schemas.LocationTypeResponse])
def get_location_types(db: Session = Depends(get_db)):
    return db.query(models.LocationType).all()


@router.post("/location_type", response_model=schemas.LocationTypeResponse)
def create_location_type(location_type: schemas.LocationTypeCreate, db: Session = Depends(get_db)):
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


@router.put("/location_type/{location_type_id}", response_model=schemas.LocationTypeResponse)
def update_location_type(location_type_id: int, location_type: schemas.LocationTypeUpdate, db: Session = Depends(get_db)):
    db_type = db.query(models.LocationType).filter_by(location_type_id=location_type_id).first()
    if not db_type:
        raise HTTPException(status_code=404, detail="Location type not found")

    db_type.location_type = location_type.location_type
    db.commit()
    db.refresh(db_type)
    return db_type
