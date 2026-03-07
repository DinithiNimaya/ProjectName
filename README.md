# AUSkillPath 🇦🇺
### AI-Driven Study Plan Recommender Based on Australian Tech Job Market Trends

AUSkillPath is a full-stack web application that analyses your resume against Australian technology job market requirements and generates a personalised, structured weekly study plan to close your skills gap.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Running with Docker](#running-with-docker)
- [API Documentation](#api-documentation)
- [Team](#team)

---

## Overview

The Australian technology job market is highly competitive and rapidly evolving. AUSkillPath helps students and job seekers understand:

- Which skills are most in demand for specific roles (e.g. Data Analyst, BI Analyst)
- How their current skillset compares to market expectations
- What structured learning path they should follow to close their skills gap

The system uses AI-powered semantic skill gap analysis to compare resume content against predefined Australian job role templates and generates a structured weekly study plan based on the identified gaps.

---

## Features

- 📄 **Resume Upload** — Upload your resume in PDF or DOCX format
- 🔍 **AI Skill Gap Analysis** — Semantic comparison of your skills against Australian job role requirements
- 📊 **Results Dashboard** — Visual coverage percentage, qualification status, and colour-coded skill breakdown
- 🗓️ **Personalised Study Plan** — Structured 8-week weekly plan with tasks, resources, and progress tracking
- 💾 **Progress Tracking** — Mark weekly tasks as complete with persistent localStorage state
- 🔄 **Role Comparison** — Toggle between job roles to compare skill requirements

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Next.js 14 (React), Tailwind CSS, Recharts |
| Backend | FastAPI (Python) |
| AI | OpenAI API (GPT-4o) |
| Database | PostgreSQL |
| ORM | SQLAlchemy + Alembic |
| Containerisation | Docker + Docker Compose |
| File Parsing | PyMuPDF (PDF), python-docx (DOCX) |

---

## Project Structure

```
auskillpath/
├── frontend/                   # Next.js application (Member C)
│   ├── app/
│   │   ├── page.js             # Landing & onboarding page
│   │   ├── upload/page.js      # Resume upload page
│   │   ├── results/page.js     # Results dashboard
│   │   └── study-plan/page.js  # Study plan page
│   ├── components/
│   │   ├── layout/
│   │   │   └── Navbar.js
│   │   └── ui/
│   │       ├── OnboardingForm.js
│   │       ├── ResumeUpload.js
│   │       ├── CoverageCircle.js
│   │       ├── SkillsBreakdown.js
│   │       ├── QualificationBanner.js
│   │       └── SkillsChart.js
│   └── utils/
│       ├── api.js              # Centralised API call functions
│       └── mockData.js         # Mock data for development
│
├── backend/                    # FastAPI application (Member B)
│   ├── main.py                 # FastAPI app entry point
│   ├── routers/
│   │   ├── upload.py           # File upload endpoint
│   │   ├── analysis.py         # Skill gap analysis endpoint
│   │   └── study_plan.py       # Study plan generation endpoint
│   ├── services/
│   │   ├── parser.py           # Resume text extraction
│   │   └── ai_service.py       # OpenAI API integration
│   └── requirements.txt
│
├── database/                   # PostgreSQL setup (Member A)
│   ├── models.py               # SQLAlchemy models
│   ├── migrations/             # Alembic migration files
│   └── seeds/                  # Seed data for roles and skills
│
├── docker-compose.yml
└── README.md
```

---

## Getting Started

### Prerequisites

Make sure you have the following installed:

- [Node.js](https://nodejs.org/) v18 or higher
- [Python](https://www.python.org/) 3.10 or higher
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/)

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/auskillpath.git
cd auskillpath
```

### 2. Set Up Environment Variables

Copy the example environment files and fill in your values:

```bash
cp .env.example .env
```

See the [Environment Variables](#environment-variables) section below for all required values.

### 3. Run the Frontend Locally

```bash
cd frontend
npm install
npm run dev
```

Frontend runs at: `http://localhost:3000`

### 4. Run the Backend Locally

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

Backend runs at: `http://localhost:8000`

### 5. Run the Database Locally

```bash
# Make sure Docker Desktop is running, then:
docker-compose up db
```

PostgreSQL runs at: `localhost:5432`

---

## Environment Variables

Create a `.env` file in the project root using the template below. **Never commit this file to version control.**

```env
# OpenAI
OPENAI_API_KEY=your_openai_api_key_here

# PostgreSQL
POSTGRES_USER=auskillpath
POSTGRES_PASSWORD=your_password_here
POSTGRES_DB=auskillpath_db
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:8000

# Backend
DATABASE_URL=postgresql://auskillpath:your_password_here@localhost:5432/auskillpath_db
```

> ⚠️ The `.env` file is listed in `.gitignore` and will never be committed. Never hardcode API keys or credentials directly in your code.

---

## Running with Docker

To run the entire stack (frontend, backend, and database) with a single command:

```bash
docker-compose up --build
```

This will start:
| Service | URL |
|---|---|
| Frontend (Next.js) | http://localhost:3000 |
| Backend (FastAPI) | http://localhost:8000 |
| Database (PostgreSQL) | localhost:5432 |

To stop all services:

```bash
docker-compose down
```

To rebuild after making changes:

```bash
docker-compose up --build --force-recreate
```

---

## API Documentation

Once the backend is running, interactive API documentation is available at:

- **Swagger UI:** `http://localhost:8000/docs`
- **ReDoc:** `http://localhost:8000/redoc`

### Key Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/upload` | Upload a resume (PDF or DOCX) |
| `POST` | `/analyse` | Run skill gap analysis on uploaded resume |
| `POST` | `/study-plan` | Generate a personalised weekly study plan |
| `GET` | `/results/{user_id}` | Retrieve saved analysis results |
| `GET` | `/health` | Health check endpoint |

### Expected API Response Shape

The frontend expects the following JSON structure from the `/analyse` endpoint:

```json
{
  "coverage_percentage": 72.5,
  "is_qualified": false,
  "motivational_summary": "You're 72% of the way to your goal...",
  "detected_skills": ["Python", "SQL", "Excel"],
  "missing_must_have": ["Power BI", "Azure", "Machine Learning"],
  "missing_nice_to_have": ["Spark", "dbt", "Looker"]
}
```

And the following structure from the `/study-plan` endpoint:

```json
{
  "duration_weeks": 8,
  "plan": [
    {
      "week": 1,
      "topic": "Power BI Fundamentals",
      "tasks": [
        "Complete the Power BI Desktop Getting Started tutorial",
        "Build your first dashboard using the sample Superstore dataset"
      ],
      "resources": [
        { "title": "Microsoft Learn — Power BI Fundamentals", "url": "https://...", "format": "Free Course" }
      ]
    }
  ]
}
```

---

## Team

| Member | Role | Responsibilities |
|---|---|---|
| Eric | Database Engineer | PostgreSQL schema, seed data, query optimisation |
| Dinithi | AI / Backend Engineer | FastAPI, OpenAI integration, resume parsing |
| Marilia | Frontend Engineer | Next.js UI, components, API integration |

---

## Acknowledgements

- Built as part of an academic project aligned with the Australian technology job market
- Job role skill templates sourced from Australian job listings on Seek and LinkedIn AU
- AI analysis powered by [OpenAI](https://openai.com)
- Frontend bootstrapped with [Next.js](https://nextjs.org)
- Backend built with [FastAPI](https://fastapi.tiangolo.com)
