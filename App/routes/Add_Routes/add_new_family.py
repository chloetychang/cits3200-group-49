from fastapi import APIRouter, HTTPException, Depends, Body
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List

from App.database import get_db
from App import models, schemas, crud

# ================== ROUTER ==================

router = APIRouter(
	prefix="/newFamily",
	tags=["newFamily"]
)

# ================== ROUTES ==================

# Family name dropdown
@router.get("/family_names", response_model=List[schemas.FamilyResponse])
def get_family_name_dropdown(db: Session = Depends(get_db)):
	"""Get all family names for dropdown (A→Z)."""
	families = db.query(models.Family).order_by(models.Family.famiy_name.asc()).all()
	return [schemas.FamilyResponse.model_validate(f).model_dump() for f in families]

# Genus dropdown (families have genera)
@router.get("/genus", response_model=List[schemas.GenusResponse])
def get_genus_dropdown(db: Session = Depends(get_db)):
	"""Get all genus names for dropdown (A→Z)."""
	genus_list = db.query(models.Genus).order_by(models.Genus.genus.asc()).all()
	return [schemas.GenusResponse.model_validate(g).model_dump() for g in genus_list]

# Varieties with full species names dropdown
@router.get("/varieties_with_species")
def get_varieties_with_species_dropdown(db: Session = Depends(get_db)):
	"""Get all varieties with their full species names for dropdown (A→Z)."""
	varieties = (
		db.query(models.Variety)
		.join(models.Species)
		.join(models.Genus)
		.order_by(models.Genus.genus.asc(), models.Species.species.asc(), models.Variety.variety.asc())
		.all()
	)
	result = []
	for variety in varieties:
		result.append({
			"variety_id": variety.variety_id,
			"variety": variety.variety,
			"full_species_name": f"{variety.species.genus.genus} {variety.species.species}",
			"species_id": variety.species_id
		})
	return result

# Propagation type dropdown
@router.get("/propagation_types", response_model=List[schemas.PropagationTypeResponse])
def get_propagation_type_dropdown(db: Session = Depends(get_db)):
	"""Get all propagation types for dropdown (A→Z)."""
	types = db.query(models.PropagationType).order_by(models.PropagationType.propagation_type.asc()).all()
	return [schemas.PropagationTypeResponse.model_validate(t).model_dump() for t in types]

# Generation number dropdown
@router.get("/generation_numbers", response_model=List[int])
def get_generation_number_dropdown(db: Session = Depends(get_db)):
	"""Get generation numbers for dropdown (0-4)."""
	return [0, 1, 2, 3, 4]

# Female parent dropdown (existing genetic sources)
@router.get("/female_parents", response_model=List[schemas.GeneticSourceResponse])
def get_female_parent_dropdown(db: Session = Depends(get_db)):
	"""Get all genetic sources for female parent dropdown (A→Z by id)."""
	sources = db.query(models.GeneticSource).order_by(models.GeneticSource.genetic_source_id.asc()).all()
	return [schemas.GeneticSourceResponse.model_validate(s).model_dump() for s in sources]

# Male parent dropdown (existing genetic sources)
@router.get("/male_parents", response_model=List[schemas.GeneticSourceResponse])
def get_male_parent_dropdown(db: Session = Depends(get_db)):
	"""Get all genetic sources for male parent dropdown (A→Z by id)."""
	sources = db.query(models.GeneticSource).order_by(models.GeneticSource.genetic_source_id.asc()).all()
	return [schemas.GeneticSourceResponse.model_validate(s).model_dump() for s in sources]

# Breeding team dropdown (users with breeder role)
@router.get("/breeding_teams", response_model=List[schemas.UserResponse])
def get_breeding_team_dropdown(db: Session = Depends(get_db)):
	"""Get all users for breeding team dropdown (A→Z by surname)."""
	users = db.query(models.User).order_by(models.User.surname.asc()).all()
	return [schemas.UserResponse.model_validate(u).model_dump() for u in users]

# Create new family record
@router.post("/", response_model=schemas.FamilyResponse)
def create_family(
	family_data: schemas.FamilyCreate = Body(...),
	db: Session = Depends(get_db)
):
	# Validate required fields
	if not family_data.famiy_name:
		raise HTTPException(status_code=400, detail="famiy_name is required")
	try:
		family_obj = crud.family.create(db, obj_in=family_data)
		return family_obj
	except IntegrityError as e:
		raise HTTPException(status_code=400, detail=f"Failed to create family: {str(e)}")
	except Exception as e:
		raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")
