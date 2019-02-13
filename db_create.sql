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

CREATE INDEX ON vacancy(employer_id);
CREATE INDEX ON vacancy(occupation_id);
CREATE INDEX ON vacancy(city_id);

CREATE TABLE applicant (
    applicant_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    login VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    login_timestamp TIMESTAMP NOT NULL,
    logout_timestamp TIMESTAMP
);

CREATE TABLE resume (
    resume_id SERIAL PRIMARY KEY,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL,
    occupation_id INTEGER REFERENCES occupation(occupation_id) NOT NULL,
    text VARCHAR(50) NOT NULL,
    city_id INTEGER REFERENCES city(city_id) NOT NULL
);

CREATE INDEX ON resume(applicant_id);
CREATE INDEX ON resume(occupation_id);
CREATE INDEX ON resume(city_id);

CREATE TABLE request (
    request_id SERIAL PRIMARY KEY,
    is_invite BOOLEAN NOT NULL,
    vacancy_id INTEGER REFERENCES vacancy(vacancy_id) NOT NULL,
    applicant_id INTEGER REFERENCES applicant(applicant_id) NOT NULL,
    seen BOOLEAN NOT NULL
);

CREATE INDEX ON request(vacancy_id);
CREATE INDEX ON request(applicant_id);

CREATE TABLE experience (
    experience_id SERIAL PRIMARY KEY,
    resume_id INTEGER REFERENCES resume(resume_id) NOT NULL,
    city_id INTEGER REFERENCES city(city_id) NOT NULL,
    start_date DATE NOT NULL,
    finish_date DATE,
    occupation_id INTEGER REFERENCES occupation(occupation_id) NOT NULL
);

CREATE TABLE message (
    message_id SERIAL PRIMARY KEY,
    request_id INTEGER REFERENCES request(request_id),
    text VARCHAR (250) NOT NULL,
    from_employer BOOLEAN NOT NULL,
    time TIMESTAMP NOT NULL,
    seen BOOLEAN NOT NULL
);

CREATE INDEX ON message(request_id);
