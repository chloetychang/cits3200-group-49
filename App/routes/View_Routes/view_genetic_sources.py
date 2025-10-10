# App/routes/view_genetic_sources.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from App.database import get_db
from App import models, schemas

router = APIRouter(prefix="/genetic_sources", tags=["genetic_sources"])

@router.get("/View_GeneticSources", response_model=List[schemas.GeneticSourceFullResponse])
def get_genetic_sources_full(
    skip: int = 0,
    limit: Optional[int] = 100,
    db: Session = Depends(get_db),
):
    try:
        q = (
    db.query(models.GeneticSource)
    .options(
        # genetic_source -> variety -> species
        joinedload(models.GeneticSource.variety)
            .joinedload(models.Variety.species),
        joinedload(models.GeneticSource.provenance)
            .joinedload(models.Provenance.location_type_rel),

        joinedload(models.GeneticSource.provenance)
            .joinedload(models.Provenance.bioregion),

        joinedload(models.GeneticSource.supplier),
        joinedload(models.GeneticSource.propagation_type_rel),
    )
    .offset(skip)
        )
        if limit is not None:
            q = q.limit(limit)

        rows = q.all()

        results: List[schemas.GeneticSourceFullResponse] = []
        for gs in rows:
            results.append(
                schemas.GeneticSourceFullResponse(
                    genetic_source_id=gs.genetic_source_id,
                    acquisition_date=gs.acquisition_date.date() if gs.acquisition_date else None,
                    viability=gs.viability,
                    female_genetic_source=gs.female_genetic_source,
                    male_genetic_source=gs.male_genetic_source,
                    price=gs.price,
                    gram_weight=gs.gram_weight,
                    landscape_only=gs.landscape_only,
                    research_notes=gs.research_notes,
                    supplier_lot_number=gs.supplier_lot_number,
                    generation_number=gs.generation_number,
                    species=(
                        schemas.SpeciesSimpleResponse.model_validate(gs.variety.species)
                        if gs.variety and gs.variety.species else None
                    ),
                    variety=(
                        schemas.VarietyResponse.model_validate(gs.variety)
                        if gs.variety else None
                    ),
                    provenance=(
                        schemas.ProvenanceOut.model_validate(gs.provenance)
                        if gs.provenance else None
                    ),
                    supplier=(
                        schemas.SupplierResponse.model_validate(gs.supplier)
                        if gs.supplier else None
                    ),
                    propagation_type=(
                        schemas.PropagationTypeResponse.model_validate(gs.propagation_type_rel)
                        if gs.propagation_type_rel else None
                    ),
                )
            )
        return results

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"View_GeneticSources failed: {e}")