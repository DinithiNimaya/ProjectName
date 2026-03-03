from fastapi import FastAPI
from app.core.config import settings
from app.api.routes.health import router as health_router

app = FastAPI(title=settings.APP_NAME)

app.include_router(health_router)

@app.get("/")
def root():
    return {"app": settings.APP_NAME, "env": settings.ENV}