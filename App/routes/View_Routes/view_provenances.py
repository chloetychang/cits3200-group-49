from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List
from App import models, schemas
from App.database import get_db

router = APIRouter(
    prefix="/provenances",        
    tags=["provenances"]
)


@router.get("/View_provenances", response_model=List[schemas.ViewProvenanceResponse])
def get_view_provenances(db: Session = Depends(get_db)):
    try:
        rows = (
            db.query(
                models.Provenance.provenance_id,
                models.Provenance.location,
                models.Provenance.extra_details,
                models.Bioregion.region_name.label("bioregion_name"),
                models.LocationType.location_type.label("location_type"),
            )
            .join(models.Bioregion, models.Provenance.bioregion_code == models.Bioregion.bioregion_code, isouter=True)
            .join(models.LocationType, models.Provenance.location_type_id == models.LocationType.location_type_id, isouter=True)
            .all()
        )

        return [
            {
                "provenance_id": r.provenance_id,
                "bioregion": r.bioregion_name,
                "location": r.location,
                "location_type": r.location_type,
                "extra_details": r.extra_details,
            }
            for r in rows
        ]

    except Exception as e:
        import traceback
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))
