DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE city (
    city_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

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
    experience INTEGER NOT NULL,
    city_id INTEGER REFERENCES city(city_id) NOT NULL
);

CREATE TABLE applicant (
    applicant_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    login VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    login_timestamp TIMESTAMP NOT NULL,
    logout_timestamp TIMESTAMP NOT NULL
);

CREATE TABLE resume (
    resume_id SERIAL PRIMARY KEY,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL,
    occupation_id INTEGER REFERENCES occupation(occupation_id) NOT NULL,
    text VARCHAR(50) NOT NULL,
    city_id INTEGER REFERENCES city(city_id) NOT NULL
);

CREATE TABLE application (
    application_id SERIAL PRIMARY KEY,
    vacancy_id INTEGER REFERENCES vacancy(vacancy_id) NOT NULL,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL
);

CREATE TABLE invite (
    invite_id SERIAL PRIMARY KEY,
    vacancy_id INTEGER REFERENCES vacancy(vacancy_id) NOT NULL,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL,
    seen BOOLEAN NOT NULL
);

CREATE TABLE experience (
    experience_id SERIAL PRIMARY KEY,
    resume_id INTEGER REFERENCES resume(resume_id) NOT NULL,
    city_id INTEGER REFERENCES city(city_id) NOT NULL,
    start_date DATE NOT NULL,
    finish_date DATE NOT NULL,
    occupation_id INTEGER REFERENCES occupation(occupation_id) NOT NULL
);

CREATE TABLE message (
    message_id SERIAL PRIMARY KEY,
    invite_id INTEGER REFERENCES invite(invite_id),
    text VARCHAR (250) NOT NULL,
    from_employer BOOLEAN NOT NULL,
    time TIMESTAMP NOT NULL,
    seen BOOLEAN NOT NULL
);
