-- Cleanup

DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS response;
DROP TABLE IF EXISTS vacancy;
DROP TABLE IF EXISTS employer;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS cv_job;
DROP TABLE IF EXISTS cv_education;
DROP TABLE IF EXISTS cv_certificates;
DROP TABLE IF EXISTS cv;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS account;

DROP TYPE EMPLOYMENT_TYPE;
DROP TYPE SPHERE;
DROP TYPE CV_STATUS;
DROP TYPE VACANCY_STATUS;
DROP TYPE RESPONSE_STATUS;
DROP TYPE RESPONSE_SOURCE;
DROP TYPE MESSAGE_TYPE;

-- Create

CREATE TYPE EMPLOYMENT_TYPE AS ENUM ('full-time', 'part-time', 'remote');
CREATE TYPE SPHERE AS ENUM ('IT', 'Marketing', 'Education', 'Entrepreneurship', 'Insurance', 'Social');
CREATE TYPE CV_STATUS AS ENUM ('VISIBLE', 'HIDDEN', 'ARCHIVE', 'DELETED');
CREATE TYPE VACANCY_STATUS AS ENUM ('OPEN', 'CLOSED', 'ARCHIVE', 'DELETED');
CREATE TYPE RESPONSE_STATUS AS ENUM ('NEW', 'READ', 'ACCEPTED', 'REJECTED');
CREATE TYPE RESPONSE_SOURCE AS ENUM ('EMPLOYEE', 'EMPLOYER');
CREATE TYPE MESSAGE_TYPE AS ENUM ('SEND', 'RECEIVE');


CREATE TABLE account(
    id SERIAL PRIMARY KEY,
    account_login TEXT UNIQUE NOT NULL,
    account_password_hash TEXT NOT NULL
);

CREATE TABLE employee(
    id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES account(id)
);

CREATE TABLE cv(
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employee(id) NOT NULL,
    cv_status CV_STATUS NOT NULL,
    cv_name TEXT NOT NULL,
    full_name TEXT NOT NULL,
    photo_url TEXT,
    salary INTEGER,
    place TEXT,
    employment_type EMPLOYMENT_TYPE[],
    spheres SPHERE[],
    skills TEXT[],
    about_me TEXT,
    contact_info TEXT,
    created_timestamp TIMESTAMP,
    refreshed_timestamp TIMESTAMP
);

CREATE TABLE cv_job(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id) NOT NULL,
    date_from DATE,
    date_upto DATE,
    job_company TEXT NOT NULL,
    job_position TEXT NOT NULL,
    job_description TEXT
);

CREATE TABLE cv_education(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id) NOT NULL,
    date_from DATE,
    date_upto DATE,
    education_place TEXT NOT NULL,
    education_specialty TEXT NOT NULL,
    education_description TEXT
);

CREATE TABLE cv_certificates(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id) NOT NULL,
    date_from DATE,
    date_upto DATE,
    certificate_name TEXT NOT NULL,
    certificate_description TEXT
);

CREATE TABLE company(
    id SERIAL PRIMARY KEY,
    company_name TEXT NOT NULL,
    company_description TEXT,
    company_url TEXT
);

CREATE TABLE employer(
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES company(id),
    full_name TEXT NOT NULL,
    photo_url TEXT,
    contact_info TEXT
);

CREATE TABLE vacancy(
    id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES company(id) NOT NULL,
    vacancy_status VACANCY_STATUS NOT NULL,
    vacancy_name TEXT NOT NULL,
    vacancy_description TEXT NOT NULL,
    salary_min INTEGER,
    salary_max INTEGER,
    place TEXT,
    employment_type EMPLOYMENT_TYPE[],
    spheres SPHERE[],
    skills TEXT[],
    contact_info TEXT,
    created_timestamp TIMESTAMP NOT NULL,
    refreshed_timestamp TIMESTAMP
);

CREATE TABLE response(
    id SERIAL PRIMARY KEY,
    cv_id INTEGER REFERENCES cv(id) NOT NULL,
    vacancy_id INTEGER REFERENCES vacancy(id) NOT NULL,
    employer_id INTEGER REFERENCES employer(id),
    response_source RESPONSE_SOURCE NOT NULL,
    response_status RESPONSE_STATUS NOT NULL,
    created_timestamp TIMESTAMP NOT NULL,
    status_changed_timestamp TIMESTAMP
);

CREATE TABLE messages(
    id SERIAL PRIMARY KEY,
    response_id INTEGER REFERENCES response(id),
    message_timestamp TIMESTAMP,
    message_type MESSAGE_TYPE,
    message_text TEXT
);