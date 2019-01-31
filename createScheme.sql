DROP SCHEMA IF EXISTS hh CASCADE;
CREATE SCHEMA hh;


CREATE TABLE hh.user
(
	user_id SERIAL PRIMARY KEY,
	login VARCHAR(256) UNIQUE NOT NULL,
	password VARCHAR(256) UNIQUE NOT NULL,
	time_of_register TIMESTAMP WITH TIME ZONE,
	time_of_last_login TIMESTAMP WITH TIME ZONE
);


CREATE TABLE hh.company
(
	company_id SERIAL PRIMARY KEY,
	name VARCHAR(256) NOT NULL
);


CREATE TABLE hh.user_company
(
	user_company_id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES hh.user(user_id),
	company_id INTEGER REFERENCES hh.company(company_id),
	position VARCHAR(256)
);


CREATE TABLE hh.vacancy
(
	vacancy_id SERIAL PRIMARY KEY,
	company_id INTEGER REFERENCES hh.company(company_id),
	position VARCHAR(256) NOT NULL,
	description TEXT,
	salary_min INTEGER,
	salary_max INTEGER,
	required_exp TEXT,
	required_skills TEXT
);


CREATE TABLE hh.resume
(
	resume_id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES hh.user(user_id),
	full_name VARCHAR(256) NOT NULL,
	birthday DATE NOT NULL,
	salary_min INTEGER,
	salary_max INTEGER,
	skills TEXT
);


CREATE TABLE hh.experience
(
	experience_id SERIAL PRIMARY KEY,
	resume_id INTEGER REFERENCES hh.resume(resume_id),
	company_id INTEGER REFERENCES hh.company(company_id),
	position VARCHAR(256),
	description TEXT
);


CREATE TABLE hh.response
(
	response_id SERIAL PRIMARY KEY,
	vacancy_id INTEGER REFERENCES hh.vacancy(vacancy_id),
	resume_id INTEGER REFERENCES hh.resume(resume_id),
	header VARCHAR(256),
	message TEXT NOT NULL
);
