DROP TABLE IF EXISTS hh.users CASCADE;
DROP TYPE IF EXISTS hh.sex_type CASCADE;
DROP TABLE IF EXISTS hh.towns CASCADE;
DROP TABLE IF EXISTS hh.applicants CASCADE;
DROP TYPE IF EXISTS hh.education_type CASCADE;
DROP TABLE IF EXISTS hh.educational_institution CASCADE;
DROP TABLE IF EXISTS hh.faculty CASCADE;
DROP TABLE IF EXISTS hh.speciality CASCADE;
DROP TABLE IF EXISTS hh.education CASCADE;
DROP TABLE IF EXISTS hh.organizations CASCADE;
DROP TABLE IF EXISTS hh.positions CASCADE;
DROP TABLE IF EXISTS hh.experience CASCADE;
DROP TABLE IF EXISTS hh.skills CASCADE;
DROP TYPE IF EXISTS hh.schedule_type CASCADE;
DROP TYPE IF EXISTS hh.resume_status_type CASCADE;
DROP TABLE IF EXISTS hh.resume CASCADE;
DROP TABLE IF EXISTS hh.resume_to_education CASCADE;
DROP TABLE IF EXISTS hh.resume_to_experience CASCADE;
DROP TABLE IF EXISTS hh.resume_to_skills CASCADE;
DROP TABLE IF EXISTS hh.employers CASCADE;
DROP TYPE IF EXISTS hh.vacancy_status_type CASCADE;
DROP TABLE IF EXISTS hh.vacancy CASCADE;
DROP TABLE IF EXISTS hh.vacancy_to_skills CASCADE;
DROP TYPE IF EXISTS hh.talks_status_type CASCADE;
DROP TABLE IF EXISTS hh.talks CASCADE;
DROP TYPE IF EXISTS hh.message_type CASCADE;
DROP TABLE IF EXISTS hh.messages CASCADE;

create table hh.users
(
  user_id          SERIAL PRIMARY KEY,
  email            VARCHAR(50) NOT NULL,
  password         VARCHAR(50) NOT NULL,
  session_password VARCHAR(50)
);

CREATE TYPE hh.sex_type AS ENUM
  (
    'MEN',
    'WOMEN'
    );

CREATE TABLE hh.towns
(
  city_id SERIAL PRIMARY KEY,
  title   varchar(100)
);

CREATE TABLE hh.applicants
(
  user_id  INTEGER NOT NULL PRIMARY KEY REFERENCES hh.users (user_id),
  name     varchar(100),
  sex      hh.sex_type,
  birthday TIMESTAMP,
  city_id  INTEGER REFERENCES hh.towns (city_id)
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
  city_id        INTEGER REFERENCES hh.towns (city_id)
);

CREATE TABLE hh.faculty
(
  faculty_id     SERIAL PRIMARY KEY,
  institution_id INTEGER NOT NULL REFERENCES hh.educational_institution (institution_id),
  name           VARCHAR(100)
);

CREATE TABLE hh.speciality
(
  speciality_id SERIAL PRIMARY KEY,
  faculty_id    INTEGER NOT NULL REFERENCES hh.faculty (faculty_id),
  name          VARCHAR(100)
);

CREATE TABLE hh.education
(
  education_id  SERIAL PRIMARY KEY,
  user_id       INTEGER NOT NULL REFERENCES hh.applicants (user_id),
  level         hh.education_type,
  speciality_id INTEGER REFERENCES hh.speciality (speciality_id),
  year          INTEGER
);

CREATE TABLE hh.organizations
(
  organization_id SERIAL PRIMARY KEY,
  name            VARCHAR(100)
);

CREATE TABLE hh.positions
(
  position_id SERIAL PRIMARY KEY,
  title       VARCHAR(100)
);

CREATE TABLE hh.experience
(
  experience_id   SERIAL PRIMARY KEY,
  user_id         INTEGER NOT NULL REFERENCES hh.applicants (user_id),
  date_begin      TIMESTAMP,
  date_end        TIMESTAMP,
  organization_id INTEGER NOT NULL REFERENCES hh.organizations (organization_id),
  position_id     INTEGER NOT NULL REFERENCES hh.positions (position_id),
  about           TEXT
);

CREATE TABLE hh.skills
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
  user_id     INTEGER NOT NULL REFERENCES hh.applicants (user_id),
  phone       VARCHAR(20),
  position_id INTEGER NOT NULL REFERENCES hh.positions (position_id),
  salary      VARCHAR(20),
  about       TEXT,
  shedule     hh.schedule_type,
  status      hh.resume_status_type
);

CREATE TABLE hh.resume_to_education
(
  resume_id    INTEGER NOT NULL REFERENCES hh.resume (resume_id),
  education_id INTEGER NOT NULL REFERENCES hh.education (education_id),
  PRIMARY KEY (resume_id, education_id)
);

CREATE TABLE hh.resume_to_experience
(
  resume_id     INTEGER NOT NULL REFERENCES hh.resume (resume_id),
  experience_id INTEGER NOT NULL REFERENCES hh.experience (experience_id),
  PRIMARY KEY (resume_id, experience_id)
);

CREATE TABLE hh.resume_to_skills
(
  resume_id INTEGER NOT NULL REFERENCES hh.resume (resume_id),
  skill_id  INTEGER NOT NULL REFERENCES hh.skills (skill_id),
  PRIMARY KEY (resume_id, skill_id)
);

CREATE TABLE hh.employers
(
  user_id         INTEGER NOT NULL PRIMARY KEY REFERENCES hh.users (user_id),
  organization_id INTEGER NOT NULL REFERENCES hh.organizations (organization_id)
);

CREATE TYPE hh.vacancy_status_type AS ENUM
  (
    'OPEN',
    'CLOSE'
    );

CREATE TABLE hh.vacancy
(
  vacancy_id  SERIAL PRIMARY KEY,
  user_id     INTEGER NOT NULL REFERENCES hh.employers (user_id),
  position_id INTEGER NOT NULL REFERENCES hh.positions (position_id),
  city_id     INTEGER NOT NULL REFERENCES hh.towns (city_id),
  salary_from INTEGER,
  salary_to   INTEGER,
  about       TEXT,
  status      hh.vacancy_status_type
);

CREATE TABLE hh.vacancy_to_skills
(
  vacancy_id INTEGER NOT NULL REFERENCES hh.vacancy (vacancy_id),
  skill_id   INTEGER NOT NULL REFERENCES hh.skills (skill_id),
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

CREATE TABLE hh.talks
(
  talk_id    SERIAL PRIMARY KEY,
  resume_id  INTEGER NOT NULL REFERENCES hh.resume (resume_id),
  vacancy_id INTEGER NOT NULL REFERENCES hh.vacancy (vacancy_id),
  status     hh.talks_status_type
);

CREATE TYPE hh.message_type AS ENUM
  (
    'RESUME',
    'VACANCY',
    'TEXT_APP',
    'TEXT_EMP'
    );

CREATE TABLE hh.messages
(
  message_id SERIAL PRIMARY KEY,
  talk_id    INTEGER NOT NULL REFERENCES hh.talks (talk_id),
  send_time  TIMESTAMP,
  type       hh.message_type,
  body       TEXT
);