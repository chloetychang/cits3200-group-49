from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from App import models, schemas
from App.database import get_db
from typing import List


router = APIRouter(
    prefix="/plantings",
    tags=["plantings"],
)

@router.get("/View_plantings", response_model=List[schemas.ViewPlantingResponse])
def view_plantings(db: Session = Depends(get_db)):
    try:
        rows = (
            db.query(
                models.Planting.date_planted,
                models.User.first_name.label("planted_by"),
                models.Zone.zone_number,
                models.Species.species,
                models.Planting.number_planted,
                models.Container.container_type,
                models.Planting.removal_date,
                models.RemovalCause.cause.label("removal_cause"),
                models.Planting.number_removed,
            )
            .join(models.User, models.User.user_id == models.Planting.planted_by, isouter=True)
            .join(models.Zone, models.Zone.zone_id == models.Planting.zone_id)
            .join(models.Variety, models.Variety.variety_id == models.Planting.variety_id)
            .join(models.Species, models.Species.species_id == models.Variety.species_id)
            .join(models.Container, models.Container.container_type_id == models.Planting.container_type_id)
            .join(models.RemovalCause, models.RemovalCause.removal_cause_id == models.Planting.removal_cause_id, isouter=True)
            .all()
        )

        results = []
        for row in rows:
            number_remaining = (row.number_planted or 0) - (row.number_removed or 0)
            results.append({
                "date_planted": row.date_planted,
                "planted_by": row.planted_by,
                "zone_number": row.zone_number,
                "species": row.species,
                "acquisition_id": None,
                "number_planted": row.number_planted,
                "container_type": row.container_type,
                "removal_date": row.removal_date,
                "removal_cause": row.removal_cause,
                "number_removed": row.number_removed,
                "number_remaining": number_remaining,
            })
        return results

    except Exception as e:
        import traceback
        print(traceback.format_exc())  # 控制台能看到具体报错
        raise HTTPException(status_code=500, detail=str(e))
