from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from pydantic import BaseModel

from app.services.resume_parser import extract_resume_text
from app.services.analysis_service import analyze_resume_with_ollama
from app.services.ollama_service import generate_study_plan
from app.services.adzuna_service import search_jobs_by_role
from app.services.postgres_storage import (
    create_user,
    create_resume,
    create_analysis,
    insert_analysis_skills,
    save_study_plan_full,
)

router = APIRouter(tags=["frontend-compat"])


# Temporary memory (only for flow linking)
UPLOAD_CONTEXT = {}
ANALYSIS_CONTEXT = {}


# ===================== UPLOAD =====================
@router.post("/upload")
async def upload_resume(
    file: UploadFile = File(...),
    name: str = Form(...),
    role: str = Form(...),
    experience: str = Form(""),
    study_hours: str = Form("8"),
):
    try:
        filename = file.filename or ""

        if not (filename.lower().endswith(".pdf") or filename.lower().endswith(".docx")):
            raise HTTPException(
                status_code=400,
                detail="Only PDF and DOCX files are allowed."
            )

        content = await file.read()
        resume_text = extract_resume_text(filename, content)

        if len(resume_text.strip()) < 100:
            raise HTTPException(
                status_code=400,
                detail="Could not extract enough text from the resume."
            )

        study_hour_int = int(study_hours) if str(study_hours).isdigit() else 8

        user_id = create_user(
            name=name,
            role_name=role,
            experience=experience,
            study_hour=study_hour_int,
            email=None,
        )

        file_type = "pdf" if filename.lower().endswith(".pdf") else "docx"
        file_path = f"/uploads/{filename}"

        resume_id = create_resume(
            user_id=user_id,
            file_path=file_path,
            file_type=file_type,
        )

        UPLOAD_CONTEXT[resume_id] = {
            "user_id": user_id,
            "resume_id": resume_id,
            "resume_text": resume_text,
            "role": role,
            "study_hours": study_hour_int,
        }

        return {
            "success": True,
            "user_id": str(user_id),
            "resume_id": str(resume_id),
            "filename": filename,
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Upload failed: {str(e)}")


# ===================== ANALYSE =====================
class AnalyseRequest(BaseModel):
    user_id: str
    resume_id: str
    role: str


@router.post("/analyse")
async def analyse_resume(request: AnalyseRequest):
    try:
        resume_id = int(request.resume_id)
        user_id = int(request.user_id)

        context = UPLOAD_CONTEXT.get(resume_id)
        if not context:
            raise HTTPException(status_code=404, detail="Resume not found.")

        resume_text = context["resume_text"]

        analysis = await analyze_resume_with_ollama(resume_text, request.role)

        percentage = float(analysis.get("coverage_percentage", 0))
        is_qualified = bool(analysis.get("is_qualified", False))
        summary = analysis.get("summary", "")

        analyze_id = create_analysis(
            user_id=user_id,
            resume_id=resume_id,
            is_qualified=is_qualified,
            percentage=percentage,
            motivational_summary=summary,
        )

        insert_analysis_skills(
            analyze_id=analyze_id,
            detected_skills=analysis.get("detected_skills", []),
            missing_must_have=analysis.get("missing_must_have", []),
            missing_nice_to_have=analysis.get("missing_nice_to_have", []),
        )

        jobs = []
        try:
            jobs = await search_jobs_by_role(
                role=request.role,
                location="Sydney",
                page=1,
                results_per_page=6,
            )
        except Exception:
            jobs = []  # jobs API failure should not break analysis

        ANALYSIS_CONTEXT[analyze_id] = {
            "analyze_id": analyze_id,
            "user_id": user_id,
            "resume_id": resume_id,
            "role": request.role,
            "study_hours": context["study_hours"],
        }

        return {
            "success": True,
            "user_id": str(user_id),
            "resume_id": str(resume_id),
            "result_id": str(analyze_id),
            "analysis": {
                "coverage_percentage": percentage,
                "is_qualified": is_qualified,
                "detected_skills": analysis.get("detected_skills", []),
                "missing_must_have": analysis.get("missing_must_have", []),
                "missing_nice_to_have": analysis.get("missing_nice_to_have", []),
                "summary": summary,
            },
            "coverage_percentage": percentage,
            "is_qualified": is_qualified,
            "detected_skills": analysis.get("detected_skills", []),
            "missing_must_have": analysis.get("missing_must_have", []),
            "missing_nice_to_have": analysis.get("missing_nice_to_have", []),
            "summary": summary,
            "jobs": jobs,
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analyse failed: {str(e)}")


# ===================== STUDY PLAN =====================
class StudyPlanRequest(BaseModel):
    user_id: str
    result_id: str
    study_hours: int


@router.post("/study-plan")
async def create_study_plan(request: StudyPlanRequest):
    try:
        analyze_id = int(request.result_id)
        user_id = int(request.user_id)

        context = ANALYSIS_CONTEXT.get(analyze_id)
        if not context:
            raise HTTPException(status_code=404, detail="Analysis result not found.")

        if context["user_id"] != user_id:
            raise HTTPException(status_code=404, detail="User mismatch.")

        resume_id = context["resume_id"]
        upload_ctx = UPLOAD_CONTEXT.get(resume_id)

        if not upload_ctx:
            raise HTTPException(status_code=404, detail="Resume context not found.")

        role = context["role"]
        resume_text = upload_ctx["resume_text"]

        weeks = 8
        study_hours = int(request.study_hours)

        study_plan = await generate_study_plan(
            role=role,
            weeks=weeks,
            resume_text=resume_text,
        )

        # Save to PostgreSQL
        save_study_plan_full(
            analyze_id=analyze_id,
            role_name=role,
            study_hours_per_week=study_hours,
            study_plan=study_plan,
        )

        return {
            "success": True,
            "user_id": str(user_id),
            "result_id": str(analyze_id),
            "study_plan": study_plan,
            "weeks": weeks,
        }

    except HTTPException:
        raise

    except RuntimeError as e:
        raise HTTPException(
            status_code=502,
            detail=str(e)
        )

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Study plan failed: {str(e)}"
        )