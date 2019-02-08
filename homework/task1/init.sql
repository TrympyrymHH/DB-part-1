CREATE TYPE EMPLOYMENT_TYPE AS ENUM ('full-time', 'part-time', 'remote');
CREATE TYPE SPHERE AS ENUM ('IT', 'Marketing', 'Education', 'Entrepreneurship', 'Insurance', 'Social');
CREATE TYPE CV_STATUS AS ENUM ('VISIBLE', 'HIDDEN', 'ARCHIVE', 'DELETED');
CREATE TYPE VACANCY_STATUS AS ENUM ('OPEN', 'CLOSED', 'ARCHIVE', 'DELETED');
CREATE TYPE RESPONSE_STATUS AS ENUM ('NEW', 'READ', 'ACCEPTED', 'REJECTED');
CREATE TYPE MESSAGE_TYPE AS ENUM ('SEND', 'RECEIVE');


CREATE TABLE account(
    account_id SERIAL PRIMARY KEY,
    account_login TEXT,
    account_password_hash TEXT
);

CREATE TABLE employee(
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES account(id)
);

CREATE TABLE cv(
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employee(id),
    cv_status CV_STATUS,
    cv_name TEXT,
    full_name TEXT,
    photo_url TEXT,
    salary INTEGER,
    place TEXT,
    employment_type EMPLOYMENT_TYPE[],
    spheres SPHERE[],
    skills TEXT[],
    about_me TEXT,
    contact_info TEXT
);

CREATE TABLE cv_job(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id)
    date_from DATE,
    date_upto DATE,
    job_company TEXT,
    job_position TEXT,
    job_description TEXT
);

CREATE TABLE cv_education(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id)
    date_from DATE,
    date_upto DATE,
    education_place TEXT,
    education_specialty TEXT,
    education_description TEXT
);

CREATE TABLE cv_certificates(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id)
    date_from DATE,
    date_upto DATE,
    certificate_name TEXT,
    certificate_description TEXT
);

CREATE TABLE company(
    id SERIAL PRIMARY KEY,
    company_name TEXT,
    company_description TEXT,
    company_url TEXT,
);

CREATE TABLE employer(
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES company(id),
    full_name TEXT,
    photo_url TEXT,
    contact_info TEXT
);

CREATE TABLE vacancy(
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES company(id),
    vacancy_status VACANCY_STATUS,
    vacancy_name TEXT,
    vacancy_description TEXT,
    salary_min INTEGER,
    salary_max INTEGER,
    place TEXT,
    employment_type EMPLOYMENT_TYPE[],
    spheres SPHERE[],
    skills TEXT[],
    contact_info TEXT
);

CREATE TABLE response(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id),
    vacancy_id INTEGER REFERENCES vacancy(id),
    employer_id INTEGER REFERENCES employer(id),
    response_status RESPONSE_STATUS
);

CREATE TABLE messages(
    id SERIAL PRIMARY KEY,
    response_id INTEGER REFERENCES response(id),
    message_type MESSAGE_TYPE,
    message_text TEXT
);