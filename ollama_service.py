import json
import asyncio
import httpx
from app.core.config import settings


def extract_json_from_text(text: str) -> dict:
    text = text.strip()

    try:
        if text.startswith("{") and text.endswith("}"):
            return json.loads(text)
    except Exception:
        pass

    start = text.find("{")
    end = text.rfind("}")

    if start != -1 and end != -1 and end > start:
        possible_json = text[start:end + 1]
        return json.loads(possible_json)

    raise ValueError("Model did not return valid JSON.")


def normalize_study_plan(result: dict, role: str, weeks: int) -> dict:
    result.setdefault("target_role", role)
    result.setdefault("weeks", weeks)
    result.setdefault("summary", "")
    result.setdefault("strengths", [])
    result.setdefault("missing_skills", [])
    result.setdefault("weekly_plan", [])

    if not isinstance(result["strengths"], list):
        result["strengths"] = []

    if not isinstance(result["missing_skills"], list):
        result["missing_skills"] = []

    if not isinstance(result["weekly_plan"], list):
        result["weekly_plan"] = []

    cleaned_weeks = []
    for index, item in enumerate(result["weekly_plan"], start=1):
        if not isinstance(item, dict):
            continue

        goals = item.get("goals", [])
        tasks = item.get("tasks", [])

        cleaned_weeks.append({
            "week": item.get("week", index),
            "focus": item.get("focus", f"Week {index} Focus"),
            "goals": goals if isinstance(goals, list) else [],
            "tasks": tasks if isinstance(tasks, list) else [],
        })

    if len(cleaned_weeks) == 0:
        cleaned_weeks = [
            {
                "week": i,
                "focus": f"Week {i} Focus",
                "goals": [f"Build knowledge for week {i}"],
                "tasks": [f"Complete learning activities for week {i}"],
            }
            for i in range(1, weeks + 1)
        ]

    result["weekly_plan"] = cleaned_weeks[:weeks]
    return result


def build_fallback_study_plan(role: str, weeks: int, resume_text: str) -> dict:
    text = resume_text.lower()

    strengths = []
    missing_skills = []

    if "communication" in text:
        strengths.append("Communication")
    if "customer service" in text:
        strengths.append("Customer service")
    if "data entry" in text:
        strengths.append("Data entry")
    if "excel" in text:
        strengths.append("Excel")
    if "office" in text or "office suite" in text:
        strengths.append("Office tools")

    if role.lower() == "data analyst":
        if "sql" not in text:
            missing_skills.append("SQL")
        if "python" not in text:
            missing_skills.append("Python")
        if "power bi" not in text:
            missing_skills.append("Power BI")
        if "statistics" not in text:
            missing_skills.append("Statistics")
        if "tableau" not in text:
            missing_skills.append("Tableau")

    elif role.lower() == "bi analyst":
        if "sql" not in text:
            missing_skills.append("SQL")
        if "power bi" not in text:
            missing_skills.append("Power BI")
        if "tableau" not in text:
            missing_skills.append("Tableau")
        if "data modelling" not in text:
            missing_skills.append("Data Modelling")

    elif role.lower() == "data scientist":
        if "python" not in text:
            missing_skills.append("Python")
        if "machine learning" not in text:
            missing_skills.append("Machine Learning")
        if "statistics" not in text:
            missing_skills.append("Statistics")
        if "sql" not in text:
            missing_skills.append("SQL")

    elif role.lower() == "business analyst":
        if "requirements gathering" not in text:
            missing_skills.append("Requirements Gathering")
        if "stakeholder management" not in text:
            missing_skills.append("Stakeholder Management")
        if "process mapping" not in text:
            missing_skills.append("Process Mapping")
        if "sql" not in text:
            missing_skills.append("SQL")

    elif role.lower() == "software engineer":
        if "python" not in text and "java" not in text and "javascript" not in text:
            missing_skills.append("Programming Fundamentals")
        if "git" not in text:
            missing_skills.append("Git")
        if "api" not in text:
            missing_skills.append("API Development")
        if "testing" not in text:
            missing_skills.append("Testing")

    else:
        if "sql" not in text:
            missing_skills.append("SQL")
        if "python" not in text:
            missing_skills.append("Python")

    if not strengths:
        strengths = ["Communication", "Organisation", "General computer literacy"]

    if not missing_skills:
        missing_skills = ["Advanced technical depth", "Portfolio projects", "Role-specific tooling"]

    focus_cycle = missing_skills[:]
    if not focus_cycle:
        focus_cycle = ["Core Skills", "Practice Projects", "Portfolio Building"]

    weekly_plan = []
    for week in range(1, weeks + 1):
        focus = focus_cycle[(week - 1) % len(focus_cycle)]

        weekly_plan.append({
            "week": week,
            "focus": focus,
            "goals": [
                f"Build understanding of {focus}",
                f"Improve confidence in {focus} for the {role} role"
            ],
            "tasks": [
                f"Spend 3 to 5 hours learning {focus}",
                f"Complete one practical exercise related to {focus}",
                f"Write short notes on what was learned in week {week}"
            ]
        })

    return {
        "target_role": role,
        "weeks": weeks,
        "summary": f"This fallback study plan was generated for the role {role} based on the uploaded resume.",
        "strengths": strengths,
        "missing_skills": missing_skills,
        "weekly_plan": weekly_plan,
        "generation_mode": "fallback"
    }


async def call_ollama(prompt: str) -> dict:
    url = f"{settings.OLLAMA_BASE_URL}/api/chat"

    payload = {
        "model": settings.OLLAMA_MODEL,
        "messages": [
            {
                "role": "user",
                "content": prompt
            }
        ],
        "stream": False,
        "options": {
            "temperature": 0.2
        }
    }

    timeout = httpx.Timeout(60.0, connect=15.0)

    async with httpx.AsyncClient(timeout=timeout) as client:
        response = await client.post(url, json=payload)
        response.raise_for_status()
        return response.json()


async def generate_study_plan(role: str, weeks: int, resume_text: str) -> dict:
    short_resume = resume_text[:2500]

    prompt = f"""
You are a study plan generator.

Analyze the uploaded resume against the target role: {role}.

Generate a study plan for exactly {weeks} weeks.

Return ONLY valid JSON.
Do not use markdown.
Do not add explanation outside JSON.

Use exactly this structure:
{{
  "target_role": "{role}",
  "weeks": {weeks},
  "summary": "short summary",
  "strengths": ["item1", "item2"],
  "missing_skills": ["item1", "item2"],
  "weekly_plan": [
    {{
      "week": 1,
      "focus": "topic",
      "goals": ["goal1", "goal2"],
      "tasks": ["task1", "task2"]
    }}
  ]
}}

Resume:
{short_resume}
""".strip()

    last_error = None

    for _ in range(2):
        try:
            raw_response = await asyncio.wait_for(call_ollama(prompt), timeout=60.0)

            content = raw_response.get("message", {}).get("content", "")
            if not content:
                raise ValueError("Empty response received from Ollama.")

            parsed = extract_json_from_text(content)
            normalized = normalize_study_plan(parsed, role, weeks)

            if len(normalized["weekly_plan"]) == 0:
                raise ValueError("Model returned empty weekly plan.")

            normalized["generation_mode"] = "ollama"
            return normalized

        except Exception as e:
            last_error = e

    fallback = build_fallback_study_plan(role, weeks, resume_text)
    fallback["fallback_reason"] = str(last_error) if last_error else "Unknown error"
    return fallback