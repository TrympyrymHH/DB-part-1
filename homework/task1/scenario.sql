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
INSERT INTO employee (account_id) VALUES (currval('account_id_seq'));

-- Register as Employer
INSERT INTO employer 
    (account_id
    ,company_id
    ,full_name
    ,photo_url
    ,contact_info)
VALUES
    (currval('account_id_seq')
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
UPDATE employer set company_id = lastval() where id = currval('employee_id_seq');

-- Employee can create/update CV
-- Employee can add Job/Certificate/Education to CV
-- Employee can search Vacancies
-- Employee can send response to Vacancy with CV
-- Employee can see responses to his CV and his responses to Vacancies

-- Employer can create Vacancy for Company
-- Employer can search CVs
-- Employer can send response to CV with Vacancy (he will be assigned to it)
-- Employer can see responses to Vacancies and assign himself to it
-- Employee can see responses to company Vacancies

-- Employee and Employer can chat with each other with Messages on Response


