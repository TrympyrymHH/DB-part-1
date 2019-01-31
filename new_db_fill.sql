CREATE TABLE new_city (
    city_id INTEGER,
    name VARCHAR(50)
);

INSERT INTO new_city(city_id, name) SELECT id, 'city' || id FROM generate_series(1, 1000) as c(id);


CREATE TABLE new_occupation (
    occupation_id INTEGER,
    name VARCHAR(50)
);

INSERT INTO new_occupation(occupation_id, name) SELECT id, 'occupation' || id FROM generate_series(1, 1000) as occ(id);


CREATE TABLE new_employer (
    employer_id INTEGER,
    name VARCHAR(50)
);

INSERT INTO new_employer(employer_id, name) SELECT id, 'employer' || id FROM generate_series(1, 1000) as e(id);


CREATE TABLE new_vacancy (
    vacancy_id INTEGER,
    text VARCHAR(50),
    employer_id INTEGER,
    occupation_id INTEGER,
    experience INTEGER,
    city_id INTEGER
);

INSERT INTO new_vacancy(vacancy_id, text, employer_id, occupation_id, experience, city_id) 
        SELECT id, 'vacancy' || id, ROUND(1 + RANDOM() * 999), ROUND(1 + RANDOM() * 999), ROUND(1 + RANDOM() * 4), ROUND(1 + RANDOM() * 999) 
        FROM generate_series(1, 1000000) as v(id);


CREATE TABLE new_applicant (
    applicant_id INTEGER,
    name VARCHAR(50),
    login VARCHAR(50),
    password VARCHAR(50),
    login_timestamp TIMESTAMP,
    logout_timestamp TIMESTAMP
);

INSERT INTO new_applicant(applicant_id, name, login, password, login_timestamp, logout_timestamp) 
        SELECT id, 'applicant' || id, 'login' || id, 'password' || id, '2019-01-30 11:00:00'::timestamp + id * interval '5 sec', NULL
        FROM generate_series(1, 1000) as a(id);


CREATE TABLE new_resume (
    resume_id INTEGER,
    applicant_id INTEGER,
    occupation_id INTEGER,
    text VARCHAR(50),
    city_id INTEGER
);

INSERT INTO new_resume(resume_id, applicant_id, occupation_id, text, city_id) 
        SELECT id, ROUND(1 + RANDOM() * 999), ROUND(1 + RANDOM() * 999), 'resume' || id, ROUND(1 + RANDOM() * 999)
        FROM generate_series(1, 2000000) as r(id);


CREATE TABLE new_request (
    request_id INTEGER,
    is_invite BOOLEAN,
    vacancy_id INTEGER,
    applicant_id INTEGER,
    seen BOOLEAN NOT NULL
);

INSERT INTO new_request(request_id, is_invite, vacancy_id, applicant_id, seen) 
        SELECT id, TRUE, ROUND(1 + RANDOM() * 999999), ROUND(1 + RANDOM() * 999), TRUE
        FROM generate_series(1, 5000000) as req(id);


CREATE TABLE new_experience (
    experience_id INTEGER,
    resume_id INTEGER,
    city_id INTEGER,
    start_date DATE,
    finish_date DATE,
    occupation_id INTEGER
);

INSERT INTO new_experience(experience_id, resume_id, city_id, start_date, finish_date, occupation_id) 
        SELECT id, ROUND(1 + RANDOM() * 1999999), ROUND(1 + RANDOM() * 999), '2019-01-01', NULL, ROUND(1 + RANDOM() * 999)
        FROM generate_series(1, 2000) as exp(id);


CREATE TABLE new_message (
    message_id INTEGER,
    request_id INTEGER,
    text VARCHAR (250),
    from_employer BOOLEAN,
    time TIMESTAMP,
    seen BOOLEAN
);

INSERT INTO new_message(message_id, request_id, text, from_employer, time, seen) 
        SELECT id, ROUND(1 + RANDOM() * 4999999), 'message' || id, TRUE, '2019-01-30', TRUE
        FROM generate_series(1, 5000000) as exp(id);
