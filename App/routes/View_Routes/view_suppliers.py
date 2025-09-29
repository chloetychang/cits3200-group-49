# App/routes/View_Routes/view_suppliers.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from App.database import get_db
from App import models, schemas

router = APIRouter(
    prefix="/suppliers",
    tags=["suppliers"]
)

@router.get("/View_Suppliers", response_model=List[schemas.SupplierResponse])
def get_suppliers(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    q = db.query(models.Supplier).order_by(models.Supplier.supplier_name.asc())
    if skip:
        q = q.offset(skip)
    if limit:
        q = q.limit(limit)
    return q.all()
