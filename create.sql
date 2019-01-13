DROP SCHEMA IF EXISTS headhunter CASCADE ;
CREATE SCHEMA headhunter;

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.users
(
  users_id SERIAL PRIMARY KEY,
  login VARCHAR(256) NOT NULL UNIQUE,
  password VARCHAR(256) NOT NULL,
  time_register TIMESTAMP WITH TIME ZONE NOT NULL,
  time_last_login TIMESTAMP WITH TIME ZONE
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.company
(
  company_id SERIAL PRIMARY KEY,
  name VARCHAR(256) NOT NULL ,
  description TEXT,
  path_to_logo TEXT
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.user_to_company_relations
(
  user_to_company_relations_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES headhunter.users (users_id),
  company_id INTEGER REFERENCES headhunter.company (company_id),
  rights INTEGER[],
  time_updated TIMESTAMP WITH TIME ZONE,
  who_update INTEGER
);

CREATE INDEX ON headhunter.user_to_company_relations (user_id);
CREATE INDEX ON headhunter.user_to_company_relations (company_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.user_to_company_rights
(
  user_to_company_rights_id SERIAL PRIMARY KEY,
  name VARCHAR(256),
  description TEXT
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.vacancy
(
  vacancy_id SERIAL PRIMARY KEY,
  company_id INTEGER REFERENCES headhunter.company (company_id),
  "position" VARCHAR(512) NOT NULL,
  description TEXT,
  salary_min DOUBLE PRECISION NOT NULL,
  salary_max DOUBLE PRECISION,
  wanted_experience TEXT,
  wanted_skills VARCHAR(512)[],
  time_created TIMESTAMP WITH TIME ZONE NOT NULL,
  time_to_unpublish TIMESTAMP WITH TIME ZONE NOT NULL,
  salary_currency VARCHAR(8) NOT NULL
);

CREATE INDEX ON headhunter.vacancy (company_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.resume
(
  resume_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES headhunter.users (users_id),
  time_created TIMESTAMP WITH TIME ZONE NOT NULL,
  time_updated TIMESTAMP WITH TIME ZONE,
  "position" VARCHAR(512) NOT NULL,
  fio VARCHAR(512) NOT NULL,
  age INTEGER NOT NULL,
  salary_min DOUBLE PRECISION NOT NULL,
  salary_max DOUBLE PRECISION,
  salary_currency VARCHAR(8) NOT NULL,
  skills VARCHAR(512)[]
);

CREATE INDEX ON headhunter.resume (user_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.resume_experience
(
  resume_experience_id SERIAL PRIMARY KEY,
  resume_id INTEGER REFERENCES headhunter.resume (resume_id),
  time_start TIMESTAMP WITH TIME ZONE NOT NULL,
  time_finish TIMESTAMP WITH TIME ZONE NOT NULL,
  "position" VARCHAR(512) NOT NULL,
  description TEXT
);

CREATE INDEX ON headhunter.resume_experience (resume_id);

-------------------------------------------------------------------------------------------------------------
DROP TYPE IF EXISTS message_type CASCADE;
CREATE TYPE message_type as ENUM ('invite','reply','message_to_resume', 'message_to_vacancy');

CREATE TABLE headhunter.messages
(
  messages_id SERIAL PRIMARY KEY,
  vacancy_id INTEGER REFERENCES headhunter.vacancy (vacancy_id),
  resume_id INTEGER REFERENCES headhunter.resume (resume_id),
  article VARCHAR(512) ,
  description TEXT NOT NULL,
  time_create TIMESTAMP WITH TIME ZONE NOT NULL,
  message_type message_type NOT NULL,
  unread BOOLEAN NOT NULL 
);

CREATE INDEX ON headhunter.messages (message_type);
CREATE INDEX ON headhunter.messages (vacancy_id);
CREATE INDEX ON headhunter.messages (resume_id);

-------------------------------------------------------------------------------------------------------------


