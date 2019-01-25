DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE occupation (
    occupation_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);


CREATE TABLE employer (
    employer_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE vacancy (
    vacancy_id SERIAL PRIMARY KEY,
    text VARCHAR(50) NOT NULL,
    employer_id INTEGER REFERENCES employer(employer_id) NOT NULL,
    occupation_id INTEGER REFERENCES occupation(occupation_id) NOT NULL,
    experience INTEGER NOT NULL
);

CREATE TABLE applicant (
    applicant_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE resume (
    resume_id SERIAL PRIMARY KEY,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL,
    occupation_id INTEGER REFERENCES occupation(occupation_id) NOT NULL,
    text VARCHAR(50) NOT NULL,
    experience INTEGER NOT NULL
);

CREATE TABLE application (
    application_id SERIAL PRIMARY KEY,
    vacancy_id INTEGER REFERENCES vacancy(vacancy_id) NOT NULL,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL
);

CREATE TABLE invite (
    invite_id SERIAL PRIMARY KEY,
    vacancy_id INTEGER REFERENCES vacancy(vacancy_id) NOT NULL,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL
);

