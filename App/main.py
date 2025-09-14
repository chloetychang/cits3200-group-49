from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import engine, get_db
from config import settings
import models
import schemas
import uvicorn
from typing import List
import crud

# Create all database tables
models.Base.metadata.create_all(bind=engine)

# Initialize FastAPI app
app = FastAPI(
    title=settings.API_TITLE,
    description=settings.API_DESCRIPTION,
    version=settings.API_VERSION
)

@app.get("/")
async def root():
    return {"message": "Welcome to Yanchep Plant Database API"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/plantings/", response_model=schemas.PlantingResponse)
def create_planting(planting_in: schemas.PlantingCreate, db: Session = Depends(get_db)):
    db_planting = crud.planting.create(db, obj_in=planting_in)
    return db_planting

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
