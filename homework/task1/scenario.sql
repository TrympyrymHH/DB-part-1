-- Create account
INSERT INTO account
    (account_login
    ,account_password_hash)
VALUES
    ('admin',
    crypt('qwerty', gen_salt('bf', 8)));

-- Login
SELECT 1 as IsCorrect
FROM account
WHERE account_login = 'admin'
  AND account_password_hash = crypt('qwerty', account_password_hash)
LIMIT 1;

-- Register as Employee
INSERT INTO employee (account_id) VALUES (1);

-- Register as Employer
INSERT INTO employer 
    (account_id
    ,company_id
    ,full_name
    ,photo_url
    ,contact_info)
VALUES
    (1
    ,null
    ,'FIO'
    ,null
    ,null);

-- Create Company
INSERT INTO company
    (company_name
    ,company_description
    ,company_url)
VALUES
    ('Big COMPANY'
    ,'Super Big Company, You should work there'
    ,'https://www.google.com');

-- Add Employer to Company
UPDATE employer set company_id = 1 where id = 1;

-- Employee can create/update CV
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
VALUES
    (1
    ,'VISIBLE'
    ,'Programmer'
    ,'Ivanov Ivan'
    ,null
    ,null
    ,'Moscow'
    ,'{"full-time"}'
    ,'{"IT"}'
    ,'{"C#"}'
    ,'Work with me!'
    ,'+79998887766'
    ,now()
    ,now());

-- Employee can add Job/Certificate/Education to CV
INSERT INTO cv_job
    (cv_id
    ,date_from
    ,date_upto
    ,job_company
    ,job_position
    ,job_description)
VALUES
    (1
    ,now()
    ,null
    ,'My Company'
    ,'My Position In Company'
    ,'I have done everything');

-- Employee can refresh CV date
UPDATE cv set refreshed_timestamp = now() where employee_id = 1;

-- Employee can search Vacancies
SELECT v.vacancy_name, v.vacancy_description
FROM vacancy v
WHERE v.vacancy_status = 'OPEN' and 'C#' = ANY(v.skills)
ORDER BY v.refreshed_timestamp DESC
LIMIT 10;

-- Employer can create Vacancy for Company
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
VALUES
    (1
    ,'OPEN'
    ,'Programmer C#'
    ,'Do everything you can'
    ,100000
    ,200000
    ,'Moscow'
    ,'{"part-time"}'
    ,'{"IT"}'
    ,'{"C#", "F#", "SQL"}'
    ,now()
    ,now());

-- Employer can search CVs
SELECT c.cv_name, c.about_me
FROM cv c
WHERE c.cv_status = 'VISIBLE' and 'C#' = ANY(c.skills)
ORDER BY c.refreshed_timestamp DESC LIMIT 10;

-- Employer can open vacancy and see additional info like jobs, certificates, education
SELECT date_from, date_upto, job_company, job_position, job_description FROM cv_job WHERE cv_id = 1;
SELECT date_from, date_upto, education_place, education_specialty, education_description FROM cv_education WHERE cv_id = 1;
SELECT date_from, date_upto, certificate_name, certificate_description FROM cv_certificates WHERE cv_id = 1;

-- Employee can send response to Vacancy with CV
INSERT INTO response (cv_id, vacancy_id, response_source, response_status, created_timestamp)
VALUES (1, 1, 'EMPLOYEE', 'NEW', now());

-- Employee can see responses to his CV and his responses to Vacancies
SELECT r.vacancy_id
FROM response r
LEFT JOIN cv c ON c.id = r.cv_id
WHERE c.employee_id = 1;
  -- and r.response_status = 'NEW' -- and can filter by only new one
  -- and r.response_source = 'EMPLOYER' -- which send him employers

-- Employer can send response to CV with Vacancy (he will be assigned to it)
INSERT INTO response (cv_id, vacancy_id, employer_id, response_source, response_status, created_timestamp)
VALUES (1, 1, 1, 'EMPLOYER', 'NEW', now());

-- Employer can see responses to Vacancies and assign himself to it
SELECT id, cv_id
FROM response
WHERE vacancy_id = 1
  and response_source = 'EMPLOYEE'
  and response_status = 'NEW'
LIMIT 10;

UPDATE response SET
  response_status = 'READ',
  employer_id = 1
WHERE id = 1;

-- Employee can see responses to company Vacancies from Employee
SELECT r.id, r.cv_id
FROM response r
LEFT JOIN vacancy v on v.id = r.vacancy_id
WHERE v.company_id = 1
  and r.response_source = 'EMPLOYEE'
LIMIT 10;

-- Employee and Employer can chat with each other with Messages on Response
INSERT INTO messages
    (response_id
    ,is_new
    ,message_timestamp
    ,message_source
    ,message_text)
VALUES
    (1
    ,TRUE
    ,now()
    ,'EMPLOYEE'
    ,'Follow me');

SELECT message_text
FROM messages
WHERE response_id = 1
ORDER BY message_timestamp DESC
LIMIT 50;


