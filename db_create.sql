DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE occupation (
    id serial PRIMARY KEY,
    name varchar (50) NOT NULL
);


CREATE TABLE employer (
    id serial PRIMARY KEY,
    name varchar (50) NOT NULL
);

CREATE TABLE vacancy (
    id serial PRIMARY KEY,
    text varchar (50) NOT NULL,
    employer_id integer REFERENCES employer(id),
    occupation_id integer REFERENCES occupation(id),
    skill integer NOT NULL
);

CREATE TABLE worker (
    id serial PRIMARY KEY,
    name varchar (50) NOT NULL
);

CREATE TABLE resume (
    id serial PRIMARY KEY,
    worker_id integer REFERENCES worker(id),
    occupation_id integer REFERENCES occupation(id),
    text varchar (50) NOT NULL,
    skill integer NOT NULL
);

CREATE TABLE application (
    id serial PRIMARY KEY,
    vacancy_id integer REFERENCES vacancy(id),
    worker_id integer REFERENCES worker(id)
);

CREATE TABLE invite (
    id serial PRIMARY KEY,
    vacancy_id integer REFERENCES vacancy(id),
    worker_id integer REFERENCES worker(id)
);

