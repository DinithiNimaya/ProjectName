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
        raise ValueError("Invalid study plan: strengths must be a list.")

    if not isinstance(result["missing_skills"], list):
        raise ValueError("Invalid study plan: missing_skills must be a list.")

    if not isinstance(result["weekly_plan"], list):
        raise ValueError("Invalid study plan: weekly_plan must be a list.")

    cleaned_weeks = []
    for index, item in enumerate(result["weekly_plan"], start=1):
        if not isinstance(item, dict):
            raise ValueError("Invalid study plan: each weekly_plan item must be an object.")

        goals = item.get("goals", [])
        tasks = item.get("tasks", [])
        resources = item.get("resources", [])

        if not isinstance(goals, list):
            raise ValueError("Invalid study plan: goals must be a list.")

        if not isinstance(tasks, list):
            raise ValueError("Invalid study plan: tasks must be a list.")

        if not isinstance(resources, list):
            resources = []

        cleaned_weeks.append({
            "week": item.get("week", index),
            "focus": item.get("focus", f"Week {index} Focus"),
            "goals": goals,
            "tasks": tasks,
            "resources": resources,
        })

    if len(cleaned_weeks) == 0:
        raise ValueError("Model returned empty weekly plan.")

    result["weekly_plan"] = cleaned_weeks[:weeks]

    if len(result["weekly_plan"]) < weeks:
        raise ValueError(f"Model returned only {len(result['weekly_plan'])} weeks, expected {weeks}.")

    result["generation_mode"] = "ollama"
    return result


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
    short_resume = resume_text[:1800]

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
      "tasks": ["task1", "task2"],
      "resources": [
        {{
          "title": "resource title",
          "url": "https://example.com",
          "format": "Course"
        }}
      ]
    }}
  ]
}}

Resume:
{short_resume}
""".strip()

    try:
        raw_response = await asyncio.wait_for(call_ollama(prompt), timeout=60.0)

        content = raw_response.get("message", {}).get("content", "")
        if not content:
            raise ValueError("Empty response received from Ollama.")

        parsed = extract_json_from_text(content)
        normalized = normalize_study_plan(parsed, role, weeks)
        return normalized

    except asyncio.TimeoutError:
        raise RuntimeError("Study plan generation timed out while waiting for Ollama.")

    except httpx.HTTPError as e:
        raise RuntimeError(f"Ollama request failed: {str(e)}")

    except Exception as e:
        raise RuntimeError(f"Study plan generation failed: {str(e)}")