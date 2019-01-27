INSERT INTO city (name) VALUES
('Moscow'),
('Piter');

INSERT INTO occupation (name) VALUES
('Android developer'),
('HR'),
('lector'),
('JS programmer'),
('Java developer');

INSERT INTO employer (name) VALUES
('HH'),
('Yandex'),
('Tinkoff'),
('Facebook');

INSERT INTO vacancy (text, employer_id, occupation_id, experience, city_id) VALUES
('Bash lector',     1, 3, 95, 1),
('Mega developer',  4, 1, 90, 1),
('Java developer',  2, 1, 95, 1),
('JS developer',    3, 4, 90, 2),
('Need HR',         1, 2, 70, 2);

INSERT INTO applicant (name, login, password, login_timestamp, logout_timestamp) VALUES
('Vasily', '1', '1', '1970-01-01 00:00:00', '1970-01-01 00:00:00'),
('Peter', 'abc', 'abc', '1970-01-01 00:00:00', '1970-01-01 00:00:00'),
('Kolya', 'admin', 'admin', '1970-01-01 00:00:00', '1970-01-01 00:00:00'),
('Innokenty', 'Innokenty', 'Innokenty', '1970-01-01 00:00:00', '1970-01-01 00:00:00'),
('Maria', 'Masha', '1990', '1970-01-01 00:00:00', '1970-01-01 00:00:00');

INSERT INTO resume (applicant_id, occupation_id, text, city_id) VALUES
(1, 1, 'I`m super!',            1),
(2, 3, 'I`m super lector!',     1),
(3, 4, 'I`m super frontender!', 1),
(4, 1, 'I`m super Java dev!',   2),
(5, 2, 'I`m super HR!',         2);

INSERT INTO application (vacancy_id, applicant_id) VALUES
(3, 1),
(2, 2),
(3, 3),
(4, 4),
(1, 2);

INSERT INTO invite (vacancy_id, applicant_id, seen) VALUES
(1, 2, FALSE),
(2, 1, FALSE),
(3, 4, FALSE),
(4, 3, FALSE);

INSERT INTO experience (resume_id, city_id, start_date, finish_date, occupation_id) VALUES
(1, 1, '2009-01-01', '1970-01-01', 1),
(2, 1, '2009-01-01', '1970-01-01', 1),
(3, 1, '2009-01-01', '1970-01-01', 1),
(4, 2, '2009-01-01', '1970-01-01', 1),
(5, 2, '2009-01-01', '1970-01-01', 1);

INSERT INTO message (invite_id, text, from_employer, time, seen) VALUES
(1, 'We need you!', TRUE, '2019-01-21 12:30:00-15', TRUE),
(1, 'Thanks!', FALSE, '2019-01-21 12:31:00-15', TRUE),
(1, 'See you tomorrow!', TRUE, '2019-01-21 12:32:00-15', FALSE);


