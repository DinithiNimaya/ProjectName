AUSkillPath: AI-Driven Study Plan Recommender Based on Australian Tech Job Market Trends
1. Problem Statement
The Australian technology job market is highly competitive and rapidly evolving. Students often struggle to understand:
Which skills are most in demand for specific roles (e.g., Data Analyst, BI Analyst)
How their current skillset compares to market expectations
What structured learning path they should follow to close their skills gap
Existing platforms (e.g., LinkedIn) provide job matching or general skill insights, but they do not offer a data-driven, personalised study roadmap based on local job market analytics.
This project proposes an AI-powered system that performs semantic skill gap analysis and generates structured study plans.

Project Description:
The system is an AI-powered web application that integrates Natural Language Processing via a Large Language Model to analyze resume content and generate a personalized, structured weekly study plan based on Australian job market role requirements.
It combines:
Modern frontend framework (Next.js)
High-performance API backend (FastAPI)
Relational database (PostgreSQL)
Containerized deployment (Docker)
AI-driven semantic reasoning (OpenAI LLM)


2. Objectives
The main objectives of this project are:
Enable resume upload in PDF or DOCX format.
Extract and store resume text using automated parsing.
Compare resume content against predefined job role skill templates.
Integrate a Large Language Model (LLM) to perform semantic skill gap analysis.
Determine whether a candidate meets qualification thresholds.
Generate structured weekly study plans based on:
Missing skills
User-defined study duration

Store analysis results in a relational database.
Provide a user-friendly web interface for interaction.

3. Scope
In Scope
Resume upload and text extraction.
AI-based skill gap analysis.
Role-based skill template comparison.
Personalized weekly study plan generation.
Qualification threshold evaluation.
Database storage of results.
Docker-based deployment.
Out of Scope
Direct job application submission.
Real-time scraping of Australian job portals.
Certification tracking or enrollment automation.
Multi-language resume support (English only in current version).
Advanced authentication and user account management (basic user_id used).


