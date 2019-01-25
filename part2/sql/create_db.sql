DROP TABLE IF EXISTS hh_import.account CASCADE;
DROP TABLE IF EXISTS hh_import.resume CASCADE;
DROP TABLE IF EXISTS hh_import.experience CASCADE;
DROP TABLE IF EXISTS hh_import.employer CASCADE;
DROP TABLE IF EXISTS hh_import.employer_account CASCADE;
DROP TABLE IF EXISTS hh_import.vacancy CASCADE;
DROP TABLE IF EXISTS hh_import.message CASCADE;

CREATE TABLE hh_import.account
(
  account_id SERIAL PRIMARY KEY,
  email      VARCHAR(50) NOT NULL,
  password   VARCHAR(50) NOT NULL
);

CREATE TABLE hh_import.resume
(
  resume_id        SERIAL PRIMARY KEY,
  account_id       INTEGER NOT NULL REFERENCES hh_import.account,
  name             VARCHAR(100),
  city             VARCHAR(100),
  position         VARCHAR(100),
  shedule          hh.SCHEDULE_TYPE,
  education_level  hh.EDUCATION_TYPE,
  experience_years hh.EXPERIENCE_YEARS,
  salary           INTEGER,
  about            TEXT,
  status           hh.RESUME_STATUS
);

CREATE TABLE hh_import.experience
(
  experience_id     SERIAL PRIMARY KEY,
  resume_id         INTEGER NOT NULL REFERENCES hh_import.resume,
  date_begin        DATE    NOT NULL,
  date_end          DATE,
  organization_name VARCHAR(100),
  position          VARCHAR(100),
  about             TEXT
);

CREATE TABLE hh_import.employer
(
  employer_id       SERIAL PRIMARY KEY,
  organization_name VARCHAR(100) NOT NULL
);

CREATE TABLE hh_import.employer_account
(
  employer_id INTEGER NOT NULL REFERENCES hh_import.employer,
  account_id  INTEGER NOT NULL REFERENCES hh_import.account,
  PRIMARY KEY (employer_id, account_id)
);

CREATE TABLE hh_import.vacancy
(
  vacancy_id       SERIAL PRIMARY KEY,
  employer_id      INTEGER NOT NULL REFERENCES hh_import.employer,
  city             VARCHAR(100),
  position         VARCHAR(100),
  shedule          hh.SCHEDULE_TYPE,
  education_level  hh.EDUCATION_TYPE,
  experience_years hh.EXPERIENCE_YEARS,
  salary_from      INTEGER,
  salary_to        INTEGER,
  about            TEXT,
  status           hh.VACANCY_STATUS
);

CREATE TABLE hh_import.message
(
  message_id SERIAL PRIMARY KEY,
  resume_id  INTEGER NOT NULL REFERENCES hh_import.resume,
  vacancy_id INTEGER NOT NULL REFERENCES hh_import.vacancy,
  account_id INTEGER REFERENCES hh_import.account,
  send_time  TIMESTAMP,
  type       hh.MESSAGE_TYPE,
  body       TEXT,
  view       BOOLEAN NOT NULL
);
