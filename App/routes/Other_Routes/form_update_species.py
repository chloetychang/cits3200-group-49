from fastapi import APIRouter, HTTPException, Depends, Body
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from typing import List

from App.database import get_db
from App import models, schemas, crud

# ================== ROUTER ==================

router = APIRouter(
    prefix="/formUpdateSpecies",
    tags=["formUpdateSpecies"]
)

# ================== ROUTES ==================

# Creation of a genus dropdown
@router.get("/genus", response_model=List[schemas.GenusResponse])
def get_genus_dropdown(db: Session = Depends(get_db)):
    """Get all genus names for dropdown (A→Z)."""
    genus_list = db.query(models.Genus).order_by(models.Genus.genus.asc()).all()
    return genus_list