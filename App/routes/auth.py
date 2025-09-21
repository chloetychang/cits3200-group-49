from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta
from jose import JWTError, jwt
from typing import Optional

# ================== Configuration ==================
# Note: SECRET_KEY should be stored in your .env file in production.
# For now, we keep a dummy key here for testing.
SECRET_KEY = "dummysecret"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Initialize router
router = APIRouter()

# OAuth2 requires a token URL; we define it here
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")


# ================== Helper Functions ==================
def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    """
    Create a JWT token with an expiration time.
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


# ================== Routes ==================
@router.post("/token")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Login endpoint.
    For now: does NOT validate username/password.
    It just issues a JWT token using whatever username is passed.
    Later: replace with real DB authentication logic.
    """
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    token = create_access_token(
        data={"sub": form_data.username}, expires_delta=access_token_expires
    )
    return {"access_token": token, "token_type": "bearer"}


@router.get("/me")
async def read_users_me(token: str = Depends(oauth2_scheme)):
    """
    Endpoint to get the current user.
    For now: only decodes the token and returns the username inside.
    Later: can be expanded to fetch user data from the database.
    """
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token",
                headers={"WWW-Authenticate": "Bearer"},
            )
        return {"username": username}
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        )
