DROP SCHEMA IF EXISTS headhunter CASCADE ;
CREATE SCHEMA headhunter;

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.account
(
  account_id SERIAL PRIMARY KEY,
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
CREATE TABLE headhunter.account_to_company_relation
(
  account_to_company_relation_id SERIAL PRIMARY KEY,
  account_id INTEGER REFERENCES headhunter.account (account_id),
  company_id INTEGER REFERENCES headhunter.company (company_id),
  rights INTEGER[],
  time_updated TIMESTAMP WITH TIME ZONE,
  who_update INTEGER
);

CREATE INDEX ON headhunter.account_to_company_relation (account_id);
CREATE INDEX ON headhunter.account_to_company_relation (company_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.acc_to_comp_permission
(
  acc_to_comp_permission_id SERIAL PRIMARY KEY,
  name VARCHAR(256),
  description TEXT
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.skill
(
  skill_id SERIAL PRIMARY KEY,
  name VARCHAR(256)
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.vacancy
(
  vacancy_id SERIAL PRIMARY KEY,
  company_id INTEGER REFERENCES headhunter.company (company_id),
  position VARCHAR(512) NOT NULL,
  description TEXT,
  salary_min INTEGER NOT NULL,
  salary_max INTEGER,
  wanted_experience TEXT,
  wanted_skill_ids INTEGER [],
  time_created TIMESTAMP WITH TIME ZONE NOT NULL,
  time_to_unpublish TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX ON headhunter.vacancy (company_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.resume
(
  resume_id SERIAL PRIMARY KEY,
  account_id INTEGER REFERENCES headhunter.account (account_id),
  time_created TIMESTAMP WITH TIME ZONE NOT NULL,
  time_updated TIMESTAMP WITH TIME ZONE,
  position VARCHAR(512) NOT NULL,
  fio VARCHAR(512) NOT NULL,
  birthday DATE NOT NULL,
  salary_min INTEGER NOT NULL,
  salary_max INTEGER ,
  skill_ids INTEGER []
);

CREATE INDEX ON headhunter.resume (account_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.resume_experience
(
  resume_experience_id SERIAL PRIMARY KEY,
  resume_id INTEGER REFERENCES headhunter.resume (resume_id),
  date_start DATE NOT NULL,
  date_finish DATE NOT NULL,
  company_name VARCHAR(512) NOT NULL,
  position VARCHAR(512) NOT NULL,
  description TEXT
);

CREATE INDEX ON headhunter.resume_experience (resume_id);

-------------------------------------------------------------------------------------------------------------
DROP TYPE IF EXISTS message_type CASCADE;
CREATE TYPE public.message_type as ENUM ('INVITE','REPLY','MESSAGE_TO_RESUME', 'MESSAGE_TO_VACANCY');

CREATE TABLE headhunter.message
(
  message_id SERIAL PRIMARY KEY,
  vacancy_id INTEGER REFERENCES headhunter.vacancy (vacancy_id),
  resume_id INTEGER REFERENCES headhunter.resume (resume_id),
  article VARCHAR(512) ,
  description TEXT NOT NULL,
  time_create TIMESTAMP WITH TIME ZONE NOT NULL,
  message_type public.message_type NOT NULL,
  unread BOOLEAN NOT NULL 
);

CREATE INDEX ON headhunter.message (message_type);
CREATE INDEX ON headhunter.message (vacancy_id);
CREATE INDEX ON headhunter.message (resume_id);

-------------------------------------------------------------------------------------------------------------
