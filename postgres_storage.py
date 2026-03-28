import uuid
from app.core.db import get_connection


def _make_placeholder_email(name: str) -> str:
    safe = (name or "user").strip().lower().replace(" ", ".")
    return f"{safe}.{uuid.uuid4().hex[:6]}@auskillpath.local"


def normalize_resource_format(resource_format: str) -> str:
    """
    To avoid DB check-constraint failures, always store a safe allowed value.
    """
    return "Free Course"


def get_role_id_by_name(role_name: str) -> int:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT role_id FROM roles WHERE role_name = %s LIMIT 1",
                (role_name,),
            )
            row = cur.fetchone()
            if not row:
                raise ValueError(f"Role not found in database: {role_name}")
            return row["role_id"]


def create_user(
    name: str,
    role_name: str,
    experience: str,
    study_hour: int,
    email: str | None = None,
) -> int:
    role_id = get_role_id_by_name(role_name)
    final_email = email or _make_placeholder_email(name)

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO users (name, email, role_id, experience, study_hour)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING user_id
                """,
                (name, final_email, role_id, experience, study_hour),
            )
            row = cur.fetchone()
        conn.commit()
        return row["user_id"]


def create_resume(user_id: int, file_path: str, file_type: str) -> int:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO resumes (user_id, file_path, file_type)
                VALUES (%s, %s, %s)
                RETURNING resume_id
                """,
                (user_id, file_path, file_type),
            )
            row = cur.fetchone()
        conn.commit()
        return row["resume_id"]


def create_analysis(
    user_id: int,
    resume_id: int,
    is_qualified: bool,
    percentage: float,
    motivational_summary: str,
) -> int:
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO analyses (user_id, resume_id, is_qualified, percentage, motivational_summary)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING analyze_id
                """,
                (user_id, resume_id, is_qualified, percentage, motivational_summary),
            )
            row = cur.fetchone()
        conn.commit()
        return row["analyze_id"]


def insert_analysis_skills(
    analyze_id: int,
    detected_skills: list[str],
    missing_must_have: list[str],
    missing_nice_to_have: list[str],
) -> None:
    rows = []

    for skill in detected_skills or []:
        rows.append((analyze_id, skill, "have"))

    for skill in missing_must_have or []:
        rows.append((analyze_id, skill, "must_develop"))

    for skill in missing_nice_to_have or []:
        rows.append((analyze_id, skill, "nice_develop"))

    if not rows:
        return

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.executemany(
                """
                INSERT INTO analyze_skills (analyze_id, skill_name, status)
                VALUES (%s, %s, %s)
                """,
                rows,
            )
        conn.commit()


def save_study_plan_full(
    analyze_id: int,
    role_name: str,
    study_hours_per_week: int,
    study_plan: dict,
) -> int:
    role_id = get_role_id_by_name(role_name)
    duration_weeks = int(study_plan.get("weeks", 8) or 8)
    weekly_plan = study_plan.get("weekly_plan", []) or []

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO study_plans (analyze_id, role_id, duration_weeks, study_hours_per_week, progress)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (analyze_id)
                DO UPDATE SET
                    role_id = EXCLUDED.role_id,
                    duration_weeks = EXCLUDED.duration_weeks,
                    study_hours_per_week = EXCLUDED.study_hours_per_week
                RETURNING study_plan_id
                """,
                (analyze_id, role_id, duration_weeks, study_hours_per_week, 0.0),
            )
            study_plan_row = cur.fetchone()
            study_plan_id = study_plan_row["study_plan_id"]

            cur.execute(
                """
                DELETE FROM study_plan_resources
                WHERE detail_id IN (
                    SELECT detail_id FROM study_plan_details WHERE study_plan_id = %s
                )
                """,
                (study_plan_id,),
            )

            cur.execute(
                """
                DELETE FROM study_plan_tasks
                WHERE detail_id IN (
                    SELECT detail_id FROM study_plan_details WHERE study_plan_id = %s
                )
                """,
                (study_plan_id,),
            )

            cur.execute(
                "DELETE FROM study_plan_details WHERE study_plan_id = %s",
                (study_plan_id,),
            )

            for week in weekly_plan:
                week_number = int(week.get("week", 1))
                week_name = week.get("focus") or f"Week {week_number}"
                estimated_hour = study_hours_per_week

                cur.execute(
                    """
                    INSERT INTO study_plan_details
                        (study_plan_id, week_number, name, estimated_hour, is_completed)
                    VALUES (%s, %s, %s, %s, %s)
                    RETURNING detail_id
                    """,
                    (study_plan_id, week_number, week_name, estimated_hour, False),
                )
                detail_row = cur.fetchone()
                detail_id = detail_row["detail_id"]

                for task in week.get("tasks", []) or []:
                    cur.execute(
                        """
                        INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at)
                        VALUES (%s, %s, %s, %s)
                        """,
                        (detail_id, task, False, None),
                    )

                for resource in week.get("resources", []) or []:
                    if isinstance(resource, dict):
                        resource_name = resource.get("title") or resource.get("name") or "Learning Resource"
                        resource_link = resource.get("url") or resource.get("resource_link") or ""
                    else:
                        resource_name = str(resource)
                        resource_link = ""

                    resource_format = normalize_resource_format("Free Course")

                    cur.execute(
                        """
                        INSERT INTO study_plan_resources (detail_id, name, resource_link, format)
                        VALUES (%s, %s, %s, %s)
                        """,
                        (detail_id, resource_name, resource_link, resource_format),
                    )

        conn.commit()
        return study_plan_id