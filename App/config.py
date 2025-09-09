# Configuration settings for the FastAPI application

import os
from typing import Optional
from pathlib import Path

# Load .env file if it exists
env_file = Path(__file__).parent / ".env"
if env_file.exists():
    from dotenv import load_dotenv
    load_dotenv(env_file)

class Settings:
    # Database settings - TODO: Replace with actual values
    DATABASE_HOST: str = os.getenv("DATABASE_HOST", "localhost")  # Placeholder
    DATABASE_PORT: str = os.getenv("DATABASE_PORT", "5432")      # Placeholder
    DATABASE_NAME: str = os.getenv("DATABASE_NAME", "yanchep_db") # Placeholder
    DATABASE_USER: str = os.getenv("DATABASE_USER", "username")   # Placeholder
    DATABASE_PASSWORD: str = os.getenv("DATABASE_PASSWORD", "password")  # Placeholder
    
    # API settings
    API_TITLE: str = "Yanchep Plant Database API"
    API_DESCRIPTION: str = "API for managing plant genetic sources, plantings, and related data"
    API_VERSION: str = "1.0.0"
    
    # Security settings (for future use)
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-secret-key-here")  # Placeholder
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    @property
    def database_url(self) -> str:
        return f"postgresql://{self.DATABASE_USER}:{self.DATABASE_PASSWORD}@{self.DATABASE_HOST}:{self.DATABASE_PORT}/{self.DATABASE_NAME}"

# Create settings instance
settings = Settings()
