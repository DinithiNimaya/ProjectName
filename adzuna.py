import os
import requests
from typing import List, Dict, Any

BASE_URL = "https://api.adzuna.com/v1/api/jobs"


def get_job_descriptions(
    role: str,
    country: str = "au",
    page: int = 1,
    results_per_page: int = 10,
) -> List[Dict[str, Any]]:
    app_id = os.getenv("ADZUNA_APP_ID")
    app_key = os.getenv("ADZUNA_APP_KEY")

    if not app_id or not app_key:
        raise ValueError(
            "Missing Adzuna credentials. Please set ADZUNA_APP_ID and ADZUNA_APP_KEY in your environment."
        )

    url = f"{BASE_URL}/{country}/search/{page}"
    params = {
        "app_id": app_id,
        "app_key": app_key,
        "what": role,
        "results_per_page": results_per_page,
        "content-type": "application/json",
    }

    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()
    data = response.json()

    jobs = data.get("results", [])

    results = []
    for job in jobs:
        results.append(
            {
                "title": job.get("title"),
                "company": (job.get("company") or {}).get("display_name"),
                "location": (job.get("location") or {}).get("display_name"),
                "description": job.get("description"),
                "redirect_url": job.get("redirect_url"),
                "salary_min": job.get("salary_min"),
                "salary_max": job.get("salary_max"),
                "created": job.get("created"),
            }
        )

    return results


if __name__ == "__main__":
    target_role = "Data Analyst"

    try:
        jobs = get_job_descriptions(role=target_role)

        print(f"\nFound {len(jobs)} jobs for role: {target_role}\n")

        for index, job in enumerate(jobs, start=1):
            print("=" * 80)
            print(f"Job {index}")
            print(f"Title       : {job['title']}")
            print(f"Company     : {job['company']}")
            print(f"Location    : {job['location']}")
            print(f"Salary Min  : {job['salary_min']}")
            print(f"Salary Max  : {job['salary_max']}")
            print(f"Created     : {job['created']}")
            print(f"URL         : {job['redirect_url']}")
            print("Description :")
            print(job["description"] or "No description available.")
            print()

    except Exception as e:
        print(f"Error: {e}")