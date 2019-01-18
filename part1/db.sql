DROP TABLE IF EXISTS hh.account CASCADE;
DROP TYPE IF EXISTS hh.gender CASCADE;
DROP TABLE IF EXISTS hh.city CASCADE;
DROP TABLE IF EXISTS hh.applicant CASCADE;
DROP TYPE IF EXISTS hh.education_type CASCADE;
DROP TABLE IF EXISTS hh.educational_institution CASCADE;
DROP TABLE IF EXISTS hh.faculty CASCADE;
DROP TABLE IF EXISTS hh.speciality CASCADE;
DROP TABLE IF EXISTS hh.education CASCADE;
DROP TABLE IF EXISTS hh.organization CASCADE;
DROP TABLE IF EXISTS hh.position CASCADE;
DROP TABLE IF EXISTS hh.experience CASCADE;
DROP TABLE IF EXISTS hh.skill CASCADE;
DROP TYPE IF EXISTS hh.schedule_type CASCADE;
DROP TYPE IF EXISTS hh.resume_status_type CASCADE;
DROP TABLE IF EXISTS hh.resume CASCADE;
DROP TABLE IF EXISTS hh.resume_to_education CASCADE;
DROP TABLE IF EXISTS hh.resume_to_experience CASCADE;
DROP TABLE IF EXISTS hh.resume_to_skill CASCADE;
DROP TABLE IF EXISTS hh.employer CASCADE;
DROP TYPE IF EXISTS hh.vacancy_status_type CASCADE;
DROP TABLE IF EXISTS hh.vacancy CASCADE;
DROP TABLE IF EXISTS hh.vacancy_to_skill CASCADE;
DROP TYPE IF EXISTS hh.talks_status_type CASCADE;
DROP TABLE IF EXISTS hh.talk CASCADE;
DROP TYPE IF EXISTS hh.message_type CASCADE;
DROP TABLE IF EXISTS hh.message CASCADE;

CREATE TABLE hh.account
(
  account_id       SERIAL PRIMARY KEY,
  email            VARCHAR(50) NOT NULL,
  password         VARCHAR(50) NOT NULL,
  session_password VARCHAR(50)
);

CREATE TYPE hh.gender AS ENUM
  (
    'MAN',
    'WOMAN'
    );

CREATE TABLE hh.city
(
  city_id SERIAL PRIMARY KEY,
  title   varchar(100)
);

CREATE TABLE hh.applicant
(
  account_id INTEGER NOT NULL PRIMARY KEY REFERENCES hh.account,
  name       varchar(100),
  sex        hh.gender,
  birthday   TIMESTAMP,
  city_id    INTEGER REFERENCES hh.city
);

CREATE TYPE hh.education_type AS ENUM
  (
    'PRESCHOOL',
    'ELEMENTARY_SCHOOL',
    'BASIC_SCHOOL',
    'AVERAGE_SCHOOL',
    'AVERAGE_PROFESSIONAL',
    'BACHELOR',
    'MASTER',
    'SPECIALIST',
    'TOP_SKILLS'
    );

CREATE TABLE hh.educational_institution
(
  institution_id SERIAL PRIMARY KEY,
  short_name     VARCHAR(20),
  name           VARCHAR(100),
  city_id        INTEGER REFERENCES hh.city
);

CREATE TABLE hh.faculty
(
  faculty_id     SERIAL PRIMARY KEY,
  institution_id INTEGER NOT NULL REFERENCES hh.educational_institution,
  name           VARCHAR(100)
);

CREATE TABLE hh.speciality
(
  speciality_id SERIAL PRIMARY KEY,
  faculty_id    INTEGER NOT NULL REFERENCES hh.faculty,
  name          VARCHAR(100)
);

CREATE TABLE hh.education
(
  education_id  SERIAL PRIMARY KEY,
  account_id    INTEGER NOT NULL REFERENCES hh.applicant,
  level         hh.education_type,
  speciality_id INTEGER REFERENCES hh.speciality,
  year          INTEGER
);

CREATE TABLE hh.organization
(
  organization_id SERIAL PRIMARY KEY,
  name            VARCHAR(100)
);

CREATE TABLE hh.position
(
  position_id SERIAL PRIMARY KEY,
  title       VARCHAR(100)
);

CREATE TABLE hh.experience
(
  experience_id   SERIAL PRIMARY KEY,
  account_id      INTEGER NOT NULL REFERENCES hh.applicant,
  date_begin      TIMESTAMP,
  date_end        TIMESTAMP,
  organization_id INTEGER NOT NULL REFERENCES hh.organization,
  position_id     INTEGER NOT NULL REFERENCES hh.position,
  about           TEXT
);

CREATE TABLE hh.skill
(
  skill_id SERIAL PRIMARY KEY,
  title    VARCHAR(50)
);

CREATE TYPE hh.schedule_type AS ENUM
  (
    'FULL_DAY',
    'REPLACEABLE',
    'FLEXIBLE',
    'DISTANT',
    'SHIFT_METHOD'
    );

CREATE TYPE hh.resume_status_type AS ENUM
  (
    'SHOW',
    'HIDE'
    );

CREATE TABLE hh.resume
(
  resume_id   SERIAL PRIMARY KEY,
  account_id  INTEGER NOT NULL REFERENCES hh.applicant,
  phone       VARCHAR(20),
  position_id INTEGER NOT NULL REFERENCES hh.position,
  salary      VARCHAR(20),
  about       TEXT,
  shedule     hh.schedule_type,
  status      hh.resume_status_type
);

CREATE TABLE hh.resume_to_education
(
  resume_id    INTEGER NOT NULL REFERENCES hh.resume,
  education_id INTEGER NOT NULL REFERENCES hh.education,
  PRIMARY KEY (resume_id, education_id)
);

CREATE TABLE hh.resume_to_experience
(
  resume_id     INTEGER NOT NULL REFERENCES hh.resume,
  experience_id INTEGER NOT NULL REFERENCES hh.experience,
  PRIMARY KEY (resume_id, experience_id)
);

CREATE TABLE hh.resume_to_skill
(
  resume_id INTEGER NOT NULL REFERENCES hh.resume,
  skill_id  INTEGER NOT NULL REFERENCES hh.skill,
  PRIMARY KEY (resume_id, skill_id)
);

CREATE TABLE hh.employer
(
  account_id      INTEGER NOT NULL PRIMARY KEY REFERENCES hh.account,
  organization_id INTEGER NOT NULL REFERENCES hh.organization
);

CREATE TYPE hh.vacancy_status_type AS ENUM
  (
    'OPEN',
    'CLOSE'
    );

CREATE TABLE hh.vacancy
(
  vacancy_id  SERIAL PRIMARY KEY,
  account_id  INTEGER NOT NULL REFERENCES hh.employer,
  position_id INTEGER NOT NULL REFERENCES hh.position,
  city_id     INTEGER NOT NULL REFERENCES hh.city,
  salary_from INTEGER,
  salary_to   INTEGER,
  about       TEXT,
  status      hh.vacancy_status_type
);

CREATE TABLE hh.vacancy_to_skill
(
  vacancy_id INTEGER NOT NULL REFERENCES hh.vacancy,
  skill_id   INTEGER NOT NULL REFERENCES hh.skill,
  PRIMARY KEY (vacancy_id, skill_id)
);

CREATE TYPE hh.talks_status_type AS ENUM
  (
    'OPEN',
    'DECLINE',
    'ACCEPT_APP',
    'ACCEPT_EMP',
    'ACCEPT'
    );

CREATE TABLE hh.talk
(
  talk_id    SERIAL PRIMARY KEY,
  resume_id  INTEGER NOT NULL REFERENCES hh.resume,
  vacancy_id INTEGER NOT NULL REFERENCES hh.vacancy,
  status     hh.talks_status_type
);

CREATE TYPE hh.message_type AS ENUM
  (
    'RESUME',
    'VACANCY',
    'TEXT_APP',
    'TEXT_EMP'
    );

CREATE TABLE hh.message
(
  message_id SERIAL PRIMARY KEY,
  talk_id    INTEGER NOT NULL REFERENCES hh.talk,
  send_time  TIMESTAMP,
  type       hh.message_type,
  body       TEXT
);