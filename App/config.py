# Configuration settings for the FastAPI application

import os

class Settings:
    # Database settings - TODO: Replace with actual values
    DATABASE_HOST: str = os.getenv("DATABASE_HOST", "localhost")  # Placeholder
    DATABASE_PORT: str = os.getenv("DATABASE_PORT", "5434")      # Placeholder
    DATABASE_NAME: str = os.getenv("DATABASE_NAME", "mydb") # Placeholder
    DATABASE_USER: str = os.getenv("DATABASE_USER", "postgres")   # Placeholder
    DATABASE_PASSWORD: str = os.getenv("DATABASE_PASSWORD", "postgres")  # Placeholder
    
    # API settings
    API_TITLE: str = "Yanchep Plant Database API"
    API_DESCRIPTION: str = "API for managing plant genetic sources, plantings, and related data"
    API_VERSION: str = "1.0.0"
    
    @property
    def database_url(self) -> str:
        return f"postgresql://{self.DATABASE_USER}:{self.DATABASE_PASSWORD}@{self.DATABASE_HOST}:{self.DATABASE_PORT}/{self.DATABASE_NAME}"

# Create settings instance
settings = Settings()
