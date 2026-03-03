import json
from typing import Any, Dict
from tenacity import retry, stop_after_attempt, wait_exponential
from openai import OpenAI
from app.core.config import settings

client = OpenAI(api_key=settings.OPENAI_API_KEY)

def _skill_gap_json_schema() -> Dict[str, Any]:
    return {
        "type": "object",
        "additionalProperties": False,
        "properties": {
            "role": {"type": "string"},
            "coverage_percentage": {"type": "integer", "minimum": 0, "maximum": 100},
            "qualified": {"type": "boolean"},
            "must_have_missing": {"type": "array", "items": {"type": "string"}},
            "nice_to_have_missing": {"type": "array", "items": {"type": "string"}},
            "must_have_matched": {
                "type": "array",
                "items": {
                    "type": "object",
                    "additionalProperties": False,
                    "properties": {
                        "skill": {"type": "string"},
                        "evidence": {"type": ["string", "null"]},
                    },
                    "required": ["skill", "evidence"],
                },
            },
            "nice_to_have_matched": {
                "type": "array",
                "items": {
                    "type": "object",
                    "additionalProperties": False,
                    "properties": {
                        "skill": {"type": "string"},
                        "evidence": {"type": ["string", "null"]},
                    },
                    "required": ["skill", "evidence"],
                },
            },
            "notes": {"type": "array", "items": {"type": "string"}},
        },
        "required": [
            "role",
            "coverage_percentage",
            "qualified",
            "must_have_missing",
            "nice_to_have_missing",
            "must_have_matched",
            "nice_to_have_matched",
            "notes",
        ],
    }

@retry(stop=stop_after_attempt(3), wait=wait_exponential(min=1, max=10))
def analyze_skill_gap(
    resume_text: str,
    role: str,
    must_have: list[str],
    nice_to_have: list[str],
    qualification_threshold: int = 70,
) -> dict:
    system = (
        "You are a strict skill-gap analyzer for Australian tech roles. "
        "Only count a skill as matched if there is explicit evidence in the resume text. "
        "If uncertain, mark it missing. "
        "Compute coverage_percentage primarily from must-have skills. "
        "Set qualified=true if coverage_percentage >= qualification_threshold. "
        "Return ONLY valid JSON matching the schema."
    )

    payload = {
        "role": role,
        "qualification_threshold": qualification_threshold,
        "role_template": {"must_have": must_have, "nice_to_have": nice_to_have},
        "resume_text": resume_text[:20000],
    }

    resp = client.responses.create(
        model=settings.OPENAI_MODEL,
        input=[
            {"role": "system", "content": system},
            {"role": "user", "content": json.dumps(payload)},
        ],
        response_format={
            "type": "json_schema",
            "name": "skill_gap_output",
            "strict": True,
            "schema": _skill_gap_json_schema(),
        },
    )

    return json.loads(resp.output_text)