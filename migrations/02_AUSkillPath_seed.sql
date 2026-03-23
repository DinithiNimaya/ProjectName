INSERT INTO roles (role_name) VALUES
    ('Data Analyst'),
    ('BI Analyst'),
    ('Data Engineer');


INSERT INTO users (name, email, role_id, experience, study_hour)
VALUES (
    'Alex Johnson',
    'alex.johnson@email.com',
    1,
    'junior',
    10
);


INSERT INTO resumes (user_id, file_path, file_type)
VALUES (
    1,
    '/uploads/resume_alex_johnson.pdf',
    'pdf'
);


INSERT INTO analyses (user_id, resume_id, role_id, is_qualified, percentage, motivational_summary)
VALUES (
    1,
    1,
    1,
    FALSE,
    72.50,
    'You''re 72% of the way to your Data Analyst goals — great foundation! Focus on Power BI, Azure, and Machine Learning to close the gap.'
);


INSERT INTO analyze_skills (analyze_id, skill_name, status) VALUES
    (1, 'Python',           'have'),
    (1, 'SQL',              'have'),
    (1, 'Excel',            'have'),
    (1, 'Tableau',          'have'),
    (1, 'Data Cleaning',    'have'),
    (1, 'Statistics',       'have'),
    (1, 'Power BI',         'must_develop'),
    (1, 'Azure',            'must_develop'),
    (1, 'Machine Learning', 'must_develop'),
    (1, 'Spark',            'nice_develop'),
    (1, 'dbt',              'nice_develop'),
    (1, 'Looker',           'nice_develop');


INSERT INTO study_plans (analyze_id, duration_weeks, study_hours_per_week, progress)
VALUES (
    1,
    8,
    10,
    25.00
);


INSERT INTO study_plan_details
    (study_plan_id, week_number, name, estimated_hour, is_completed)
VALUES
    (1, 1, 'Power BI Fundamentals',          10, TRUE),
    (1, 2, 'Azure Data Fundamentals',        10, TRUE),
    (1, 3, 'Machine Learning Intro',         10, FALSE),
    (1, 4, 'Advanced SQL & Optimisation',    10, FALSE),
    (1, 5, 'Data Storytelling & Dashboards', 10, FALSE),
    (1, 6, 'dbt & Data Modelling',           10, FALSE),
    (1, 7, 'Portfolio Project',              10, FALSE),
    (1, 8, 'Job Application Prep',           10, FALSE);


INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (1, 'Complete the Power BI Desktop Getting Started tutorial on Microsoft Learn', TRUE,  NOW() - INTERVAL '6 days'),
    (1, 'Build your first dashboard using the sample Superstore dataset',            TRUE,  NOW() - INTERVAL '4 days'),
    (1, 'Practice DAX basics: SUM, CALCULATE, FILTER functions',                     FALSE, NULL);

INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (2, 'Set up a free Azure account and explore the portal',               TRUE,  NOW() - INTERVAL '3 days'),
    (2, 'Complete DP-900 Azure Data Fundamentals prep course',              TRUE,  NOW() - INTERVAL '2 days'),
    (2, 'Practice creating Azure Blob Storage and SQL Database instances',  TRUE,  NOW() - INTERVAL '1 day'),
    (2, 'Take the DP-900 practice exam',                                    TRUE,  NOW() - INTERVAL '12 hours');

INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (3, 'Complete Andrew Ng''s ML Crash Course Week 1 & 2',            FALSE, NULL),
    (3, 'Implement a basic linear regression model using scikit-learn', FALSE, NULL),
    (3, 'Apply model to a real dataset from Kaggle',                    FALSE, NULL);

INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (4, 'Practice window functions: ROW_NUMBER, RANK, LAG, LEAD', FALSE, NULL),
    (4, 'Write CTEs and subqueries on real datasets',              FALSE, NULL),
    (4, 'Complete 10 LeetCode SQL Medium questions',               FALSE, NULL),
    (4, 'Review query execution plans and indexing basics',        FALSE, NULL);

INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (5, 'Study chart selection frameworks and data-ink ratio principles', FALSE, NULL),
    (5, 'Build an end-to-end dashboard in Power BI with a real dataset',  FALSE, NULL),
    (5, 'Present dashboard findings in a written summary',                 FALSE, NULL);

INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (6, 'Complete the dbt Fundamentals free certification course',   FALSE, NULL),
    (6, 'Set up a local dbt project connected to a sample database', FALSE, NULL),
    (6, 'Build models, tests, and documentation in dbt',             FALSE, NULL);

INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (7, 'Build an end-to-end capstone: data ingestion to SQL to Power BI dashboard', FALSE, NULL),
    (7, 'Publish project to GitHub with a clear README',                              FALSE, NULL);

INSERT INTO study_plan_tasks (detail_id, name, is_completed, completed_at) VALUES
    (8, 'Update resume with new skills and portfolio project',          FALSE, NULL),
    (8, 'Update LinkedIn profile with certifications and project',      FALSE, NULL),
    (8, 'Practise 10 common Data Analyst interview questions',          FALSE, NULL),
    (8, 'Apply to 5 Data Analyst roles on Seek and LinkedIn Australia', FALSE, NULL);


INSERT INTO study_plan_resources (detail_id, name, resource_link, format) VALUES
    (1, 'Microsoft Learn — Power BI Fundamentals',
        'https://learn.microsoft.com/en-us/training/paths/get-started-power-bi/',
        'Free Course'),
    (1, 'Guy in a Cube — YouTube Power BI Series',
        'https://www.youtube.com/@GuyInACube',
        'Video');

INSERT INTO study_plan_resources (detail_id, name, resource_link, format) VALUES
    (2, 'Microsoft Learn — DP-900 Path',
        'https://learn.microsoft.com/en-us/certifications/exams/dp-900',
        'Free Course'),
    (2, 'John Savill''s Azure Study Cram',
        'https://www.youtube.com/@NTFAQGuy',
        'Video');

INSERT INTO study_plan_resources (detail_id, name, resource_link, format) VALUES
    (3, 'Coursera — Machine Learning Specialization',
        'https://www.coursera.org/specializations/machine-learning-introduction',
        'Course'),
    (3, 'Kaggle — Intro to Machine Learning',
        'https://www.kaggle.com/learn/intro-to-machine-learning',
        'Hands-on');

INSERT INTO study_plan_resources (detail_id, name, resource_link, format) VALUES
    (4, 'Mode Analytics SQL Tutorial',
        'https://mode.com/sql-tutorial/',
        'Free Course');

INSERT INTO study_plan_resources (detail_id, name, resource_link, format) VALUES
    (6, 'dbt Fundamentals Free Certification',
        'https://courses.getdbt.com/courses/fundamentals',
        'Free Course');
