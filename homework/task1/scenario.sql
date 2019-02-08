-- Create account
INSERT INTO accounts
    (account_login
    ,account_password_hash)
VALUES
    :input_login
    crypt(:input_password, gen_salt('bf', 8));
-- Login
SELECT TOP 1 1
FROM account
WHERE account_login = :input_login
  AND account_password_hash = crypt(:input_password_hash, account_password_hash);

-- Register as Employee
-- Register as Employer
-- Create Company
-- Add Employer to Company

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


