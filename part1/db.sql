DROP TABLE IF EXISTS hh.account CASCADE;
DROP TYPE IF EXISTS hh.GENDER CASCADE;
DROP TABLE IF EXISTS hh.applicant CASCADE;
DROP TYPE IF EXISTS hh.EDUCATION_TYPE CASCADE;
DROP TABLE IF EXISTS hh.educational_institution CASCADE;
DROP TABLE IF EXISTS hh.faculty CASCADE;
DROP TABLE IF EXISTS hh.speciality CASCADE;
DROP TABLE IF EXISTS hh.education CASCADE;
DROP TABLE IF EXISTS hh.position CASCADE;
DROP TABLE IF EXISTS hh.experience CASCADE;
DROP TABLE IF EXISTS hh.skill CASCADE;
DROP TYPE IF EXISTS hh.SCHEDULE_TYPE CASCADE;
DROP TYPE IF EXISTS hh.RESUME_STATUS CASCADE;
DROP TABLE IF EXISTS hh.resume CASCADE;
DROP TABLE IF EXISTS hh.resume_education CASCADE;
DROP TABLE IF EXISTS hh.resume_experience CASCADE;
DROP TABLE IF EXISTS hh.resume_skill CASCADE;
DROP TABLE IF EXISTS hh.employer CASCADE;
DROP TABLE IF EXISTS hh.employer_account CASCADE;
DROP TYPE IF EXISTS hh.VACANCY_STATUS CASCADE;
DROP TABLE IF EXISTS hh.vacancy CASCADE;
DROP TABLE IF EXISTS hh.vacancy_skill CASCADE;
DROP TYPE IF EXISTS hh.MESSAGE_TYPE CASCADE;
DROP TABLE IF EXISTS hh.message CASCADE;

CREATE TABLE hh.account
(
  account_id       SERIAL PRIMARY KEY,
  email            VARCHAR(50) NOT NULL,
  password         VARCHAR(50) NOT NULL,
  session_password VARCHAR(50)
);

CREATE TYPE hh.GENDER AS ENUM
  (
    'MAN',
    'WOMAN'
    );

CREATE TABLE hh.applicant
(
  account_id INTEGER NOT NULL PRIMARY KEY REFERENCES hh.account,
  name       VARCHAR(100),
  gender     hh.GENDER,
  birthday   DATE,
  city       VARCHAR(100)
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

CREATE TABLE hh.educational_institution
(
  institution_id SERIAL PRIMARY KEY,
  short_name     VARCHAR(20),
  name           VARCHAR(100),
  city           VARCHAR(100)
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
  applicant_id  INTEGER NOT NULL REFERENCES hh.applicant (account_id),
  level         hh.EDUCATION_TYPE,
  speciality_id INTEGER REFERENCES hh.speciality,
  year          INTEGER
);

CREATE TABLE hh.position
(
  position_id SERIAL PRIMARY KEY,
  title       VARCHAR(100)
);

CREATE TABLE hh.experience
(
  experience_id     SERIAL PRIMARY KEY,
  applicant_id      INTEGER NOT NULL REFERENCES hh.applicant (account_id),
  date_begin        DATE    NOT NULL,
  date_end          DATE,
  organization_name VARCHAR(100),
  position_id       INTEGER NOT NULL REFERENCES hh.position,
  about             TEXT
);

CREATE TABLE hh.skill
(
  skill_id SERIAL PRIMARY KEY,
  title    VARCHAR(50)
);

CREATE TYPE hh.SCHEDULE_TYPE AS ENUM
  (
    'FULL_DAY',
    'REPLACEABLE',
    'FLEXIBLE',
    'DISTANT',
    'SHIFT_METHOD'
    );

CREATE TYPE hh.RESUME_STATUS AS ENUM
  (
    'SHOW',
    'HIDE'
    );

CREATE TABLE hh.resume
(
  resume_id    SERIAL PRIMARY KEY,
  applicant_id INTEGER NOT NULL REFERENCES hh.applicant (account_id),
  phone        VARCHAR(20),
  position_id  INTEGER NOT NULL REFERENCES hh.position,
  salary       INTEGER,
  about        TEXT,
  shedule      hh.SCHEDULE_TYPE,
  status       hh.RESUME_STATUS
);

CREATE TABLE hh.resume_education
(
  resume_id    INTEGER NOT NULL REFERENCES hh.resume,
  education_id INTEGER NOT NULL REFERENCES hh.education,
  PRIMARY KEY (resume_id, education_id)
);

CREATE TABLE hh.resume_experience
(
  resume_id     INTEGER NOT NULL REFERENCES hh.resume,
  experience_id INTEGER NOT NULL REFERENCES hh.experience,
  PRIMARY KEY (resume_id, experience_id)
);

CREATE TABLE hh.resume_skill
(
  resume_id INTEGER NOT NULL REFERENCES hh.resume,
  skill_id  INTEGER NOT NULL REFERENCES hh.skill,
  PRIMARY KEY (resume_id, skill_id)
);

CREATE TABLE hh.employer
(
  employer_id       SERIAL PRIMARY KEY,
  organization_name VARCHAR(100)
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
  vacancy_id  SERIAL PRIMARY KEY,
  employer_id INTEGER NOT NULL REFERENCES hh.employer,
  position_id INTEGER NOT NULL REFERENCES hh.position,
  city        VARCHAR(100),
  salary_from INTEGER,
  salary_to   INTEGER,
  about       TEXT,
  status      hh.VACANCY_STATUS
);

CREATE TABLE hh.vacancy_skill
(
  vacancy_id INTEGER NOT NULL REFERENCES hh.vacancy,
  skill_id   INTEGER NOT NULL REFERENCES hh.skill,
  PRIMARY KEY (vacancy_id, skill_id)
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