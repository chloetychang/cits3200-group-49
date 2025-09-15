# Configuration settings for the FastAPI application

import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Settings:
    DATABASE_HOST: str = os.getenv("DATABASE_HOST") #type: ignore
    DATABASE_PORT: str = os.getenv("DATABASE_PORT") #type: ignore
    DATABASE_NAME: str = os.getenv("DATABASE_NAME") #type: ignore
    DATABASE_USER: str = os.getenv("DATABASE_USER") #type: ignore
    DATABASE_PASSWORD: str = os.getenv("DATABASE_PASSWORD") #type: ignore
    
    # API settings
    API_TITLE: str = "Yanchep Plant Database API"
    API_DESCRIPTION: str = "API for managing plant genetic sources, plantings, and related data"
    API_VERSION: str = "1.0.0"
    
    @property
    def database_url(self) -> str:
        return f"postgresql://{self.DATABASE_USER}:{self.DATABASE_PASSWORD}@{self.DATABASE_HOST}:{self.DATABASE_PORT}/{self.DATABASE_NAME}"

# Create settings instance
settings = Settings()
