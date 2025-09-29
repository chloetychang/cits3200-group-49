from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional

from App.database import get_db
from App import models, schemas

router = APIRouter(
    prefix="/genetic_sources",
    tags=["genetic_sources"]
)

@router.get("/View_GeneticSources", response_model=List[schemas.GeneticSourceFullResponse])
def get_genetic_sources_full(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    """
    Get genetic sources with joined data from species, provenance, supplier, and propagation type
    """
    q = (
        db.query(models.GeneticSource)
        .options(
            joinedload(models.GeneticSource.variety).joinedload(models.Variety.species),
            joinedload(models.GeneticSource.provenance).joinedload(models.Provenance.location_type_rel),
            joinedload(models.GeneticSource.supplier),
            joinedload(models.GeneticSource.propagation_type_rel),
        )
        .order_by(models.GeneticSource.genetic_source_id.asc())
    )

    q = q.offset(skip)
    if limit:
        q = q.limit(limit)

    results = []
    for gs in q.all():
        results.append(
            schemas.GeneticSourceFullResponse(
                genetic_source_id=gs.genetic_source_id,
                acquisition_date=gs.acquisition_date,
                viability=gs.viability,
                female_genetic_source=gs.female_genetic_source,
                male_genetic_source=gs.male_genetic_source,
                price=gs.price,
                gram_weight=gs.gram_weight,
                landscape_only=gs.landscape_only,
                research_notes=gs.research_notes,
                supplier_lot_number=gs.supplier_lot_number,
                generation_number=gs.generation_number,
                species=schemas.SpeciesSimpleResponse.model_validate(gs.variety.species)
                    if gs.variety and gs.variety.species else None,
                provenance=schemas.ProvenanceResponse.model_validate(gs.provenance)
                    if gs.provenance else None,
                supplier=schemas.SupplierResponse.model_validate(gs.supplier)
                    if gs.supplier else None,
                propagation_type=schemas.PropagationTypeResponse.model_validate(gs.propagation_type_rel)
                    if gs.propagation_type_rel else None,
            )
        )

    return results
