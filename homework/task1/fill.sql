CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- generate accounts
INSERT INTO account
    (account_login
    ,account_password_hash)
SELECT
    'login'||g.id,
    '$2a$08$BUEGe7Fo6KXN7.zqKqgEp.olCZjRwcC9OMNAJACy41VNTso3.47je' --crypt('qwerty', gen_salt('bf', 8))
FROM generate_series(1,100) as g(id);

-- generate employee
INSERT INTO employee(account_id)
SELECT g.id FROM generate_series(1,100,2) as g(id);

-- generate companies
INSERT INTO company
    (company_name
    ,company_description
    ,company_url)
SELECT
    'company'||g.id
    ,'description'||g.id
    ,'url'||g.id
FROM generate_series(1,100) as g(id);

-- generate employer
INSERT INTO employer
    (account_id
    ,company_id
    ,full_name
    ,photo_url
    ,contact_info)
SELECT
    g.id,
    g.Id / 2,
    'employer'||g.id,
    'https://www.google.com/'||g.id,
    '+7'||g.id
FROM generate_series(2,100,2) as g(id);

-- generate cv
INSERT INTO cv
    (employee_id
    ,cv_status
    ,cv_name
    ,full_name
    ,photo_url
    ,salary
    ,place
    ,employment_types
    ,spheres
    ,skills
    ,about_me
    ,contact_info
    ,created_timestamp
    ,refreshed_timestamp)
SELECT
    g.id
    ,(select g.st from unnest(enum_range(NULL::CV_STATUS)) as g(st) order by random() limit 1)
    ,'cv'||g.id
    ,'Ivan'||g.id
    ,'https://www.google.com/'||g.id
    ,round(100000 + random()*100000)
    ,'Moscow, Arbat '||g.id
    ,(select array(select g.et from unnest(enum_range(NULL::EMPLOYMENT_TYPE)) as g(et) order by random() limit 2))
    ,(select array(select g.sp from unnest(enum_range(NULL::SPHERE)) as g(sp) order by random() limit 3))
    ,(select array(select g.sk from unnest(array['C#', 'SQL', 'Java', 'Erlang']) as g(sk) order by random() limit 2))
    ,(select g.am from unnest(array['I am cool', 'I am smart', 'Be like me', 'Be Good', 'Very very good']) as g(am) order by random() limit 1)
    ,'+7'||g.id
    ,now()
    ,now()
FROM generate_series(1,25) as g(id);

-- generate cv attributes
INSERT INTO cv_job
    (cv_id
    ,date_from
    ,date_upto
    ,job_company
    ,job_position
    ,job_description)
SELECT
    g.id
    ,NOW() + (random() * (NOW()+'90 days' - NOW())) + '30 days'
    ,NOW() + (random() * (NOW()+'90 days' - NOW())) + '30 days'
    ,'Company'||g.id
    ,'Position'||g.id
    ,'Description'||g.id
from generate_series(1,25) as g(id);

INSERT INTO cv_education
    (cv_id
    ,date_from
    ,date_upto
    ,education_place
    ,education_specialty
    ,education_description)
SELECT
    g.id
    ,NOW() + (random() * (NOW()+'90 days' - NOW())) + '30 days'
    ,NOW() + (random() * (NOW()+'90 days' - NOW())) + '30 days'
    ,'Place'||g.id
    ,'Specialty'||g.id
    ,'Description'||g.id
from generate_series(1,25) as g(id);

INSERT INTO cv_certificates
    (cv_id
    ,date_from
    ,date_upto
    ,certificate_name
    ,certificate_description)
SELECT
    g.id
    ,NOW() + (random() * (NOW()+'90 days' - NOW())) + '30 days'
    ,null
    ,'Name'||g.id
    ,'Description'||g.id
from generate_series(1,25) as g(id);

-- generate vacancy
INSERT INTO vacancy
    (company_id
    ,vacancy_status
    ,vacancy_name
    ,vacancy_description
    ,salary_min
    ,salary_max
    ,place
    ,employment_types
    ,spheres
    ,skills
    ,created_timestamp
    ,refreshed_timestamp)
SELECT
    g.id
    ,(select (array(select * from unnest(enum_range(NULL::VACANCY_STATUS))))[floor(random()*3)::int + 1])
    ,'Vacancy'||g.id
    ,'Description'||g.id
    ,round(100000 + random()*100000)
    ,round(500000 + random()*100000)
    ,'Moscow, Arbat '||g.id
    ,(select array(select g.et from unnest(enum_range(NULL::EMPLOYMENT_TYPE)) as g(et) order by random() limit 2))
    ,(select array(select g.sp from unnest(enum_range(NULL::SPHERE)) as g(sp) order by random() limit 3))
    ,(select array(select g.sk from unnest(array['C#', 'SQL', 'Java', 'Erlang']) as g(sk) order by random() limit 2))
    ,now()
    ,now()
FROM generate_series(1,25) as g(id);

-- generate response
INSERT INTO response
    (cv_id
    ,vacancy_id
    ,employer_id
    ,response_source
    ,response_status
    ,created_timestamp
    ,status_changed_timestamp)
SELECT
    g.id
    ,g.id
    ,g.id
    ,(select g.so from unnest(enum_range(NULL::SOURCE)) as g(so) order by random() limit 1)
    ,(select g.st from unnest(enum_range(NULL::RESPONSE_STATUS)) as g(st) order by random() limit 1)
    ,now()
    ,now()
FROM generate_series(1,25) as g(id);


-- generate messages
INSERT INTO messages
    (response_id
    ,is_new
    ,message_timestamp
    ,message_source
    ,message_text)
SELECT
    g.id
    ,TRUE
    ,now()
    ,(select g.so from unnest(enum_range(NULL::SOURCE)) as g(so) order by random() limit 1)
    ,'Text message: '||g.id
FROM generate_series(1,25) as g(id);