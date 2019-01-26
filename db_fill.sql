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

INSERT INTO vacancy (text, employer_id, occupation_id, experience) VALUES
('Bash lector',     1, 3, 95),
('Mega developer',  4, 1, 90),
('Java developer',  2, 1, 95),
('JS developer',    3, 4, 90),
('Need HR',         1, 2, 70);

INSERT INTO applicant (name) VALUES
('Vasily'),
('Peter'),
('Kolya'),
('Innokenty'),
('Maria');

INSERT INTO resume (applicant_id, occupation_id, text, experience) VALUES
(1, 1, 'I`m super!',            96),
(2, 3, 'I`m super lector!',     96),
(3, 4, 'I`m super frontender!', 65),
(4, 1, 'I`m super Java dev!',   98),
(5, 2, 'I`m super HR!',         71);

INSERT INTO application (vacancy_id, applicant_id) VALUES
(3, 1),
(2, 2),
(3, 3),
(4, 4),
(1, 2);

INSERT INTO invite (vacancy_id, applicant_id) VALUES
(1, 2),
(2, 1),
(3, 4),
(4, 3);
