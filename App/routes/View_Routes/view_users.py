from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from App.database import get_db
from App import crud, schemas

router = APIRouter(
    prefix="/users",
    tags=["users"]
)

@router.get("/View_users", response_model=List[schemas.UserResponse])
def get_users(skip: int = 0, limit: int = None, db: Session = Depends(get_db)):
    return crud.user.get_multi(db=db, skip=skip, limit=limit)
