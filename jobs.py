from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from app.services.adzuna_service import search_jobs_by_role

router = APIRouter(prefix="/jobs", tags=["jobs"])


class JobSearchRequest(BaseModel):
    target_role: str = Field(..., examples=["Data Analyst"])
    location: str = "Sydney"
    page: int = 1
    results_per_page: int = 10


@router.post("/search")
async def search_jobs(request: JobSearchRequest):
    try:
        jobs = await search_jobs_by_role(
            role=request.target_role,
            location=request.location,
            page=request.page,
            results_per_page=request.results_per_page,
        )

        return {
            "target_role": request.target_role,
            "location": request.location,
            "total_returned": len(jobs),
            "jobs": jobs,
        }

    except Exception as e:
        raise HTTPException(status_code=502, detail=f"Adzuna API error: {str(e)}")