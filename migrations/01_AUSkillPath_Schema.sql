DROP TABLE IF EXISTS study_plan_resources  CASCADE;
DROP TABLE IF EXISTS study_plan_tasks      CASCADE;
DROP TABLE IF EXISTS study_plan_details    CASCADE;
DROP TABLE IF EXISTS study_plans           CASCADE;
DROP TABLE IF EXISTS analyze_skills        CASCADE;
DROP TABLE IF EXISTS analyses              CASCADE;
DROP TABLE IF EXISTS resumes               CASCADE;
DROP TABLE IF EXISTS users                 CASCADE;
DROP TABLE IF EXISTS roles                 CASCADE;

DROP TYPE IF EXISTS experience_level CASCADE;
DROP TYPE IF EXISTS file_type        CASCADE;
DROP TYPE IF EXISTS skill_status     CASCADE;

DROP FUNCTION IF EXISTS update_updated_at CASCADE;


CREATE TYPE experience_level AS ENUM (
    'junior',
    'mid',
    'senior'
);

CREATE TYPE file_type AS ENUM (
    'pdf',
    'docx'
);

CREATE TYPE skill_status AS ENUM (
    'have',
    'must_develop',
    'nice_develop'
);


CREATE TABLE roles (
    role_id     SERIAL          PRIMARY KEY,
    role_name   VARCHAR(100)    NOT NULL UNIQUE CHECK (LENGTH(TRIM(role_name)) > 0)
);


CREATE TABLE users (
    user_id     SERIAL              PRIMARY KEY,
    name        VARCHAR(100)        NOT NULL CHECK (LENGTH(TRIM(name)) > 0),
    email       VARCHAR(255)        NOT NULL UNIQUE,
    role_id     INT                 NOT NULL,
    experience  experience_level    NOT NULL,
    study_hour  INT                 NOT NULL
                                    CHECK (study_hour BETWEEN 1 AND 40),
    created_at  TIMESTAMP           NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP           NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles (role_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_users_email_format
        CHECK (email LIKE '%@%.%')
);


CREATE TABLE resumes (
    resume_id   SERIAL      PRIMARY KEY,
    user_id     INT         NOT NULL,
    file_path   TEXT        NOT NULL,
    file_type   file_type   NOT NULL,
    uploaded_at TIMESTAMP   NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_resumes_user
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT uq_resume_path
        UNIQUE (user_id, file_path)
);


CREATE TABLE analyses (
    analyze_id            SERIAL          PRIMARY KEY,
    user_id               INT             NOT NULL,
    resume_id             INT             NOT NULL,
    role_id               INT             NOT NULL,
    is_qualified          BOOLEAN         NOT NULL,
    percentage            DECIMAL(5, 2)   NOT NULL
                                          CHECK (percentage BETWEEN 0 AND 100),
    motivational_summary  TEXT,
    analyzed_at           TIMESTAMP       NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_analyses_user
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_analyses_resume
        FOREIGN KEY (resume_id)
        REFERENCES resumes (resume_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_analyses_role
        FOREIGN KEY (role_id)
        REFERENCES roles (role_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


CREATE TABLE analyze_skills (
    skill_id    SERIAL          PRIMARY KEY,
    analyze_id  INT             NOT NULL,
    skill_name  VARCHAR(100)    NOT NULL CHECK (LENGTH(TRIM(skill_name)) > 0),
    status      skill_status    NOT NULL,

    CONSTRAINT fk_askills_analysis
        FOREIGN KEY (analyze_id)
        REFERENCES analyses (analyze_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT uq_skill_per_analysis
        UNIQUE (analyze_id, skill_name)
);


CREATE TABLE study_plans (
    study_plan_id        SERIAL          PRIMARY KEY,
    analyze_id           INT             NOT NULL,
    duration_weeks       INT             NOT NULL DEFAULT 8
                                         CHECK (duration_weeks BETWEEN 1 AND 52),
    study_hours_per_week INT             NOT NULL
                                         CHECK (study_hours_per_week BETWEEN 1 AND 40),
    progress             DECIMAL(5, 2)   NOT NULL DEFAULT 0.00
                                         CHECK (progress BETWEEN 0 AND 100),
    created_at           TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMP       NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_splan_analysis
        FOREIGN KEY (analyze_id)
        REFERENCES analyses (analyze_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT uq_study_plans_analyze_id
        UNIQUE (analyze_id)
);


CREATE TABLE study_plan_details (
    detail_id       SERIAL          PRIMARY KEY,
    study_plan_id   INT             NOT NULL,
    week_number     INT             NOT NULL
                                    CHECK (week_number BETWEEN 1 AND 8),
    name            VARCHAR(150)    NOT NULL CHECK (LENGTH(TRIM(name)) > 0),
    estimated_hour  INT             NOT NULL CHECK (estimated_hour > 0),
    is_completed    BOOLEAN         NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_sdetail_plan
        FOREIGN KEY (study_plan_id)
        REFERENCES study_plans (study_plan_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT uq_sdetail_week
        UNIQUE (study_plan_id, week_number)
);


CREATE TABLE study_plan_tasks (
    task_id         SERIAL      PRIMARY KEY,
    detail_id       INT         NOT NULL,
    name            TEXT        NOT NULL CHECK (LENGTH(TRIM(name)) > 0),
    is_completed    BOOLEAN     NOT NULL DEFAULT FALSE,
    completed_at    TIMESTAMP   NULL,

    CONSTRAINT fk_stask_detail
        FOREIGN KEY (detail_id)
        REFERENCES study_plan_details (detail_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_task_completion_consistency
        CHECK (is_completed = TRUE OR completed_at IS NULL)
);


CREATE TABLE study_plan_resources (
    resource_id     SERIAL          PRIMARY KEY,
    detail_id       INT             NOT NULL,
    name            VARCHAR(255)    NOT NULL CHECK (LENGTH(TRIM(name)) > 0),
    resource_link   TEXT,
    format          VARCHAR(50)     NOT NULL,

    CONSTRAINT fk_sresource_detail
        FOREIGN KEY (detail_id)
        REFERENCES study_plan_details (detail_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_resource_format
        CHECK (format IN (
            'Free Course',
            'Video',
            'Course',
            'Hands-on',
            'Practice',
            'Article',
            'Docs',
            'Job Board'
        ))
);


CREATE INDEX idx_users_role             ON users               (role_id);
CREATE INDEX idx_resumes_user           ON resumes             (user_id);
CREATE INDEX idx_analyses_user          ON analyses            (user_id);
CREATE INDEX idx_analyses_resume        ON analyses            (resume_id);
CREATE INDEX idx_analyses_role          ON analyses            (role_id);
CREATE INDEX idx_askills_analysis       ON analyze_skills      (analyze_id);
CREATE INDEX idx_splan_analysis         ON study_plans         (analyze_id);

CREATE INDEX idx_sdetail_plan           ON study_plan_details  (study_plan_id);
CREATE INDEX idx_stask_detail           ON study_plan_tasks    (detail_id);
CREATE INDEX idx_sresource_detail       ON study_plan_resources(detail_id);


CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_study_plans_updated_at
    BEFORE UPDATE ON study_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
