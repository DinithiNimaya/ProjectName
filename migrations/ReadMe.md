# AUSkillPath — Database Setup Guide

\---

## About the Database

AUSkillPath uses a **PostgreSQL** database with **9 tables** across 3 layers:

**Foundation Layer** — core user data

* `roles` — the 3 available job roles (Data Analyst, BI Analyst, Data Engineer)
* `users` — registered user accounts
* `resumes` — uploaded CV file paths

**Result Layer** — AI scan output

* `analyses` — scan result per CV (score, pass/fail, motivational message, role)
* `analyze\_skills` — individual skills found per scan (one row per skill)

**Plan Layer** — 8-week study plan

* `study\_plans` — plan header and overall progress
* `study\_plan\_details` — one row per week (8 rows per plan)
* `study\_plan\_tasks` — checkbox tasks per week
* `study\_plan\_resources` — learning links per week

**Key numbers:**

* 10 relationships connecting all tables
* 13 loopholes found and fixed with constraints, UNIQUE, CHECK, and triggers
* 10 indexes on all FK columns for fast queries
* 3 ENUM types: `experience\_level`, `file\_type`, `skill\_status`

\---

## Files You Need

|File|What it does|
|-|-|
|`01\_AUSkillPath\_Schema.sql`|Builds all 9 tables with constraints, indexes, and triggers|
|`02\_AUSkillPath\_seed.sql`|Loads sample data for testing|

\---

## Step 1 — Pull from GitHub

Open terminal and run:

```bash
git pull origin main
```

Confirm you have these files in the repo:

```
01\_AUSkillPath\_Schema.sql
02\_AUSkillPath\_seed.sql
```

\---

## Step 2 — Create the Database in pgAdmin

1. Open **pgAdmin 4**
2. Right-click **Databases** → **Create** → **Database**
3. Name it: `auskillpath`
4. Click **Save**

\---

## Step 3 — Run the Schema

1. Click on the `auskillpath` database
2. Click **Tools** → **Query Tool**
3. Click the folder icon → open `01\_AUSkillPath\_Schema.sql`
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

\---

## Step 4 — Run the Seed Data

Still in Query Tool:

1. Click the folder icon → open `02\_AUSkillPath\_seed.sql`
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

\---

## Step 5 — Verify the Schema

Paste this in Query Tool and press **F5:**

```sql
SELECT
    table\_name,
    (SELECT COUNT(\*) FROM information\_schema.columns
     WHERE table\_name = t.table\_name
     AND table\_schema = 'public') AS column\_count
FROM information\_schema.tables t
WHERE table\_schema = 'public'
ORDER BY table\_name;
```

**Expected result — 9 tables:**

|table\_name|column\_count|
|-|-|
|analyze\_skills|4|
|analyses|8|
|resumes|5|
|roles|2|
|study\_plan\_details|6|
|study\_plan\_resources|5|
|study\_plan\_tasks|5|
|study\_plans|7|
|users|8|

\---

## Step 6 — Verify the Seed Data

Paste this and press **F5:**

```sql
SELECT 'roles'                AS table\_name, COUNT(\*) AS rows FROM roles
UNION ALL SELECT 'users',               COUNT(\*) FROM users
UNION ALL SELECT 'resumes',             COUNT(\*) FROM resumes
UNION ALL SELECT 'analyses',            COUNT(\*) FROM analyses
UNION ALL SELECT 'analyze\_skills',      COUNT(\*) FROM analyze\_skills
UNION ALL SELECT 'study\_plans',         COUNT(\*) FROM study\_plans
UNION ALL SELECT 'study\_plan\_details',  COUNT(\*) FROM study\_plan\_details
UNION ALL SELECT 'study\_plan\_tasks',    COUNT(\*) FROM study\_plan\_tasks
UNION ALL SELECT 'study\_plan\_resources',COUNT(\*) FROM study\_plan\_resources;
```

**Expected row counts:**

|table\_name|rows|
|-|-|
|roles|3|
|users|1|
|resumes|1|
|analyses|1|
|analyze\_skills|12|
|study\_plans|1|
|study\_plan\_details|8|
|study\_plan\_tasks|26|
|study\_plan\_resources|8|

\---

## Troubleshooting — Common Errors

### ❌ ERROR: table already exists

```
ERROR: relation "users" already exists
```

**Fix:** Just re-run `01\_AUSkillPath\_Schema.sql` — it has DROP TABLE at the top so it wipes and rebuilds cleanly.

\---

### ❌ ERROR: relation "..." does not exist

```
ERROR: relation "study\_plans" does not exist
```

**Fix:** You ran the seed before the schema. Always run in this order:

1. `01\_AUSkillPath\_Schema.sql` first
2. `02\_AUSkillPath\_seed.sql` second



\---

## 

