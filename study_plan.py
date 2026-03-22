from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from app.services.resume_parser import extract_resume_text
from app.services.ollama_service import generate_study_plan

router = APIRouter(prefix="/study-plan", tags=["study-plan"])


@router.post("/generate")
async def generate_plan(
    target_role: str = Form(...),
    weeks: int = Form(...),
    file: UploadFile = File(...),
):
    try:
        filename = file.filename or ""

        if not (filename.lower().endswith(".pdf") or filename.lower().endswith(".docx")):
            raise HTTPException(
                status_code=400,
                detail="Only PDF and DOCX files are allowed."
            )

        if weeks < 1 or weeks > 52:
            raise HTTPException(
                status_code=400,
                detail="Weeks must be between 1 and 52."
            )

        content = await file.read()
        resume_text = extract_resume_text(filename, content)

        if len(resume_text.strip()) < 100:
            raise HTTPException(
                status_code=400,
                detail="Could not extract enough text from the resume."
            )

        result = await generate_study_plan(
            role=target_role,
            weeks=weeks,
            resume_text=resume_text,
        )

        return {
            "success": True,
            "filename": filename,
            "resume_text_length": len(resume_text),
            "study_plan": result,
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Study plan generation failed: {str(e)}"
        )