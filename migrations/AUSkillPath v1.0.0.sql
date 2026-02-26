--
-- PostgreSQL database dump
--

\restrict bh95MpVKOh0PO5hgUZairhPhcRcdBsUX0nYH9dYIqCZxxX7Fv66iKbVaFuVMsVJ

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-02-26 12:13:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 17751)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 231 (class 1259 OID 17888)
-- Name: analysis_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analysis_results (
    result_id bigint NOT NULL,
    user_id bigint NOT NULL,
    resume_id bigint NOT NULL,
    role_id bigint NOT NULL,
    coverage_percentage double precision,
    is_qualified boolean NOT NULL,
    missing_must_have jsonb,
    missing_nice_to_have jsonb,
    detected_skills jsonb,
    analysed_at timestamp with time zone DEFAULT now(),
    CONSTRAINT analysis_results_coverage_percentage_check CHECK (((coverage_percentage >= (0)::double precision) AND (coverage_percentage <= (100)::double precision)))
);


ALTER TABLE public.analysis_results OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17887)
-- Name: analysis_results_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analysis_results_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.analysis_results_result_id_seq OWNER TO postgres;

--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 230
-- Name: analysis_results_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analysis_results_result_id_seq OWNED BY public.analysis_results.result_id;


--
-- TOC entry 223 (class 1259 OID 17812)
-- Name: job_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_roles (
    role_id bigint NOT NULL,
    role_name character varying(100) NOT NULL,
    role_description text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.job_roles OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17811)
-- Name: job_roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_roles_role_id_seq OWNER TO postgres;

--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 222
-- Name: job_roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_roles_role_id_seq OWNED BY public.job_roles.role_id;


--
-- TOC entry 241 (class 1259 OID 18038)
-- Name: job_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_skills (
    job_skill_id bigint NOT NULL,
    job_id bigint NOT NULL,
    skill_id bigint NOT NULL
);


ALTER TABLE public.job_skills OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 18037)
-- Name: job_skills_job_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_skills_job_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_skills_job_skill_id_seq OWNER TO postgres;

--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 240
-- Name: job_skills_job_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_skills_job_skill_id_seq OWNED BY public.job_skills.job_skill_id;


--
-- TOC entry 239 (class 1259 OID 18016)
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    job_id bigint NOT NULL,
    external_id character varying(100),
    title character varying(255) NOT NULL,
    company character varying(255),
    location character varying(150),
    description text,
    requirements text,
    salary_min integer,
    salary_max integer,
    employment_type character varying(50),
    experience_level character varying(20),
    posted_date date,
    source character varying(50) DEFAULT 'adzuna'::character varying,
    url text,
    is_active boolean DEFAULT true,
    view_count integer DEFAULT 0,
    scraped_at timestamp with time zone DEFAULT now(),
    last_checked timestamp with time zone DEFAULT now()
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 18015)
-- Name: jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_job_id_seq OWNER TO postgres;

--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 238
-- Name: jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_job_id_seq OWNED BY public.jobs.job_id;


--
-- TOC entry 233 (class 1259 OID 17924)
-- Name: learning_modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learning_modules (
    module_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    module_title character varying(255) NOT NULL,
    resource_url text NOT NULL,
    format character varying(50),
    estimated_hours double precision,
    difficulty_level character varying(20),
    provider character varying(100),
    is_free boolean DEFAULT true,
    course_platform character varying(50),
    rating numeric(3,2),
    review_count integer DEFAULT 0,
    certificate_available boolean DEFAULT false,
    language character varying(20) DEFAULT 'en'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT learning_modules_difficulty_level_check CHECK (((difficulty_level)::text = ANY ((ARRAY['beginner'::character varying, 'intermediate'::character varying, 'advanced'::character varying])::text[]))),
    CONSTRAINT learning_modules_estimated_hours_check CHECK ((estimated_hours > (0)::double precision)),
    CONSTRAINT learning_modules_format_check CHECK (((format)::text = ANY ((ARRAY['video'::character varying, 'course'::character varying, 'article'::character varying, 'hands-on'::character varying])::text[]))),
    CONSTRAINT learning_modules_rating_check CHECK (((rating >= (0)::numeric) AND (rating <= (5)::numeric)))
);


ALTER TABLE public.learning_modules OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17923)
-- Name: learning_modules_module_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.learning_modules_module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.learning_modules_module_id_seq OWNER TO postgres;

--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 232
-- Name: learning_modules_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.learning_modules_module_id_seq OWNED BY public.learning_modules.module_id;


--
-- TOC entry 225 (class 1259 OID 17826)
-- Name: resumes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resumes (
    resume_id bigint NOT NULL,
    user_id bigint NOT NULL,
    file_name character varying(255) NOT NULL,
    file_type character varying(10),
    extracted_text text,
    uploaded_at timestamp with time zone DEFAULT now(),
    CONSTRAINT resumes_file_type_check CHECK (((file_type)::text = ANY ((ARRAY['pdf'::character varying, 'docx'::character varying])::text[])))
);


ALTER TABLE public.resumes OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17825)
-- Name: resumes_resume_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resumes_resume_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resumes_resume_id_seq OWNER TO postgres;

--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 224
-- Name: resumes_resume_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resumes_resume_id_seq OWNED BY public.resumes.resume_id;


--
-- TOC entry 229 (class 1259 OID 17860)
-- Name: role_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_skills (
    role_skill_id bigint NOT NULL,
    role_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    importance character varying(20) NOT NULL,
    frequency_score double precision,
    CONSTRAINT role_skills_frequency_score_check CHECK (((frequency_score >= (0.0)::double precision) AND (frequency_score <= (1.0)::double precision))),
    CONSTRAINT role_skills_importance_check CHECK (((importance)::text = ANY ((ARRAY['must_have'::character varying, 'nice_to_have'::character varying])::text[])))
);


ALTER TABLE public.role_skills OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17859)
-- Name: role_skills_role_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_skills_role_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_skills_role_skill_id_seq OWNER TO postgres;

--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 228
-- Name: role_skills_role_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_skills_role_skill_id_seq OWNED BY public.role_skills.role_skill_id;


--
-- TOC entry 227 (class 1259 OID 17847)
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    skill_id bigint NOT NULL,
    skill_name character varying(100) NOT NULL,
    skill_category character varying(50),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17846)
-- Name: skills_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skills_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skills_skill_id_seq OWNER TO postgres;

--
-- TOC entry 5345 (class 0 OID 0)
-- Dependencies: 226
-- Name: skills_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skills_skill_id_seq OWNED BY public.skills.skill_id;


--
-- TOC entry 237 (class 1259 OID 17984)
-- Name: study_plan_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plan_progress (
    progress_id bigint NOT NULL,
    plan_id bigint NOT NULL,
    user_id bigint NOT NULL,
    week_number integer NOT NULL,
    task_description text NOT NULL,
    is_completed boolean DEFAULT false,
    completed_at timestamp with time zone,
    CONSTRAINT study_plan_progress_week_number_check CHECK ((week_number > 0))
);


ALTER TABLE public.study_plan_progress OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17983)
-- Name: study_plan_progress_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_plan_progress_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_plan_progress_progress_id_seq OWNER TO postgres;

--
-- TOC entry 5346 (class 0 OID 0)
-- Dependencies: 236
-- Name: study_plan_progress_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_plan_progress_progress_id_seq OWNED BY public.study_plan_progress.progress_id;


--
-- TOC entry 235 (class 1259 OID 17956)
-- Name: study_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plans (
    plan_id bigint NOT NULL,
    user_id bigint NOT NULL,
    result_id bigint NOT NULL,
    duration_weeks integer NOT NULL,
    plan_content jsonb NOT NULL,
    generated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT study_plans_duration_weeks_check CHECK (((duration_weeks >= 1) AND (duration_weeks <= 52)))
);


ALTER TABLE public.study_plans OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17955)
-- Name: study_plans_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_plans_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_plans_plan_id_seq OWNER TO postgres;

--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 234
-- Name: study_plans_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_plans_plan_id_seq OWNED BY public.study_plans.plan_id;


--
-- TOC entry 249 (class 1259 OID 18150)
-- Name: user_activity_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_activity_log (
    activity_id bigint NOT NULL,
    user_id bigint NOT NULL,
    activity_type character varying(50) NOT NULL,
    activity_description text,
    activity_data jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_activity_log OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 18149)
-- Name: user_activity_log_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_activity_log_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_activity_log_activity_id_seq OWNER TO postgres;

--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 248
-- Name: user_activity_log_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_activity_log_activity_id_seq OWNED BY public.user_activity_log.activity_id;


--
-- TOC entry 247 (class 1259 OID 18116)
-- Name: user_course_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_course_progress (
    progress_id bigint NOT NULL,
    user_id bigint NOT NULL,
    module_id bigint NOT NULL,
    status character varying(20) DEFAULT 'not_started'::character varying,
    progress_percentage integer DEFAULT 0,
    time_spent_minutes integer DEFAULT 0,
    last_accessed timestamp with time zone,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    certificate_earned boolean DEFAULT false,
    certificate_url text,
    CONSTRAINT user_course_progress_progress_percentage_check CHECK (((progress_percentage >= 0) AND (progress_percentage <= 100))),
    CONSTRAINT user_course_progress_status_check CHECK (((status)::text = ANY ((ARRAY['not_started'::character varying, 'in_progress'::character varying, 'completed'::character varying])::text[])))
);


ALTER TABLE public.user_course_progress OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 18115)
-- Name: user_course_progress_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_course_progress_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_course_progress_progress_id_seq OWNER TO postgres;

--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 246
-- Name: user_course_progress_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_course_progress_progress_id_seq OWNED BY public.user_course_progress.progress_id;


--
-- TOC entry 245 (class 1259 OID 18091)
-- Name: user_job_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_job_alerts (
    alert_id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint,
    location character varying(150),
    alert_frequency character varying(20) DEFAULT 'daily'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_job_alerts_alert_frequency_check CHECK (((alert_frequency)::text = ANY ((ARRAY['instant'::character varying, 'daily'::character varying, 'weekly'::character varying])::text[])))
);


ALTER TABLE public.user_job_alerts OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 18090)
-- Name: user_job_alerts_alert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_job_alerts_alert_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_job_alerts_alert_id_seq OWNER TO postgres;

--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 244
-- Name: user_job_alerts_alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_job_alerts_alert_id_seq OWNED BY public.user_job_alerts.alert_id;


--
-- TOC entry 243 (class 1259 OID 18062)
-- Name: user_job_bookmarks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_job_bookmarks (
    bookmark_id bigint NOT NULL,
    user_id bigint NOT NULL,
    job_id bigint NOT NULL,
    notes text,
    status character varying(50) DEFAULT 'saved'::character varying,
    bookmarked_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_job_bookmarks_status_check CHECK (((status)::text = ANY ((ARRAY['saved'::character varying, 'applied'::character varying, 'interview'::character varying, 'offered'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.user_job_bookmarks OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 18061)
-- Name: user_job_bookmarks_bookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_job_bookmarks_bookmark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_job_bookmarks_bookmark_id_seq OWNER TO postgres;

--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 242
-- Name: user_job_bookmarks_bookmark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_job_bookmarks_bookmark_id_seq OWNED BY public.user_job_bookmarks.bookmark_id;


--
-- TOC entry 251 (class 1259 OID 18171)
-- Name: user_statistics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_statistics (
    stat_id bigint NOT NULL,
    user_id bigint NOT NULL,
    total_study_hours integer DEFAULT 0,
    courses_started integer DEFAULT 0,
    courses_completed integer DEFAULT 0,
    skills_learned integer DEFAULT 0,
    current_streak_days integer DEFAULT 0,
    longest_streak_days integer DEFAULT 0,
    jobs_bookmarked integer DEFAULT 0,
    last_activity_date date,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_statistics OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 18170)
-- Name: user_statistics_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_statistics_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_statistics_stat_id_seq OWNER TO postgres;

--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 250
-- Name: user_statistics_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_statistics_stat_id_seq OWNED BY public.user_statistics.stat_id;


--
-- TOC entry 221 (class 1259 OID 17790)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    experience_level character varying(20),
    study_hours_per_week integer,
    email_verified boolean DEFAULT false,
    last_login timestamp with time zone,
    is_active boolean DEFAULT true,
    profile_picture_url text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT users_experience_level_check CHECK (((experience_level)::text = ANY ((ARRAY['junior'::character varying, 'mid'::character varying, 'senior'::character varying])::text[]))),
    CONSTRAINT users_study_hours_per_week_check CHECK (((study_hours_per_week > 0) AND (study_hours_per_week <= 168)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17789)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 220
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4980 (class 2604 OID 17891)
-- Name: analysis_results result_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analysis_results ALTER COLUMN result_id SET DEFAULT nextval('public.analysis_results_result_id_seq'::regclass);


--
-- TOC entry 4973 (class 2604 OID 17815)
-- Name: job_roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_roles ALTER COLUMN role_id SET DEFAULT nextval('public.job_roles_role_id_seq'::regclass);


--
-- TOC entry 4998 (class 2604 OID 18041)
-- Name: job_skills job_skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_skills ALTER COLUMN job_skill_id SET DEFAULT nextval('public.job_skills_job_skill_id_seq'::regclass);


--
-- TOC entry 4992 (class 2604 OID 18019)
-- Name: jobs job_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN job_id SET DEFAULT nextval('public.jobs_job_id_seq'::regclass);


--
-- TOC entry 4982 (class 2604 OID 17927)
-- Name: learning_modules module_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_modules ALTER COLUMN module_id SET DEFAULT nextval('public.learning_modules_module_id_seq'::regclass);


--
-- TOC entry 4975 (class 2604 OID 17829)
-- Name: resumes resume_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes ALTER COLUMN resume_id SET DEFAULT nextval('public.resumes_resume_id_seq'::regclass);


--
-- TOC entry 4979 (class 2604 OID 17863)
-- Name: role_skills role_skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_skills ALTER COLUMN role_skill_id SET DEFAULT nextval('public.role_skills_role_skill_id_seq'::regclass);


--
-- TOC entry 4977 (class 2604 OID 17850)
-- Name: skills skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills ALTER COLUMN skill_id SET DEFAULT nextval('public.skills_skill_id_seq'::regclass);


--
-- TOC entry 4990 (class 2604 OID 17987)
-- Name: study_plan_progress progress_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_progress ALTER COLUMN progress_id SET DEFAULT nextval('public.study_plan_progress_progress_id_seq'::regclass);


--
-- TOC entry 4988 (class 2604 OID 17959)
-- Name: study_plans plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans ALTER COLUMN plan_id SET DEFAULT nextval('public.study_plans_plan_id_seq'::regclass);


--
-- TOC entry 5011 (class 2604 OID 18153)
-- Name: user_activity_log activity_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity_log ALTER COLUMN activity_id SET DEFAULT nextval('public.user_activity_log_activity_id_seq'::regclass);


--
-- TOC entry 5006 (class 2604 OID 18119)
-- Name: user_course_progress progress_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_course_progress ALTER COLUMN progress_id SET DEFAULT nextval('public.user_course_progress_progress_id_seq'::regclass);


--
-- TOC entry 5002 (class 2604 OID 18094)
-- Name: user_job_alerts alert_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_alerts ALTER COLUMN alert_id SET DEFAULT nextval('public.user_job_alerts_alert_id_seq'::regclass);


--
-- TOC entry 4999 (class 2604 OID 18065)
-- Name: user_job_bookmarks bookmark_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_bookmarks ALTER COLUMN bookmark_id SET DEFAULT nextval('public.user_job_bookmarks_bookmark_id_seq'::regclass);


--
-- TOC entry 5013 (class 2604 OID 18174)
-- Name: user_statistics stat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_statistics ALTER COLUMN stat_id SET DEFAULT nextval('public.user_statistics_stat_id_seq'::regclass);


--
-- TOC entry 4969 (class 2604 OID 17793)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5311 (class 0 OID 17888)
-- Dependencies: 231
-- Data for Name: analysis_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analysis_results (result_id, user_id, resume_id, role_id, coverage_percentage, is_qualified, missing_must_have, missing_nice_to_have, detected_skills, analysed_at) FROM stdin;
\.


--
-- TOC entry 5303 (class 0 OID 17812)
-- Dependencies: 223
-- Data for Name: job_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_roles (role_id, role_name, role_description, created_at) FROM stdin;
1	Data Analyst	Analyse business data and generate insights using SQL, Python, and BI tools	2026-02-26 11:30:10.173225+11
2	BI Analyst	Build dashboards and reports to support business decision-making	2026-02-26 11:30:10.173225+11
3	Data Engineer	Build and maintain data pipelines, warehouses, and infrastructure	2026-02-26 11:30:10.173225+11
4	Data Scientist	Apply machine learning and statistical models to solve business problems	2026-02-26 11:30:10.173225+11
5	Cyber Security Engineer	Protect systems and networks from cyber threats and vulnerabilities	2026-02-26 11:30:10.173225+11
6	Full Stack Developer	Build web applications end-to-end, both frontend and backend	2026-02-26 11:30:10.173225+11
7	Frontend Developer	Build user interfaces and web experiences using modern frameworks	2026-02-26 11:30:10.173225+11
8	Backend Developer	Build server-side logic, APIs, and database integrations	2026-02-26 11:30:10.173225+11
9	DevOps Engineer	Manage CI/CD pipelines, cloud infrastructure, and deployments	2026-02-26 11:30:10.173225+11
10	Cloud Architect	Design and oversee cloud infrastructure strategies and solutions	2026-02-26 11:30:10.173225+11
\.


--
-- TOC entry 5321 (class 0 OID 18038)
-- Dependencies: 241
-- Data for Name: job_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_skills (job_skill_id, job_id, skill_id) FROM stdin;
\.


--
-- TOC entry 5319 (class 0 OID 18016)
-- Dependencies: 239
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (job_id, external_id, title, company, location, description, requirements, salary_min, salary_max, employment_type, experience_level, posted_date, source, url, is_active, view_count, scraped_at, last_checked) FROM stdin;
\.


--
-- TOC entry 5313 (class 0 OID 17924)
-- Dependencies: 233
-- Data for Name: learning_modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learning_modules (module_id, skill_id, module_title, resource_url, format, estimated_hours, difficulty_level, provider, is_free, course_platform, rating, review_count, certificate_available, language, created_at) FROM stdin;
1	2	SQL Tutorial - Full Course for Beginners	https://www.youtube.com/watch?v=HXV3zeQKqGY	video	4	beginner	freeCodeCamp	t	youtube	4.80	0	f	en	2026-02-26 11:30:10.173225+11
2	2	The Complete SQL Bootcamp	https://www.udemy.com/course/the-complete-sql-bootcamp/	course	9	beginner	Udemy	f	udemy	4.70	0	t	en	2026-02-26 11:30:10.173225+11
3	2	SQL Window Functions Tutorial	https://mode.com/sql-tutorial/sql-window-functions/	article	2	intermediate	Mode Analytics	t	other	4.60	0	f	en	2026-02-26 11:30:10.173225+11
4	1	Python for Everybody Specialization	https://www.coursera.org/specializations/python	course	8	beginner	Coursera	f	coursera	4.80	0	t	en	2026-02-26 11:30:10.173225+11
5	1	Python Tutorial for Beginners - Full Course	https://www.youtube.com/watch?v=_uQrJ0TkZlc	video	6	beginner	Programming with Mosh	t	youtube	4.90	0	f	en	2026-02-26 11:30:10.173225+11
6	3	Microsoft Power BI Full Course	https://www.youtube.com/watch?v=AGrl-H87pRU	video	3.5	beginner	Simplilearn	t	youtube	4.70	0	f	en	2026-02-26 11:30:10.173225+11
7	3	Power BI from Beginner to Pro	https://www.udemy.com/course/microsoft-power-bi-up-running-with-power-bi-desktop/	course	10	beginner	Udemy	f	udemy	4.60	0	t	en	2026-02-26 11:30:10.173225+11
8	25	DAX Basics - Microsoft Official Docs	https://docs.microsoft.com/en-us/power-bi/transform-model/desktop-quickstart-learn-dax-basics	article	2	intermediate	Microsoft	t	other	4.50	0	f	en	2026-02-26 11:30:10.173225+11
9	4	Tableau for Beginners - Free Training	https://www.tableau.com/learn/training	course	5	beginner	Tableau	t	other	4.70	0	t	en	2026-02-26 11:30:10.173225+11
10	10	Pandas Tutorial for Beginners	https://www.youtube.com/watch?v=vmEHCJofslg	video	2.5	beginner	Corey Schafer	t	youtube	4.90	0	f	en	2026-02-26 11:30:10.173225+11
11	9	Machine Learning Specialization - Andrew Ng	https://www.coursera.org/specializations/machine-learning-introduction	course	40	intermediate	Coursera	f	coursera	4.90	0	t	en	2026-02-26 11:30:10.173225+11
12	21	Docker Tutorial for Beginners	https://www.youtube.com/watch?v=3c-iBn73dDE	video	3	beginner	TechWorld with Nana	t	youtube	4.80	0	f	en	2026-02-26 11:30:10.173225+11
13	23	Git and GitHub for Beginners - Crash Course	https://www.youtube.com/watch?v=RGOj5yH7evk	video	1	beginner	freeCodeCamp	t	youtube	4.80	0	f	en	2026-02-26 11:30:10.173225+11
14	26	ETL Concepts Explained	https://www.youtube.com/watch?v=OW6KFP0Rfe8	video	1.5	beginner	Alex The Analyst	t	youtube	4.60	0	f	en	2026-02-26 11:30:10.173225+11
15	13	JavaScript Full Course for Beginners	https://www.youtube.com/watch?v=PkZNo7MFNFg	video	7	beginner	freeCodeCamp	t	youtube	4.80	0	f	en	2026-02-26 11:30:10.173225+11
\.


--
-- TOC entry 5305 (class 0 OID 17826)
-- Dependencies: 225
-- Data for Name: resumes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resumes (resume_id, user_id, file_name, file_type, extracted_text, uploaded_at) FROM stdin;
\.


--
-- TOC entry 5309 (class 0 OID 17860)
-- Dependencies: 229
-- Data for Name: role_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_skills (role_skill_id, role_id, skill_id, importance, frequency_score) FROM stdin;
1	1	2	must_have	0.95
2	1	1	must_have	0.85
3	1	5	must_have	0.8
4	1	3	must_have	0.72
5	1	28	must_have	0.7
6	1	4	nice_to_have	0.55
7	1	29	nice_to_have	0.5
8	1	30	nice_to_have	0.6
9	2	3	must_have	0.93
10	2	25	must_have	0.87
11	2	2	must_have	0.88
12	2	5	must_have	0.78
13	2	28	must_have	0.65
14	2	4	nice_to_have	0.45
15	2	6	nice_to_have	0.4
16	2	1	nice_to_have	0.5
17	3	1	must_have	0.93
18	3	2	must_have	0.9
19	3	26	must_have	0.88
20	3	27	must_have	0.72
21	3	19	must_have	0.68
22	3	7	nice_to_have	0.65
23	3	21	nice_to_have	0.6
24	3	23	nice_to_have	0.7
25	4	1	must_have	0.97
26	4	9	must_have	0.92
27	4	2	must_have	0.85
28	4	29	must_have	0.88
29	4	10	must_have	0.8
30	4	11	nice_to_have	0.7
31	4	12	nice_to_have	0.45
32	4	7	nice_to_have	0.5
33	5	1	must_have	0.8
34	5	2	must_have	0.65
35	5	7	nice_to_have	0.55
36	5	30	nice_to_have	0.7
37	6	13	must_have	0.95
38	6	15	must_have	0.88
39	6	17	must_have	0.82
40	6	2	must_have	0.78
41	6	16	must_have	0.9
42	6	23	must_have	0.85
43	6	14	nice_to_have	0.65
44	6	21	nice_to_have	0.5
45	7	13	must_have	0.97
46	7	15	must_have	0.9
47	7	16	must_have	0.95
48	7	14	nice_to_have	0.7
49	7	23	nice_to_have	0.8
50	8	1	must_have	0.85
51	8	2	must_have	0.88
52	8	18	must_have	0.7
53	8	19	must_have	0.72
54	8	23	must_have	0.85
55	8	21	nice_to_have	0.6
56	8	17	nice_to_have	0.55
57	9	21	must_have	0.93
58	9	22	must_have	0.85
59	9	7	must_have	0.88
60	9	23	must_have	0.9
61	9	1	must_have	0.75
62	9	24	nice_to_have	0.65
63	9	6	nice_to_have	0.55
64	10	7	must_have	0.9
65	10	6	must_have	0.82
66	10	24	must_have	0.78
67	10	21	must_have	0.75
68	10	22	must_have	0.72
69	10	1	nice_to_have	0.6
70	10	30	nice_to_have	0.65
\.


--
-- TOC entry 5307 (class 0 OID 17847)
-- Dependencies: 227
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skills (skill_id, skill_name, skill_category, created_at) FROM stdin;
1	Python	programming	2026-02-26 11:30:10.173225+11
2	SQL	database	2026-02-26 11:30:10.173225+11
3	Power BI	visualisation	2026-02-26 11:30:10.173225+11
4	Tableau	visualisation	2026-02-26 11:30:10.173225+11
5	Excel	productivity	2026-02-26 11:30:10.173225+11
6	Azure	cloud	2026-02-26 11:30:10.173225+11
7	AWS	cloud	2026-02-26 11:30:10.173225+11
8	Google Cloud	cloud	2026-02-26 11:30:10.173225+11
9	Machine Learning	ai_ml	2026-02-26 11:30:10.173225+11
10	Pandas	programming	2026-02-26 11:30:10.173225+11
11	NumPy	programming	2026-02-26 11:30:10.173225+11
12	R	programming	2026-02-26 11:30:10.173225+11
13	JavaScript	programming	2026-02-26 11:30:10.173225+11
14	TypeScript	programming	2026-02-26 11:30:10.173225+11
15	React	frontend	2026-02-26 11:30:10.173225+11
16	HTML/CSS	frontend	2026-02-26 11:30:10.173225+11
17	Node.js	backend	2026-02-26 11:30:10.173225+11
18	FastAPI	backend	2026-02-26 11:30:10.173225+11
19	PostgreSQL	database	2026-02-26 11:30:10.173225+11
20	MongoDB	database	2026-02-26 11:30:10.173225+11
21	Docker	devops	2026-02-26 11:30:10.173225+11
22	Kubernetes	devops	2026-02-26 11:30:10.173225+11
23	Git	devops	2026-02-26 11:30:10.173225+11
24	Terraform	devops	2026-02-26 11:30:10.173225+11
25	DAX	visualisation	2026-02-26 11:30:10.173225+11
26	ETL	data_engineering	2026-02-26 11:30:10.173225+11
27	Apache Spark	data_engineering	2026-02-26 11:30:10.173225+11
28	Data Cleaning	analytics	2026-02-26 11:30:10.173225+11
29	Statistics	analytics	2026-02-26 11:30:10.173225+11
30	Communication	soft_skill	2026-02-26 11:30:10.173225+11
\.


--
-- TOC entry 5317 (class 0 OID 17984)
-- Dependencies: 237
-- Data for Name: study_plan_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_plan_progress (progress_id, plan_id, user_id, week_number, task_description, is_completed, completed_at) FROM stdin;
\.


--
-- TOC entry 5315 (class 0 OID 17956)
-- Dependencies: 235
-- Data for Name: study_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_plans (plan_id, user_id, result_id, duration_weeks, plan_content, generated_at) FROM stdin;
\.


--
-- TOC entry 5329 (class 0 OID 18150)
-- Dependencies: 249
-- Data for Name: user_activity_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_activity_log (activity_id, user_id, activity_type, activity_description, activity_data, created_at) FROM stdin;
\.


--
-- TOC entry 5327 (class 0 OID 18116)
-- Dependencies: 247
-- Data for Name: user_course_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_course_progress (progress_id, user_id, module_id, status, progress_percentage, time_spent_minutes, last_accessed, started_at, completed_at, certificate_earned, certificate_url) FROM stdin;
\.


--
-- TOC entry 5325 (class 0 OID 18091)
-- Dependencies: 245
-- Data for Name: user_job_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_job_alerts (alert_id, user_id, role_id, location, alert_frequency, is_active, created_at) FROM stdin;
\.


--
-- TOC entry 5323 (class 0 OID 18062)
-- Dependencies: 243
-- Data for Name: user_job_bookmarks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_job_bookmarks (bookmark_id, user_id, job_id, notes, status, bookmarked_at) FROM stdin;
\.


--
-- TOC entry 5331 (class 0 OID 18171)
-- Dependencies: 251
-- Data for Name: user_statistics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_statistics (stat_id, user_id, total_study_hours, courses_started, courses_completed, skills_learned, current_streak_days, longest_streak_days, jobs_bookmarked, last_activity_date, updated_at) FROM stdin;
\.


--
-- TOC entry 5301 (class 0 OID 17790)
-- Dependencies: 221
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, email, password_hash, experience_level, study_hours_per_week, email_verified, last_login, is_active, profile_picture_url, created_at) FROM stdin;
\.


--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 230
-- Name: analysis_results_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analysis_results_result_id_seq', 1, false);


--
-- TOC entry 5355 (class 0 OID 0)
-- Dependencies: 222
-- Name: job_roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_roles_role_id_seq', 10, true);


--
-- TOC entry 5356 (class 0 OID 0)
-- Dependencies: 240
-- Name: job_skills_job_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_skills_job_skill_id_seq', 1, false);


--
-- TOC entry 5357 (class 0 OID 0)
-- Dependencies: 238
-- Name: jobs_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_job_id_seq', 1, false);


--
-- TOC entry 5358 (class 0 OID 0)
-- Dependencies: 232
-- Name: learning_modules_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.learning_modules_module_id_seq', 15, true);


--
-- TOC entry 5359 (class 0 OID 0)
-- Dependencies: 224
-- Name: resumes_resume_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resumes_resume_id_seq', 1, false);


--
-- TOC entry 5360 (class 0 OID 0)
-- Dependencies: 228
-- Name: role_skills_role_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_skills_role_skill_id_seq', 70, true);


--
-- TOC entry 5361 (class 0 OID 0)
-- Dependencies: 226
-- Name: skills_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skills_skill_id_seq', 30, true);


--
-- TOC entry 5362 (class 0 OID 0)
-- Dependencies: 236
-- Name: study_plan_progress_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_plan_progress_progress_id_seq', 1, false);


--
-- TOC entry 5363 (class 0 OID 0)
-- Dependencies: 234
-- Name: study_plans_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_plans_plan_id_seq', 1, false);


--
-- TOC entry 5364 (class 0 OID 0)
-- Dependencies: 248
-- Name: user_activity_log_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_activity_log_activity_id_seq', 1, false);


--
-- TOC entry 5365 (class 0 OID 0)
-- Dependencies: 246
-- Name: user_course_progress_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_course_progress_progress_id_seq', 1, false);


--
-- TOC entry 5366 (class 0 OID 0)
-- Dependencies: 244
-- Name: user_job_alerts_alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_job_alerts_alert_id_seq', 1, false);


--
-- TOC entry 5367 (class 0 OID 0)
-- Dependencies: 242
-- Name: user_job_bookmarks_bookmark_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_job_bookmarks_bookmark_id_seq', 1, false);


--
-- TOC entry 5368 (class 0 OID 0)
-- Dependencies: 250
-- Name: user_statistics_stat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_statistics_stat_id_seq', 1, false);


--
-- TOC entry 5369 (class 0 OID 0)
-- Dependencies: 220
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- TOC entry 5065 (class 2606 OID 17902)
-- Name: analysis_results analysis_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analysis_results
    ADD CONSTRAINT analysis_results_pkey PRIMARY KEY (result_id);


--
-- TOC entry 5045 (class 2606 OID 17822)
-- Name: job_roles job_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_roles
    ADD CONSTRAINT job_roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 5047 (class 2606 OID 17824)
-- Name: job_roles job_roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_roles
    ADD CONSTRAINT job_roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 5101 (class 2606 OID 18048)
-- Name: job_skills job_skills_job_id_skill_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_skills
    ADD CONSTRAINT job_skills_job_id_skill_id_key UNIQUE (job_id, skill_id);


--
-- TOC entry 5103 (class 2606 OID 18046)
-- Name: job_skills job_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_skills
    ADD CONSTRAINT job_skills_pkey PRIMARY KEY (job_skill_id);


--
-- TOC entry 5095 (class 2606 OID 18032)
-- Name: jobs jobs_external_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_external_id_key UNIQUE (external_id);


--
-- TOC entry 5097 (class 2606 OID 18030)
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (job_id);


--
-- TOC entry 5077 (class 2606 OID 17944)
-- Name: learning_modules learning_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_modules
    ADD CONSTRAINT learning_modules_pkey PRIMARY KEY (module_id);


--
-- TOC entry 5051 (class 2606 OID 17838)
-- Name: resumes resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (resume_id);


--
-- TOC entry 5061 (class 2606 OID 17871)
-- Name: role_skills role_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_skills
    ADD CONSTRAINT role_skills_pkey PRIMARY KEY (role_skill_id);


--
-- TOC entry 5063 (class 2606 OID 17873)
-- Name: role_skills role_skills_role_id_skill_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_skills
    ADD CONSTRAINT role_skills_role_id_skill_id_key UNIQUE (role_id, skill_id);


--
-- TOC entry 5054 (class 2606 OID 17855)
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (skill_id);


--
-- TOC entry 5056 (class 2606 OID 17857)
-- Name: skills skills_skill_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_skill_name_key UNIQUE (skill_name);


--
-- TOC entry 5087 (class 2606 OID 17998)
-- Name: study_plan_progress study_plan_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_progress
    ADD CONSTRAINT study_plan_progress_pkey PRIMARY KEY (progress_id);


--
-- TOC entry 5089 (class 2606 OID 18000)
-- Name: study_plan_progress study_plan_progress_plan_id_week_number_task_description_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_progress
    ADD CONSTRAINT study_plan_progress_plan_id_week_number_task_description_key UNIQUE (plan_id, week_number, task_description);


--
-- TOC entry 5081 (class 2606 OID 17970)
-- Name: study_plans study_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_pkey PRIMARY KEY (plan_id);


--
-- TOC entry 5126 (class 2606 OID 18161)
-- Name: user_activity_log user_activity_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity_log
    ADD CONSTRAINT user_activity_log_pkey PRIMARY KEY (activity_id);


--
-- TOC entry 5119 (class 2606 OID 18132)
-- Name: user_course_progress user_course_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_course_progress
    ADD CONSTRAINT user_course_progress_pkey PRIMARY KEY (progress_id);


--
-- TOC entry 5121 (class 2606 OID 18134)
-- Name: user_course_progress user_course_progress_user_id_module_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_course_progress
    ADD CONSTRAINT user_course_progress_user_id_module_id_key UNIQUE (user_id, module_id);


--
-- TOC entry 5113 (class 2606 OID 18102)
-- Name: user_job_alerts user_job_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_alerts
    ADD CONSTRAINT user_job_alerts_pkey PRIMARY KEY (alert_id);


--
-- TOC entry 5107 (class 2606 OID 18075)
-- Name: user_job_bookmarks user_job_bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_bookmarks
    ADD CONSTRAINT user_job_bookmarks_pkey PRIMARY KEY (bookmark_id);


--
-- TOC entry 5109 (class 2606 OID 18077)
-- Name: user_job_bookmarks user_job_bookmarks_user_id_job_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_bookmarks
    ADD CONSTRAINT user_job_bookmarks_user_id_job_id_key UNIQUE (user_id, job_id);


--
-- TOC entry 5129 (class 2606 OID 18186)
-- Name: user_statistics user_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_statistics
    ADD CONSTRAINT user_statistics_pkey PRIMARY KEY (stat_id);


--
-- TOC entry 5131 (class 2606 OID 18188)
-- Name: user_statistics user_statistics_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_statistics
    ADD CONSTRAINT user_statistics_user_id_key UNIQUE (user_id);


--
-- TOC entry 5041 (class 2606 OID 17808)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5043 (class 2606 OID 17806)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5122 (class 1259 OID 18169)
-- Name: idx_activity_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_date ON public.user_activity_log USING btree (created_at);


--
-- TOC entry 5123 (class 1259 OID 18168)
-- Name: idx_activity_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_type ON public.user_activity_log USING btree (activity_type);


--
-- TOC entry 5124 (class 1259 OID 18167)
-- Name: idx_activity_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_user ON public.user_activity_log USING btree (user_id);


--
-- TOC entry 5110 (class 1259 OID 18114)
-- Name: idx_alerts_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alerts_active ON public.user_job_alerts USING btree (is_active);


--
-- TOC entry 5111 (class 1259 OID 18113)
-- Name: idx_alerts_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alerts_user ON public.user_job_alerts USING btree (user_id);


--
-- TOC entry 5066 (class 1259 OID 17922)
-- Name: idx_analysis_coverage; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analysis_coverage ON public.analysis_results USING btree (coverage_percentage);


--
-- TOC entry 5067 (class 1259 OID 17921)
-- Name: idx_analysis_qualified; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analysis_qualified ON public.analysis_results USING btree (is_qualified);


--
-- TOC entry 5068 (class 1259 OID 17919)
-- Name: idx_analysis_resume; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analysis_resume ON public.analysis_results USING btree (resume_id);


--
-- TOC entry 5069 (class 1259 OID 17920)
-- Name: idx_analysis_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analysis_role ON public.analysis_results USING btree (role_id);


--
-- TOC entry 5070 (class 1259 OID 17918)
-- Name: idx_analysis_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analysis_user ON public.analysis_results USING btree (user_id);


--
-- TOC entry 5104 (class 1259 OID 18089)
-- Name: idx_bookmarks_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookmarks_status ON public.user_job_bookmarks USING btree (status);


--
-- TOC entry 5105 (class 1259 OID 18088)
-- Name: idx_bookmarks_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookmarks_user ON public.user_job_bookmarks USING btree (user_id);


--
-- TOC entry 5114 (class 1259 OID 18148)
-- Name: idx_course_progress_completed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_progress_completed ON public.user_course_progress USING btree (completed_at);


--
-- TOC entry 5115 (class 1259 OID 18146)
-- Name: idx_course_progress_module; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_progress_module ON public.user_course_progress USING btree (module_id);


--
-- TOC entry 5116 (class 1259 OID 18147)
-- Name: idx_course_progress_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_progress_status ON public.user_course_progress USING btree (status);


--
-- TOC entry 5117 (class 1259 OID 18145)
-- Name: idx_course_progress_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_course_progress_user ON public.user_course_progress USING btree (user_id);


--
-- TOC entry 5098 (class 1259 OID 18059)
-- Name: idx_job_skills_job; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_skills_job ON public.job_skills USING btree (job_id);


--
-- TOC entry 5099 (class 1259 OID 18060)
-- Name: idx_job_skills_skill; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_skills_skill ON public.job_skills USING btree (skill_id);


--
-- TOC entry 5090 (class 1259 OID 18034)
-- Name: idx_jobs_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_jobs_active ON public.jobs USING btree (is_active);


--
-- TOC entry 5091 (class 1259 OID 18035)
-- Name: idx_jobs_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_jobs_location ON public.jobs USING btree (location);


--
-- TOC entry 5092 (class 1259 OID 18033)
-- Name: idx_jobs_posted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_jobs_posted ON public.jobs USING btree (posted_date);


--
-- TOC entry 5093 (class 1259 OID 18036)
-- Name: idx_jobs_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_jobs_title ON public.jobs USING btree (title);


--
-- TOC entry 5071 (class 1259 OID 17951)
-- Name: idx_learning_difficulty; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_learning_difficulty ON public.learning_modules USING btree (difficulty_level);


--
-- TOC entry 5072 (class 1259 OID 17952)
-- Name: idx_learning_free; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_learning_free ON public.learning_modules USING btree (is_free);


--
-- TOC entry 5073 (class 1259 OID 17953)
-- Name: idx_learning_platform; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_learning_platform ON public.learning_modules USING btree (course_platform);


--
-- TOC entry 5074 (class 1259 OID 17954)
-- Name: idx_learning_rating; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_learning_rating ON public.learning_modules USING btree (rating);


--
-- TOC entry 5075 (class 1259 OID 17950)
-- Name: idx_learning_skill; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_learning_skill ON public.learning_modules USING btree (skill_id);


--
-- TOC entry 5082 (class 1259 OID 18014)
-- Name: idx_progress_completed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_progress_completed ON public.study_plan_progress USING btree (is_completed);


--
-- TOC entry 5083 (class 1259 OID 18011)
-- Name: idx_progress_plan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_progress_plan ON public.study_plan_progress USING btree (plan_id);


--
-- TOC entry 5084 (class 1259 OID 18012)
-- Name: idx_progress_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_progress_user ON public.study_plan_progress USING btree (user_id);


--
-- TOC entry 5085 (class 1259 OID 18013)
-- Name: idx_progress_week; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_progress_week ON public.study_plan_progress USING btree (week_number);


--
-- TOC entry 5048 (class 1259 OID 17845)
-- Name: idx_resumes_uploaded; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_resumes_uploaded ON public.resumes USING btree (uploaded_at);


--
-- TOC entry 5049 (class 1259 OID 17844)
-- Name: idx_resumes_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_resumes_user ON public.resumes USING btree (user_id);


--
-- TOC entry 5057 (class 1259 OID 17886)
-- Name: idx_role_skills_importance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_role_skills_importance ON public.role_skills USING btree (importance);


--
-- TOC entry 5058 (class 1259 OID 17884)
-- Name: idx_role_skills_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_role_skills_role ON public.role_skills USING btree (role_id);


--
-- TOC entry 5059 (class 1259 OID 17885)
-- Name: idx_role_skills_skill; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_role_skills_skill ON public.role_skills USING btree (skill_id);


--
-- TOC entry 5052 (class 1259 OID 17858)
-- Name: idx_skills_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_skills_category ON public.skills USING btree (skill_category);


--
-- TOC entry 5127 (class 1259 OID 18194)
-- Name: idx_stats_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stats_user ON public.user_statistics USING btree (user_id);


--
-- TOC entry 5078 (class 1259 OID 17982)
-- Name: idx_study_plans_result; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plans_result ON public.study_plans USING btree (result_id);


--
-- TOC entry 5079 (class 1259 OID 17981)
-- Name: idx_study_plans_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plans_user ON public.study_plans USING btree (user_id);


--
-- TOC entry 5038 (class 1259 OID 17810)
-- Name: idx_users_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_active ON public.users USING btree (is_active);


--
-- TOC entry 5039 (class 1259 OID 17809)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- TOC entry 5135 (class 2606 OID 17908)
-- Name: analysis_results analysis_results_resume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analysis_results
    ADD CONSTRAINT analysis_results_resume_id_fkey FOREIGN KEY (resume_id) REFERENCES public.resumes(resume_id) ON DELETE CASCADE;


--
-- TOC entry 5136 (class 2606 OID 17913)
-- Name: analysis_results analysis_results_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analysis_results
    ADD CONSTRAINT analysis_results_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.job_roles(role_id);


--
-- TOC entry 5137 (class 2606 OID 17903)
-- Name: analysis_results analysis_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analysis_results
    ADD CONSTRAINT analysis_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5143 (class 2606 OID 18049)
-- Name: job_skills job_skills_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_skills
    ADD CONSTRAINT job_skills_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(job_id) ON DELETE CASCADE;


--
-- TOC entry 5144 (class 2606 OID 18054)
-- Name: job_skills job_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_skills
    ADD CONSTRAINT job_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id) ON DELETE CASCADE;


--
-- TOC entry 5138 (class 2606 OID 17945)
-- Name: learning_modules learning_modules_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_modules
    ADD CONSTRAINT learning_modules_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id) ON DELETE CASCADE;


--
-- TOC entry 5132 (class 2606 OID 17839)
-- Name: resumes resumes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5133 (class 2606 OID 17874)
-- Name: role_skills role_skills_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_skills
    ADD CONSTRAINT role_skills_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.job_roles(role_id) ON DELETE CASCADE;


--
-- TOC entry 5134 (class 2606 OID 17879)
-- Name: role_skills role_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_skills
    ADD CONSTRAINT role_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id) ON DELETE CASCADE;


--
-- TOC entry 5141 (class 2606 OID 18001)
-- Name: study_plan_progress study_plan_progress_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_progress
    ADD CONSTRAINT study_plan_progress_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.study_plans(plan_id) ON DELETE CASCADE;


--
-- TOC entry 5142 (class 2606 OID 18006)
-- Name: study_plan_progress study_plan_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_progress
    ADD CONSTRAINT study_plan_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5139 (class 2606 OID 17976)
-- Name: study_plans study_plans_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_result_id_fkey FOREIGN KEY (result_id) REFERENCES public.analysis_results(result_id) ON DELETE CASCADE;


--
-- TOC entry 5140 (class 2606 OID 17971)
-- Name: study_plans study_plans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5151 (class 2606 OID 18162)
-- Name: user_activity_log user_activity_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_activity_log
    ADD CONSTRAINT user_activity_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5149 (class 2606 OID 18140)
-- Name: user_course_progress user_course_progress_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_course_progress
    ADD CONSTRAINT user_course_progress_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.learning_modules(module_id) ON DELETE CASCADE;


--
-- TOC entry 5150 (class 2606 OID 18135)
-- Name: user_course_progress user_course_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_course_progress
    ADD CONSTRAINT user_course_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5147 (class 2606 OID 18108)
-- Name: user_job_alerts user_job_alerts_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_alerts
    ADD CONSTRAINT user_job_alerts_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.job_roles(role_id);


--
-- TOC entry 5148 (class 2606 OID 18103)
-- Name: user_job_alerts user_job_alerts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_alerts
    ADD CONSTRAINT user_job_alerts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5145 (class 2606 OID 18083)
-- Name: user_job_bookmarks user_job_bookmarks_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_bookmarks
    ADD CONSTRAINT user_job_bookmarks_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(job_id) ON DELETE CASCADE;


--
-- TOC entry 5146 (class 2606 OID 18078)
-- Name: user_job_bookmarks user_job_bookmarks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_job_bookmarks
    ADD CONSTRAINT user_job_bookmarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5152 (class 2606 OID 18189)
-- Name: user_statistics user_statistics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_statistics
    ADD CONSTRAINT user_statistics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2026-02-26 12:13:22

--
-- PostgreSQL database dump complete
--

\unrestrict bh95MpVKOh0PO5hgUZairhPhcRcdBsUX0nYH9dYIqCZxxX7Fv66iKbVaFuVMsVJ

