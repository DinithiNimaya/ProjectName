# AUSkillPath — Database Setup Guide

---

## About the Database

AUSkillPath uses a **PostgreSQL** database with **9 tables** across 3 layers:

**Foundation Layer** — core user data
- `roles` — the 3 available job roles (Data Analyst, BI Analyst, Data Engineer)
- `users` — registered user accounts
- `resumes` — uploaded CV file paths

**Result Layer** — AI scan output
- `analyses` — scan result per CV (score, pass/fail, motivational message, role)
- `analyze_skills` — individual skills found per scan (one row per skill)

**Plan Layer** — 8-week study plan
- `study_plans` — plan header and overall progress
- `study_plan_details` — one row per week (8 rows per plan)
- `study_plan_tasks` — checkbox tasks per week
- `study_plan_resources` — learning links per week

**Key numbers:**
- 10 relationships connecting all tables
- 13 loopholes found and fixed with constraints, UNIQUE, CHECK, and triggers
- 10 indexes on all FK columns for fast queries
- 3 ENUM types: `experience_level`, `file_type`, `skill_status`

---

## Files You Need

| File | What it does |
|---|---|
| `01_AUSkillPath_Schema.sql` | Builds all 9 tables with constraints, indexes, and triggers |
| `02_AUSkillPath_seed.sql` | Loads sample data for testing |

---

## Step 1 — Pull from GitHub

Open terminal and run:

```bash
git pull origin main
```

Confirm you have these files in the repo:
```
01_AUSkillPath_Schema.sql
02_AUSkillPath_seed.sql
```

---

## Step 2 — Create the Database in pgAdmin

1. Open **pgAdmin 4**
2. Right-click **Databases** → **Create** → **Database**
3. Name it: `auskillpath`
4. Click **Save**

---

## Step 3 — Run the Schema

1. Click on the `auskillpath` database
2. Click **Tools** → **Query Tool**
3. Click the folder icon → open `01_AUSkillPath_Schema.sql`
4. Press **F5**

You should see messages like:
```
DROP TABLE
DROP TABLE
...
CREATE TYPE
CREATE TABLE
CREATE TABLE
...
CREATE INDEX
CREATE TRIGGER
Query returned successfully.
```

---

## Step 4 — Run the Seed Data

Still in Query Tool:

1. Click the folder icon → open `02_AUSkillPath_seed.sql`
2. Press **F5**

You should see:
```
INSERT 0 3
INSERT 0 1
INSERT 0 1
INSERT 0 1
INSERT 0 12
INSERT 0 1
INSERT 0 8
...
Query returned successfully.
```

---

## Step 5 — Verify the Schema

Paste this in Query Tool and press **F5:**

```sql
SELECT
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns
     WHERE table_name = t.table_name
     AND table_schema = 'public') AS column_count
FROM information_schema.tables t
WHERE table_schema = 'public'
ORDER BY table_name;
```

**Expected result — 9 tables:**

| table_name | column_count |
|---|---|
| analyze_skills | 4 |
| analyses | 8 |
| resumes | 5 |
| roles | 2 |
| study_plan_details | 6 |
| study_plan_resources | 5 |
| study_plan_tasks | 5 |
| study_plans | 7 |
| users | 8 |

---

## Step 6 — Verify the Seed Data

Paste this and press **F5:**

```sql
SELECT 'roles'                AS table_name, COUNT(*) AS rows FROM roles
UNION ALL SELECT 'users',               COUNT(*) FROM users
UNION ALL SELECT 'resumes',             COUNT(*) FROM resumes
UNION ALL SELECT 'analyses',            COUNT(*) FROM analyses
UNION ALL SELECT 'analyze_skills',      COUNT(*) FROM analyze_skills
UNION ALL SELECT 'study_plans',         COUNT(*) FROM study_plans
UNION ALL SELECT 'study_plan_details',  COUNT(*) FROM study_plan_details
UNION ALL SELECT 'study_plan_tasks',    COUNT(*) FROM study_plan_tasks
UNION ALL SELECT 'study_plan_resources',COUNT(*) FROM study_plan_resources;
```

**Expected row counts:**

| table_name | rows |
|---|---|
| roles | 3 |
| users | 1 |
| resumes | 1 |
| analyses | 1 |
| analyze_skills | 12 |
| study_plans | 1 |
| study_plan_details | 8 |
| study_plan_tasks | 26 |
| study_plan_resources | 8 |

---

## Troubleshooting — Common Errors

### ERROR: table already exists

```
ERROR: relation "users" already exists
```

**Fix:** Just re-run `01_AUSkillPath_Schema.sql` — it has DROP TABLE at the top so it wipes and rebuilds cleanly.

---

### ERROR: relation does not exist

```
ERROR: relation "study_plans" does not exist
```

**Fix:** You ran the seed before the schema. Always run in this order:

1. `01_AUSkillPath_Schema.sql` first
2. `02_AUSkillPath_seed.sql` second
