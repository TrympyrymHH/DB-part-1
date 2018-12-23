drop schema headhunter CASCADE ;	
create schema headhunter;	

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.users
(
  id serial NOT NULL PRIMARY KEY,
  login character varying(256) NOT NULL UNIQUE,
  password character varying(256) NOT NULL ,
  date_register timestamp with time zone NOT NULL DEFAULT now(),
  date_last_login timestamp with time zone
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.company
(
  id serial NOT NULL PRIMARY KEY,
  user_id integer REFERENCES headhunter.users (id),
  name character varying(256) NOT NULL ,
  description text,
  path_to_logo text
);

CREATE INDEX ON headhunter.company (user_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.vacancy
(
  id serial NOT NULL PRIMARY KEY ,
  company_id integer REFERENCES headhunter.company (id),
  "position" character varying(512) NOT NULL,
  description text,
  salary_min double precision NOT NULL,
  salary_max double precision,
  wanted_experience text,
  wanted_skills character varying(512)[],
  date_created timestamp with time zone NOT NULL DEFAULT now(),
  date_to_unpublish timestamp with time zone NOT NULL,
  salary_currency character varying(8) NOT NULL
);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.resume
(
  id serial NOT NULL PRIMARY KEY,
  user_id integer REFERENCES headhunter.users (id),
  date_created timestamp with time zone NOT NULL DEFAULT now(),
  date_updated timestamp with time zone NOT NULL DEFAULT now(),
  "position" character varying(512) NOT NULL,
  fio character varying(512) NOT NULL,
  age integer NOT NULL, 
  salary_min double precision NOT NULL,
  salary_max double precision,
  salary_currency character varying(8) NOT NULL,
  skills character varying(512)[]
);


CREATE INDEX ON headhunter.resume (user_id);

-------------------------------------------------------------------------------------------------------------
CREATE TABLE headhunter.resume_experience
(
  id serial NOT NULL PRIMARY KEY,
  resume_id integer REFERENCES headhunter.resume (id),
  date_start timestamp with time zone NOT NULL,
  date_finish timestamp with time zone NOT NULL,
  "position" character varying(512) NOT NULL,
  description text
);

CREATE INDEX ON headhunter.resume_experience (resume_id);

-------------------------------------------------------------------------------------------------------------
drop type message_type ;
create type message_type as ENUM ('invite','reply','message_to_resume', 'message_to_vacancy');

CREATE TABLE headhunter.messages
(
  id serial NOT NULL PRIMARY KEY,
  vacancy_id integer REFERENCES headhunter.vacancy (id),
  resume_id integer REFERENCES headhunter.resume (id),
  article character varying(512) ,
  description text NOT NULL,
  date_create timestamp with time zone NOT NULL DEFAULT now(),
  message_type message_type NOT NULL,
  unread BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE INDEX ON headhunter.messages (message_type);
CREATE INDEX ON headhunter.messages (vacancy_id);
CREATE INDEX ON headhunter.messages (resume_id);

-------------------------------------------------------------------------------------------------------------


