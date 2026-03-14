from typing import Any
import httpx
from app.core.config import settings


BASE_URL = "https://api.adzuna.com/v1/api/jobs"


async def search_jobs_by_role(
    role: str,
    location: str = "Sydney",
    page: int = 1,
    results_per_page: int = 10
) -> list[dict[str, Any]]:
    url = f"{BASE_URL}/{settings.ADZUNA_COUNTRY}/search/{page}"

    params = {
        "app_id": settings.ADZUNA_APP_ID,
        "app_key": settings.ADZUNA_APP_KEY,
        "what": role,
        "where": location,
        "results_per_page": results_per_page,
        "content-type": "application/json",
    }

    async with httpx.AsyncClient(timeout=20) as client:
        response = await client.get(url, params=params)
        response.raise_for_status()
        data = response.json()

    jobs = []
    for item in data.get("results", []):
        jobs.append(
            {
                "title": item.get("title"),
                "company": (item.get("company") or {}).get("display_name"),
                "location": (item.get("location") or {}).get("display_name"),
                "salary_min": item.get("salary_min"),
                "salary_max": item.get("salary_max"),
                "created": item.get("created"),
                "redirect_url": item.get("redirect_url"),
                "description": item.get("description"),
            }
        )

    return jobs