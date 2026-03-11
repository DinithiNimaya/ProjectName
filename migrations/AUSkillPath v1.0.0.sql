--
-- PostgreSQL database dump
--

\restrict FlnyuLvDKR9AMWjguAwMsBm91Y8xHMxXaOqcJitqHA6ggoZmsCrHHoG3mw2gIAF

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-03-09 11:14:16

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
-- TOC entry 869 (class 1247 OID 18224)
-- Name: experience_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.experience_level AS ENUM (
    'junior',
    'mid',
    'senior'
);


ALTER TYPE public.experience_level OWNER TO postgres;

--
-- TOC entry 872 (class 1247 OID 18232)
-- Name: file_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.file_type AS ENUM (
    'pdf',
    'docx'
);


ALTER TYPE public.file_type OWNER TO postgres;

--
-- TOC entry 875 (class 1247 OID 18238)
-- Name: skill_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.skill_status AS ENUM (
    'have',
    'must_develop',
    'nice_develop'
);


ALTER TYPE public.skill_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 18302)
-- Name: analyses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analyses (
    analyze_id integer NOT NULL,
    user_id integer NOT NULL,
    resume_id integer NOT NULL,
    is_qualified boolean NOT NULL,
    percentage numeric(5,2) NOT NULL,
    analyzed_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT analyses_percentage_check CHECK (((percentage >= (0)::numeric) AND (percentage <= (100)::numeric)))
);


ALTER TABLE public.analyses OWNER TO postgres;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE analyses; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.analyses IS 'AI analysis result of a resume against a target role (Screen 3)';


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN analyses.is_qualified; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.analyses.is_qualified IS 'TRUE if percentage meets the qualification threshold';


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN analyses.percentage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.analyses.percentage IS 'Skills coverage percentage e.g. 72.50';


--
-- TOC entry 225 (class 1259 OID 18301)
-- Name: analyses_analyze_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analyses_analyze_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.analyses_analyze_id_seq OWNER TO postgres;

--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 225
-- Name: analyses_analyze_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analyses_analyze_id_seq OWNED BY public.analyses.analyze_id;


--
-- TOC entry 228 (class 1259 OID 18327)
-- Name: analyze_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analyze_skills (
    skill_id integer NOT NULL,
    analyze_id integer NOT NULL,
    skill_name character varying(100) NOT NULL,
    status public.skill_status NOT NULL
);


ALTER TABLE public.analyze_skills OWNER TO postgres;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE analyze_skills; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.analyze_skills IS 'One row per skill detected in the analysis';


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN analyze_skills.skill_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.analyze_skills.skill_name IS 'Skill name e.g. Power BI, Python, Azure';


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN analyze_skills.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.analyze_skills.status IS 'have = green | must_develop = red | nice_develop = orange';


--
-- TOC entry 227 (class 1259 OID 18326)
-- Name: analyze_skills_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analyze_skills_skill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.analyze_skills_skill_id_seq OWNER TO postgres;

--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 227
-- Name: analyze_skills_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analyze_skills_skill_id_seq OWNED BY public.analyze_skills.skill_id;


--
-- TOC entry 224 (class 1259 OID 18282)
-- Name: resumes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resumes (
    resume_id integer NOT NULL,
    user_id integer NOT NULL,
    file_path text NOT NULL,
    file_type public.file_type NOT NULL,
    uploaded_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.resumes OWNER TO postgres;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE resumes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.resumes IS 'Resume files uploaded by users (Screen 2)';


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN resumes.file_path; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.file_path IS 'Storage path or URL e.g. /uploads/resume_alex.pdf';


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN resumes.file_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.file_type IS 'Accepted formats: pdf | docx';


--
-- TOC entry 223 (class 1259 OID 18281)
-- Name: resumes_resume_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resumes_resume_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resumes_resume_id_seq OWNER TO postgres;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 223
-- Name: resumes_resume_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resumes_resume_id_seq OWNED BY public.resumes.resume_id;


--
-- TOC entry 220 (class 1259 OID 18246)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.roles IS 'Master list of target job roles available in AUSkillPath';


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN roles.role_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.roles.role_id IS 'Auto-incremented primary key';


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN roles.role_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.roles.role_name IS 'Unique role name e.g. Data Analyst, BI Analyst';


--
-- TOC entry 219 (class 1259 OID 18245)
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- TOC entry 232 (class 1259 OID 18370)
-- Name: study_plan_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plan_details (
    detail_id integer NOT NULL,
    study_plan_id integer NOT NULL,
    week_number integer NOT NULL,
    name character varying(150) NOT NULL,
    estimated_hour integer,
    is_completed boolean DEFAULT false NOT NULL,
    CONSTRAINT study_plan_details_estimated_hour_check CHECK ((estimated_hour > 0)),
    CONSTRAINT study_plan_details_week_number_check CHECK ((week_number >= 1))
);


ALTER TABLE public.study_plan_details OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE study_plan_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_plan_details IS 'One row per week in the study plan accordion';


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN study_plan_details.week_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plan_details.week_number IS 'Week sequence: 1 = W1, 2 = W2 … 8 = W8';


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN study_plan_details.estimated_hour; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plan_details.estimated_hour IS 'Estimated hours shown in UI e.g. ~10 hrs';


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN study_plan_details.is_completed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plan_details.is_completed IS 'TRUE when all tasks in this week are done (green badge)';


--
-- TOC entry 231 (class 1259 OID 18369)
-- Name: study_plan_details_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_plan_details_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_plan_details_detail_id_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 231
-- Name: study_plan_details_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_plan_details_detail_id_seq OWNED BY public.study_plan_details.detail_id;


--
-- TOC entry 236 (class 1259 OID 18411)
-- Name: study_plan_resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plan_resources (
    resource_id integer NOT NULL,
    detail_id integer NOT NULL,
    name character varying(255) NOT NULL,
    resource_link text,
    format character varying(50)
);


ALTER TABLE public.study_plan_resources OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE study_plan_resources; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_plan_resources IS 'Resource links listed under each week (Screen 4)';


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN study_plan_resources.resource_link; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plan_resources.resource_link IS 'Full URL to the resource';


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN study_plan_resources.format; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plan_resources.format IS 'Badge label: Free Course | Video | Hands-on';


--
-- TOC entry 235 (class 1259 OID 18410)
-- Name: study_plan_resources_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_plan_resources_resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_plan_resources_resource_id_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 235
-- Name: study_plan_resources_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_plan_resources_resource_id_seq OWNED BY public.study_plan_resources.resource_id;


--
-- TOC entry 234 (class 1259 OID 18392)
-- Name: study_plan_tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plan_tasks (
    task_id integer NOT NULL,
    detail_id integer NOT NULL,
    name text NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    completed_at timestamp without time zone
);


ALTER TABLE public.study_plan_tasks OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE study_plan_tasks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_plan_tasks IS 'Checkbox tasks inside each week accordion (Screen 4)';


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN study_plan_tasks.is_completed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plan_tasks.is_completed IS 'Checkbox state — TRUE when user checks it off';


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN study_plan_tasks.completed_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plan_tasks.completed_at IS 'Timestamp of when task was checked — NULL if not done';


--
-- TOC entry 233 (class 1259 OID 18391)
-- Name: study_plan_tasks_task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_plan_tasks_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_plan_tasks_task_id_seq OWNER TO postgres;

--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 233
-- Name: study_plan_tasks_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_plan_tasks_task_id_seq OWNED BY public.study_plan_tasks.task_id;


--
-- TOC entry 230 (class 1259 OID 18343)
-- Name: study_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plans (
    study_plan_id integer NOT NULL,
    analyze_id integer NOT NULL,
    role_id integer NOT NULL,
    progress numeric(5,2) DEFAULT 0.00 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT study_plans_progress_check CHECK (((progress >= (0)::numeric) AND (progress <= (100)::numeric)))
);


ALTER TABLE public.study_plans OWNER TO postgres;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE study_plans; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_plans IS 'Top-level 8-week study plan linked to an analysis (Screen 4)';


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN study_plans.role_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plans.role_id IS 'Role tab selected on Screen 4 — may differ from users.role_id';


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN study_plans.progress; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_plans.progress IS 'Overall completion percentage 0.00–100.00';


--
-- TOC entry 229 (class 1259 OID 18342)
-- Name: study_plans_study_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_plans_study_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_plans_study_plan_id_seq OWNER TO postgres;

--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 229
-- Name: study_plans_study_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_plans_study_plan_id_seq OWNED BY public.study_plans.study_plan_id;


--
-- TOC entry 222 (class 1259 OID 18257)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    name character varying(100) NOT NULL,
    telephone character varying(20),
    email character varying(255) NOT NULL,
    role_id integer NOT NULL,
    experience public.experience_level NOT NULL,
    study_hour integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_study_hour_check CHECK (((study_hour >= 1) AND (study_hour <= 40)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'User accounts created during onboarding (Screen 1)';


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN users.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.user_id IS 'Auto-incremented primary key';


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN users.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.email IS 'Must be unique — used as account identifier';


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN users.role_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.role_id IS 'FK → roles: target job role selected on onboarding';


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN users.experience; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.experience IS 'Experience level: junior | mid | senior';


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN users.study_hour; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.study_hour IS 'Preferred weekly study hours (1–40)';


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN users.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.updated_at IS 'Updated whenever user edits their profile';


--
-- TOC entry 221 (class 1259 OID 18256)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4911 (class 2604 OID 18305)
-- Name: analyses analyze_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyses ALTER COLUMN analyze_id SET DEFAULT nextval('public.analyses_analyze_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 18330)
-- Name: analyze_skills skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyze_skills ALTER COLUMN skill_id SET DEFAULT nextval('public.analyze_skills_skill_id_seq'::regclass);


--
-- TOC entry 4909 (class 2604 OID 18285)
-- Name: resumes resume_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes ALTER COLUMN resume_id SET DEFAULT nextval('public.resumes_resume_id_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 18249)
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- TOC entry 4918 (class 2604 OID 18373)
-- Name: study_plan_details detail_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_details ALTER COLUMN detail_id SET DEFAULT nextval('public.study_plan_details_detail_id_seq'::regclass);


--
-- TOC entry 4922 (class 2604 OID 18414)
-- Name: study_plan_resources resource_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_resources ALTER COLUMN resource_id SET DEFAULT nextval('public.study_plan_resources_resource_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 18395)
-- Name: study_plan_tasks task_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_tasks ALTER COLUMN task_id SET DEFAULT nextval('public.study_plan_tasks_task_id_seq'::regclass);


--
-- TOC entry 4914 (class 2604 OID 18346)
-- Name: study_plans study_plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans ALTER COLUMN study_plan_id SET DEFAULT nextval('public.study_plans_study_plan_id_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 18260)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5126 (class 0 OID 18302)
-- Dependencies: 226
-- Data for Name: analyses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analyses (analyze_id, user_id, resume_id, is_qualified, percentage, analyzed_at) FROM stdin;
\.


--
-- TOC entry 5128 (class 0 OID 18327)
-- Dependencies: 228
-- Data for Name: analyze_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analyze_skills (skill_id, analyze_id, skill_name, status) FROM stdin;
\.


--
-- TOC entry 5124 (class 0 OID 18282)
-- Dependencies: 224
-- Data for Name: resumes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resumes (resume_id, user_id, file_path, file_type, uploaded_at) FROM stdin;
\.


--
-- TOC entry 5120 (class 0 OID 18246)
-- Dependencies: 220
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
\.


--
-- TOC entry 5132 (class 0 OID 18370)
-- Dependencies: 232
-- Data for Name: study_plan_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_plan_details (detail_id, study_plan_id, week_number, name, estimated_hour, is_completed) FROM stdin;
\.


--
-- TOC entry 5136 (class 0 OID 18411)
-- Dependencies: 236
-- Data for Name: study_plan_resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_plan_resources (resource_id, detail_id, name, resource_link, format) FROM stdin;
\.


--
-- TOC entry 5134 (class 0 OID 18392)
-- Dependencies: 234
-- Data for Name: study_plan_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_plan_tasks (task_id, detail_id, name, is_completed, completed_at) FROM stdin;
\.


--
-- TOC entry 5130 (class 0 OID 18343)
-- Dependencies: 230
-- Data for Name: study_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_plans (study_plan_id, analyze_id, role_id, progress, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5122 (class 0 OID 18257)
-- Dependencies: 222
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, telephone, email, role_id, experience, study_hour, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 225
-- Name: analyses_analyze_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analyses_analyze_id_seq', 1, false);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 227
-- Name: analyze_skills_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analyze_skills_skill_id_seq', 1, false);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 223
-- Name: resumes_resume_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resumes_resume_id_seq', 1, false);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 1, false);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 231
-- Name: study_plan_details_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_plan_details_detail_id_seq', 1, false);


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 235
-- Name: study_plan_resources_resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_plan_resources_resource_id_seq', 1, false);


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 233
-- Name: study_plan_tasks_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_plan_tasks_task_id_seq', 1, false);


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 229
-- Name: study_plans_study_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_plans_study_plan_id_seq', 1, false);


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- TOC entry 4941 (class 2606 OID 18315)
-- Name: analyses analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyses
    ADD CONSTRAINT analyses_pkey PRIMARY KEY (analyze_id);


--
-- TOC entry 4945 (class 2606 OID 18336)
-- Name: analyze_skills analyze_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyze_skills
    ADD CONSTRAINT analyze_skills_pkey PRIMARY KEY (skill_id);


--
-- TOC entry 4939 (class 2606 OID 18295)
-- Name: resumes resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (resume_id);


--
-- TOC entry 4929 (class 2606 OID 18253)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 4931 (class 2606 OID 18255)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 4953 (class 2606 OID 18383)
-- Name: study_plan_details study_plan_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_details
    ADD CONSTRAINT study_plan_details_pkey PRIMARY KEY (detail_id);


--
-- TOC entry 4961 (class 2606 OID 18421)
-- Name: study_plan_resources study_plan_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_resources
    ADD CONSTRAINT study_plan_resources_pkey PRIMARY KEY (resource_id);


--
-- TOC entry 4958 (class 2606 OID 18404)
-- Name: study_plan_tasks study_plan_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_tasks
    ADD CONSTRAINT study_plan_tasks_pkey PRIMARY KEY (task_id);


--
-- TOC entry 4950 (class 2606 OID 18358)
-- Name: study_plans study_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_pkey PRIMARY KEY (study_plan_id);


--
-- TOC entry 4955 (class 2606 OID 18385)
-- Name: study_plan_details uq_sdetail_week; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_details
    ADD CONSTRAINT uq_sdetail_week UNIQUE (study_plan_id, week_number);


--
-- TOC entry 4934 (class 2606 OID 18275)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4936 (class 2606 OID 18273)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4942 (class 1259 OID 18430)
-- Name: idx_analyses_resume; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analyses_resume ON public.analyses USING btree (resume_id);


--
-- TOC entry 4943 (class 1259 OID 18429)
-- Name: idx_analyses_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analyses_user ON public.analyses USING btree (user_id);


--
-- TOC entry 4946 (class 1259 OID 18431)
-- Name: idx_askills_analysis; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_askills_analysis ON public.analyze_skills USING btree (analyze_id);


--
-- TOC entry 4937 (class 1259 OID 18428)
-- Name: idx_resumes_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_resumes_user ON public.resumes USING btree (user_id);


--
-- TOC entry 4951 (class 1259 OID 18434)
-- Name: idx_sdetail_plan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sdetail_plan ON public.study_plan_details USING btree (study_plan_id);


--
-- TOC entry 4947 (class 1259 OID 18432)
-- Name: idx_splan_analysis; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_splan_analysis ON public.study_plans USING btree (analyze_id);


--
-- TOC entry 4948 (class 1259 OID 18433)
-- Name: idx_splan_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_splan_role ON public.study_plans USING btree (role_id);


--
-- TOC entry 4959 (class 1259 OID 18436)
-- Name: idx_sresource_detail; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sresource_detail ON public.study_plan_resources USING btree (detail_id);


--
-- TOC entry 4956 (class 1259 OID 18435)
-- Name: idx_stask_detail; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stask_detail ON public.study_plan_tasks USING btree (detail_id);


--
-- TOC entry 4932 (class 1259 OID 18427)
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role_id);


--
-- TOC entry 4964 (class 2606 OID 18321)
-- Name: analyses fk_analyses_resume; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyses
    ADD CONSTRAINT fk_analyses_resume FOREIGN KEY (resume_id) REFERENCES public.resumes(resume_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4965 (class 2606 OID 18316)
-- Name: analyses fk_analyses_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyses
    ADD CONSTRAINT fk_analyses_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4966 (class 2606 OID 18337)
-- Name: analyze_skills fk_askills_analysis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyze_skills
    ADD CONSTRAINT fk_askills_analysis FOREIGN KEY (analyze_id) REFERENCES public.analyses(analyze_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4963 (class 2606 OID 18296)
-- Name: resumes fk_resumes_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT fk_resumes_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4969 (class 2606 OID 18386)
-- Name: study_plan_details fk_sdetail_plan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_details
    ADD CONSTRAINT fk_sdetail_plan FOREIGN KEY (study_plan_id) REFERENCES public.study_plans(study_plan_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4967 (class 2606 OID 18359)
-- Name: study_plans fk_splan_analysis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT fk_splan_analysis FOREIGN KEY (analyze_id) REFERENCES public.analyses(analyze_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4968 (class 2606 OID 18364)
-- Name: study_plans fk_splan_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT fk_splan_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4971 (class 2606 OID 18422)
-- Name: study_plan_resources fk_sresource_detail; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_resources
    ADD CONSTRAINT fk_sresource_detail FOREIGN KEY (detail_id) REFERENCES public.study_plan_details(detail_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4970 (class 2606 OID 18405)
-- Name: study_plan_tasks fk_stask_detail; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_tasks
    ADD CONSTRAINT fk_stask_detail FOREIGN KEY (detail_id) REFERENCES public.study_plan_details(detail_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4962 (class 2606 OID 18276)
-- Name: users fk_users_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2026-03-09 11:14:16

--
-- PostgreSQL database dump complete
--

\unrestrict FlnyuLvDKR9AMWjguAwMsBm91Y8xHMxXaOqcJitqHA6ggoZmsCrHHoG3mw2gIAF

