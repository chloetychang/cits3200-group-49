# App/routes/View_Routes/view_progeny.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session, joinedload
from typing import List

from App.database import get_db
from App import models, schemas

router = APIRouter(
    prefix="/progeny",
    tags=["progeny"]
)

@router.get("/View_Progeny", response_model=List[schemas.ProgenyWithFamilyResponse])
def get_progeny_with_family(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    q = (
        db.query(models.Progeny)
        .options(
            joinedload(models.Progeny.genetic_source)
            .joinedload(models.GeneticSource.variety)
            .joinedload(models.Variety.species)
            .joinedload(models.Species.genus)
            .joinedload(models.Genus.family)
        )
        .order_by(models.Progeny.child_name.asc())
    )

    if skip:
        q = q.offset(skip)
    if limit:
        q = q.limit(limit)

    progeny_list = q.all()

    result = []
    for p in progeny_list:
        family_name = (
            p.genetic_source.variety.species.genus.family.family_name
            if p.genetic_source and p.genetic_source.variety and
               p.genetic_source.variety.species and p.genetic_source.variety.species.genus
            else None
        )
        result.append({
            "progeny_id": p.progeny_id,
            "child_name": p.child_name,
            "comments": p.comments,
            "family_name": family_name,
        })

    return result
