from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.resume_parser import extract_resume_text

router = APIRouter(prefix="/resume", tags=["resume"])

@router.post("/upload")
async def upload_resume(file: UploadFile = File(...)):
    try:
        content = await file.read()
        text = extract_resume_text(file.filename, content)

        if len(text) < 300:
            raise HTTPException(status_code=400, detail="Resume text too short. Upload a clearer PDF/DOCX.")

        return {
            "filename": file.filename,
            "chars": len(text),
            "resume_text": text
        }
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))