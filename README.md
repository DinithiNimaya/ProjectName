# 🤖 AUSkillPath — AI Backend Module

##  Overview
This backend handles AI-powered features:
- Resume text extraction
- Skill gap analysis (Ollama)
- Job description generation (Adzuna)
- Study plan generation (Ollama)

---

##  AI Workflow
Resume → Text Extraction → AI Analysis → Job Fetch → Study Plan → Frontend

---

##  Technologies
- FastAPI
- Ollama (LLM)
- Adzuna API
- httpx
- PyMuPDF
- python-docx

---

##  Setup

### 1. Create virtual environment
python3 -m venv .venv
source .venv/bin/activate


### 2. Install dependencies
pip install fastapi uvicorn httpx python-dotenv pymupdf python-docx


### 3. Run backend
uvicorn app.main:app --reload --port 8000


---

## 🔌 API Endpoints

### Generate Study Plan
POST /study-plan/generate

### Fetch Jobs
POST /jobs/search

---

## Notes
- No hardcoded study plans
- Fully AI-generated outputs
- Ollama must be running locally

---

## Author
Dinithi Nimaya  
AI Backend Developer