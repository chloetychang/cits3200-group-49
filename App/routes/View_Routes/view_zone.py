from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from App.database import get_db
from App import models
from App.schemas import ZoneResponse
from typing import List

router = APIRouter(
    prefix="/zones",
    tags=["zones"]
)

@router.get("/View_zones", response_model=List[dict])
def get_view_zones(db: Session = Depends(get_db)):
    try:
        rows = (
            db.query(
                models.Zone.zone_id,
                models.Zone.zone_number,
                models.Zone.zone_name,
                models.Aspect.aspect,
                models.Zone.exposure_to_wind,
                models.Zone.shade,
            )
            .join(models.Aspect, models.Zone.aspect_id == models.Aspect.aspect_id, isouter=True)
            .all()
        )

        results = []
        for row in rows:
            results.append({
                "zone_id": row.zone_id,
                "zone_number": row.zone_number,
                "zone_name": row.zone_name,
                "aspect": row.aspect,
                "exposure_to_wind": row.exposure_to_wind,
                "shade": row.shade,
            })
        return results
    except Exception as e:
        import traceback
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))
