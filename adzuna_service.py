from typing import Any
import httpx
from app.core.config import settings

BASE_URL = "https://api.adzuna.com/v1/api/jobs"


async def search_jobs_by_role(
    role: str,
    location: str = "Sydney",
    page: int = 1,
    results_per_page: int = 10,
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

    timeout = httpx.Timeout(20.0, connect=10.0)

    try:
        async with httpx.AsyncClient(timeout=timeout) as client:
            response = await client.get(url, params=params)
            response.raise_for_status()
            data = response.json()

    except httpx.TimeoutException:
        raise Exception("Adzuna request timed out.")
    except httpx.HTTPStatusError as e:
        raise Exception(f"Adzuna HTTP error: {e.response.status_code} - {e.response.text}")
    except Exception as e:
        raise Exception(f"Adzuna request failed: {str(e)}")

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