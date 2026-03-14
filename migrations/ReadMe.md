## Step 1 — Install Required Tools

| Tool | Download Link |
|------|--------------|
| PostgreSQL 16+ | https://www.postgresql.org/download/ |
| pgAdmin 4 | https://www.pgadmin.org/download/ |

> When installing PostgreSQL, you will be asked to create a password for the `postgres` user. **Remember this password** — you will need it in Step 7.

---

## Step 2 — Get the File from GitHub

1. Go to our GitHub repository
2. Download this one file:
   - `AUSkillPath v1.0.0.sql` ← this contains everything (schema + seed data combined)
3. Save it somewhere easy to find (e.g. Desktop)

---

## Step 3 — Open pgAdmin

1. Open **pgAdmin 4**
2. In the left panel → **Servers → PostgreSQL**
3. Enter your `postgres` password when asked
4. You should see the server listed as connected

---

## Step 4 — Create the Database

1. Right-click **Databases** → **Create → Database**
2. In the **Database** field, type: `auskillpath`  
   *(must be lowercase, exactly as written)*
3. Click **Save**
4. `auskillpath` should now appear in the left panel

---

## Step 5 — Open Query Tool

1. Click on `auskillpath` in the left panel to select it  
   *(important — must be selected first)*
2. Click **Tools → Query Tool** from the top menu bar

---

## Step 6 — Run the Setup File

1. In Query Tool, click the **folder icon** (top left) → Open file
2. Select `AUSkillPath v1.0.0.sql` → Open
3. Click **Run (F5)**
4. This runs schema + seed data in one go
5. Check the **Messages** tab — you should see:

```
CREATE TYPE      ← 3 times
CREATE TABLE     ← 9 times
CREATE INDEX     ← 10 times
INSERT 0 3       ← roles
INSERT 0 1       ← users
INSERT 0 1       ← resumes
INSERT 0 1       ← analyses
INSERT 0 12      ← analyze_skills
INSERT 0 1       ← study_plans
INSERT 0 8       ← study_plan_details
INSERT 0 26      ← study_plan_tasks
INSERT 0 8       ← study_plan_resources
```

---

## Step 7 — Verify It Worked

Copy and paste this query into Query Tool and click Run:

```sql
SELECT 'roles'                AS tabel, COUNT(*) AS rows FROM roles
UNION ALL SELECT 'users',                COUNT(*) FROM users
UNION ALL SELECT 'resumes',              COUNT(*) FROM resumes
UNION ALL SELECT 'analyses',             COUNT(*) FROM analyses
UNION ALL SELECT 'analyze_skills',       COUNT(*) FROM analyze_skills
UNION ALL SELECT 'study_plans',          COUNT(*) FROM study_plans
UNION ALL SELECT 'study_plan_details',   COUNT(*) FROM study_plan_details
UNION ALL SELECT 'study_plan_tasks',     COUNT(*) FROM study_plan_tasks
UNION ALL SELECT 'study_plan_resources', COUNT(*) FROM study_plan_resources;
```

Expected result — if these numbers match, you are done ✅:

| tabel | rows |
|-------|------|
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
