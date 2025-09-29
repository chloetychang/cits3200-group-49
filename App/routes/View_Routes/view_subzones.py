from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, database
from typing import List

router = APIRouter(
    prefix="/subzones",
    tags=["subzones"]
)

@router.get("/View_subzones", response_model=List[dict])
def view_subzones(db: Session = Depends(database.get_db)):
    try:
        rows = (
            db.query(
                models.SubZone.sub_zone_id,
                models.Zone.zone_number,
                models.SubZone.sub_zone_code,
                models.Aspect.aspect,
                models.SubZone.exposure_to_wind,
                models.SubZone.shade
            )
            .join(models.Zone, models.SubZone.zone_id == models.Zone.zone_id, isouter=True)
            .join(models.Aspect, models.SubZone.aspect_id == models.Aspect.aspect_id, isouter=True)
            .all()
        )

        return [
            {
                "sub_zone_id": r.sub_zone_id,
                "zone_number": r.zone_number,
                "sub_zone_code": r.sub_zone_code,
                "aspect": r.aspect,
                "exposure_to_wind": r.exposure_to_wind,
                "shade": r.shade,
            }
            for r in rows
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
