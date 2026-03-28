import json
import httpx
from app.core.config import settings


async def analyze_resume_with_ollama(resume_text: str, role: str) -> dict:
    prompt = f"""
You are an AI career assistant.

Analyze this resume against the role: {role}

Return ONLY valid JSON in this exact format:
{{
  "coverage_percentage": 65,
  "is_qualified": false,
  "detected_skills": ["skill1", "skill2"],
  "missing_must_have": ["skill1"],
  "missing_nice_to_have": ["skill1"],
  "summary": "short explanation"
}}

Resume:
{resume_text[:1500]}
""".strip()

    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(
            f"{settings.OLLAMA_BASE_URL}/api/chat",
            json={
                "model": settings.OLLAMA_MODEL,
                "messages": [{"role": "user", "content": prompt}],
                "stream": False,
                "options": {"temperature": 0.2},
            },
        )
        response.raise_for_status()
        data = response.json()

    content = data.get("message", {}).get("content", "")

    try:
        start = content.find("{")
        end = content.rfind("}")
        json_text = content[start:end + 1]
        return json.loads(json_text)
    except Exception:
        return {
            "coverage_percentage": 0,
            "is_qualified": False,
            "detected_skills": [],
            "missing_must_have": [],
            "missing_nice_to_have": [],
            "summary": "AI analysis could not be generated properly.",
        }