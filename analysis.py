from pydantic import BaseModel, Field
from typing import List, Optional

class SkillItem(BaseModel):
    skill: str = Field(..., min_length=1)
    evidence: Optional[str] = None

class SkillGapOutput(BaseModel):
    role: str
    coverage_percentage: int = Field(..., ge=0, le=100)
    qualified: bool
    must_have_missing: List[str]
    nice_to_have_missing: List[str]
    must_have_matched: List[SkillItem]
    nice_to_have_matched: List[SkillItem]
    notes: List[str] = []