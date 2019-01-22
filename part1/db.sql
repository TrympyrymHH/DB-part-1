DROP TABLE IF EXISTS hh.account CASCADE;
DROP TYPE IF EXISTS hh.EDUCATION_TYPE CASCADE;
DROP TYPE IF EXISTS hh.SCHEDULE_TYPE CASCADE;
DROP TABLE IF EXISTS hh.resume CASCADE;
DROP TABLE IF EXISTS hh.employer CASCADE;
DROP TABLE IF EXISTS hh.employer_account CASCADE;
DROP TYPE IF EXISTS hh.VACANCY_STATUS CASCADE;
DROP TABLE IF EXISTS hh.vacancy CASCADE;
DROP TYPE IF EXISTS hh.MESSAGE_TYPE CASCADE;
DROP TABLE IF EXISTS hh.message CASCADE;

CREATE TABLE hh.account
(
  account_id SERIAL PRIMARY KEY,
  email      VARCHAR(50) NOT NULL,
  password   VARCHAR(50) NOT NULL
);

CREATE TYPE hh.EDUCATION_TYPE AS ENUM
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

CREATE TYPE hh.SCHEDULE_TYPE AS ENUM
  (
    'FULL_DAY',
    'REPLACEABLE',
    'FLEXIBLE',
    'DISTANT',
    'SHIFT_METHOD'
    );

CREATE TABLE hh.resume
(
  resume_id        SERIAL PRIMARY KEY,
  account_id       INTEGER NOT NULL REFERENCES hh.account,
  name             VARCHAR(100),
  city             VARCHAR(100),
  position         VARCHAR(100),
  shedule          hh.SCHEDULE_TYPE,
  education_level  hh.EDUCATION_TYPE,
  experience_years INTEGER,
  salary           INTEGER,
  about            TEXT
);

CREATE TABLE hh.employer
(
  employer_id       SERIAL PRIMARY KEY,
  organization_name VARCHAR(100) NOT NULL
);

CREATE TABLE hh.employer_account
(
  employer_id INTEGER NOT NULL REFERENCES hh.employer,
  account_id  INTEGER NOT NULL REFERENCES hh.account,
  PRIMARY KEY (employer_id, account_id)
);

CREATE TYPE hh.VACANCY_STATUS AS ENUM
  (
    'OPEN',
    'CLOSE'
    );

CREATE TABLE hh.vacancy
(
  vacancy_id       SERIAL PRIMARY KEY,
  employer_id      INTEGER NOT NULL REFERENCES hh.employer,
  city             VARCHAR(100),
  position         VARCHAR(100),
  shedule          hh.SCHEDULE_TYPE,
  education_level  hh.EDUCATION_TYPE,
  experience_years INTEGER,
  salary_from      INTEGER,
  salary_to        INTEGER,
  about            TEXT,
  status           hh.VACANCY_STATUS
);

CREATE TYPE hh.MESSAGE_TYPE AS ENUM
  (
    'RESUME',
    'VACANCY',
    'TEXT_APP',
    'TEXT_EMP'
    );

CREATE TABLE hh.message
(
  message_id SERIAL PRIMARY KEY,
  resume_id  INTEGER NOT NULL REFERENCES hh.resume,
  vacancy_id INTEGER NOT NULL REFERENCES hh.vacancy,
  account_id INTEGER NOT NULL REFERENCES hh.account,
  send_time  TIMESTAMP,
  type       hh.MESSAGE_TYPE,
  body       TEXT,
  view       BOOLEAN NOT NULL
);
