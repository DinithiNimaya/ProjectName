from fastapi import APIRouter, UploadFile, File, HTTPException
from pydantic import BaseModel, Field
from app.services.resume_parser import extract_resume_text
from app.services.openai_service import analyze_skill_gap

router = APIRouter(prefix="/resume", tags=["resume"])


# =========================
# 1️⃣ Resume Upload Endpoint
# =========================
@router.post("/upload")
async def upload_resume(file: UploadFile = File(...)):
    try:
        content = await file.read()
        text = extract_resume_text(file.filename, content)

        # Basic validation
        if len(text) < 300:
            raise HTTPException(
                status_code=400,
                detail="Resume text too short. Please upload a clearer PDF/DOCX."
            )

        return {
            "filename": file.filename,
            "chars": len(text),
            "resume_text": text
        }

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


# =========================
# 2️⃣ Skill Gap Analysis Endpoint
# =========================
class AnalyzeRequest(BaseModel):
    role: str = Field(..., examples=["Data Analyst"])
    must_have: list[str]
    nice_to_have: list[str] = []
    qualification_threshold: int = 70
    resume_text: str


@router.post("/analyze")
async def analyze(req: AnalyzeRequest):

    # Validation
    if not req.must_have:
        raise HTTPException(
            status_code=400,
            detail="must_have list cannot be empty."
        )

    if len(req.resume_text) < 300:
        raise HTTPException(
            status_code=400,
            detail="Resume text too short."
        )

    try:
        result = analyze_skill_gap(
            resume_text=req.resume_text,
            role=req.role,
            must_have=req.must_have,
            nice_to_have=req.nice_to_have,
            qualification_threshold=req.qualification_threshold,
        )

        return result

    except Exception as e:
        raise HTTPException(
            status_code=502,
            detail=f"AI service error: {str(e)}"
        )