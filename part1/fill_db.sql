TRUNCATE hh.users CASCADE;
ALTER SEQUENCE IF EXISTS hh.users_user_id_seq RESTART;
TRUNCATE hh.towns CASCADE;
ALTER SEQUENCE IF EXISTS hh.towns_city_id_seq RESTART;
TRUNCATE hh.applicants CASCADE;
TRUNCATE hh.educational_institution CASCADE;
ALTER SEQUENCE IF EXISTS hh.educational_institution_institution_id_seq RESTART;
TRUNCATE hh.faculty CASCADE;
ALTER SEQUENCE IF EXISTS hh.faculty_faculty_id_seq RESTART;
TRUNCATE hh.speciality CASCADE;
ALTER SEQUENCE IF EXISTS hh.speciality_speciality_id_seq RESTART;
TRUNCATE hh.education CASCADE;
ALTER SEQUENCE IF EXISTS hh.education_education_id_seq RESTART;
TRUNCATE hh.organizations CASCADE;
ALTER SEQUENCE IF EXISTS hh.organizations_organization_id_seq RESTART;
TRUNCATE hh.positions CASCADE;
ALTER SEQUENCE IF EXISTS hh.positions_position_id_seq RESTART;
TRUNCATE hh.experience CASCADE;
ALTER SEQUENCE IF EXISTS hh.experience_experience_id_seq RESTART;
TRUNCATE hh.skills CASCADE;
ALTER SEQUENCE IF EXISTS hh.skills_skill_id_seq RESTART;
TRUNCATE hh.resume CASCADE;
ALTER SEQUENCE IF EXISTS hh.resume_resume_id_seq RESTART;
TRUNCATE hh.resume_to_education CASCADE;
TRUNCATE hh.resume_to_experience CASCADE;
TRUNCATE hh.resume_to_skills CASCADE;
TRUNCATE hh.employers CASCADE;
TRUNCATE hh.vacancy CASCADE;
ALTER SEQUENCE IF EXISTS hh.vacancy_vacancy_id_seq RESTART;
TRUNCATE hh.vacancy_to_skills CASCADE;
TRUNCATE hh.talks CASCADE;
ALTER SEQUENCE IF EXISTS hh.talks_talk_id_seq RESTART;
TRUNCATE hh.messages CASCADE;
ALTER SEQUENCE IF EXISTS hh.messages_message_id_seq RESTART;

INSERT INTO hh.users(email, password)
VALUES ('vasya@gmail.com', md5('000000')),
       ('petya@yandex.ru', md5('123456')),
       ('kolya@ya.ru', md5('qwerty')),
       ('sanya@mail.ru', md5('asdfgh')),
       ('katya@list.ru', md5('zxcvbn')),
       ('letovo@ya.ru', md5('poiuyt')),
       ('optofarm@gmail.com', md5('lkjhgf')),
       ('aleksej-izosimov@rambler.ru', md5('mnbvcx')),
       ('kadri@technopark.ru', md5('lkjhgf')),
       ('svetlana.smirnova01@megafon-retail.ru', md5('mnbvcx'));

INSERT INTO hh.towns(title)
VALUES ('Москва'),
       ('Санкт-Петербург'),
       ('Владивосток'),
       ('Волгоград'),
       ('Воронеж'),
       ('Екатеринбург'),
       ('Казань'),
       ('Калуга'),
       ('Краснодар'),
       ('Красноярск'),
       ('Нижний Новгород');

INSERT INTO hh.applicants(user_id, name, sex, birthday, city_id)
VALUES (1, 'Пупкин Василий Владимирович', 'MEN', '1991-06-27', 1),
       (2, 'Иванов Пётр Васильевич', 'MEN', '1987-05-14', 2),
       (3, 'Петров Николай Петрович', 'MEN', '1961-01-01', 11),
       (4, 'Сидоров Александр Николаевич', 'MEN', '1974-03-08', 9),
       (5, 'Попова Екатерина Андреевна', 'WOMEN', '2001-01-17', 5);

INSERT INTO hh.educational_institution(short_name, name, city_id)
VALUES ('МЭИ (ТУ)', 'Московский Энергетический Институт', 1),
       ('МГУ', 'Московский государственный университет им. М.В. Ломоносова', 1),
       ('ДВФУ', 'Дальневосточный федеральный университет', 3),
       ('ВолгГТУ', 'Волгоградский государственный технический университет', 4),
       ('УрГПУ', 'Уральский государственный педагогический университет', 6);

INSERT INTO hh.faculty(institution_id, name)
VALUES (1, 'АВТИ'),
       (2, 'Физический факультет'),
       (3, 'Школа естественных наук'),
       (4, 'Факультет экономики и управления'),
       (5, 'Институт филологии, культурологии и межкультурной коммуникации');

INSERT INTO hh.speciality(faculty_id, name)
VALUES (1, 'Вычислительные Машины, Комплексы, Системы и Сети'),
       (2, 'Кафедра молекулярной физики'),
       (3, 'Кафедра почвоведения'),
       (4, 'Мировая экономика и экономическая теория'),
       (5, 'Кафедра общего языкознания и русского языка');

INSERT INTO hh.education(user_id, level, speciality_id, year)
VALUES (1, 'MASTER', 5, 2015),
       (2, 'SPECIALIST', 2, 2010),
       (3, 'SPECIALIST', 3, 1984),
       (4, 'SPECIALIST', 1, 1997),
       (5, 'AVERAGE_SCHOOL', NULL, 2019);

INSERT INTO hh.organizations(name)
VALUES ('Школа Летово'),
       ('ООО Оптофарм'),
       ('ООО Малое инновационное предприятие Почвенного института им. В.В. Докучаева'),
       ('Технопарк'),
       ('АО МегаФон Ритейл'),
       ('Ломоносовская школа'),
       ('ГБОУ Школа № 1741'),
       ('ООО "Озеленитель Строй"'),
       ('ООО Центр Управления Ресурсами');

INSERT INTO hh.positions(title)
VALUES ('Учитель русского языка'),
       ('Технический руководитель проектов по разработке аналитического оборудования/биофизика'),
       ('Инженер-эколог'),
       ('Ведущий разработчик PHP'),
       ('Продавец-консультант'),
       ('Учитель русского языка и литературы'),
       ('Учитель физики'),
       ('Агроном - почвовед'),
       ('PHP разработчик');

INSERT INTO hh.experience(user_id, date_begin, date_end, organization_id, position_id, about)
VALUES (1, '2015-09-01', NULL, 6, 6, 'Работал очень хорошо'),
       (2, '2010-08-01', NULL, 7, 7, 'Ну очень хорошо работал'),
       (3, '1984-07-01', NULL, 8, 8, 'Лучший почвовед'),
       (4, '1997-06-01', NULL, 9, 9, 'Есть рекомендации');

INSERT INTO hh.skills(title)
VALUES ('Преподавание русского языка'),
       ('Обучение и развитие'),
       ('Ориентация на результат'),
       ('Работа в команде'),
       ('Стрессоустойчивость');

INSERT INTO hh.resume(user_id, phone, position_id, salary, about, shedule, status)
VALUES (1, '+79101234567', 1, 100000, 'Я очень ценный учитель', 'FULL_DAY', 'SHOW'),
       (2, '+79031234567', 2, 90000, 'Я очень ценный физик', 'FULL_DAY', 'SHOW'),
       (3, '+79261234567', 3, 45000, 'Я очень ценный почвовед', 'FULL_DAY', 'SHOW'),
       (4, '+79161234567', 4, 200000, 'Я очень ценный разработчик', 'FULL_DAY', 'SHOW'),
       (5, '+79051234567', 5, 50000, 'Я очень хочу работать', 'FULL_DAY', 'SHOW');

INSERT INTO hh.resume_to_education(resume_id, education_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

INSERT INTO hh.resume_to_experience(resume_id, experience_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);

INSERT INTO hh.resume_to_skills(resume_id, skill_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

INSERT INTO hh.employers(user_id, organization_id)
VALUES (6, 1),
       (7, 2),
       (8, 3),
       (9, 4),
       (10, 5);

INSERT INTO hh.vacancy(user_id, position_id, city_id, salary_from, salary_to, about, status)
VALUES (6, 1, 1, NULL, NULL,
        'Школа «Летово» — школа-пансион для одаренных и мотивированных детей, реализует обучение по стандартам ФГОС и программе Международного Бакалавриата.',
        'OPEN'),
       (7, 2, 2, 50000, 100000,
        'Предприятие, входящее в группу компаний радиоэлектронной отрасли, ищет технического руководителя для долгосрочной работы.',
        'OPEN'),
       (8, 3, 11, NULL, NULL,
        'Отбор проб компонентов окружающей среды и проведение инструментальных замеров в полевых условиях.', 'OPEN'),
       (9, 4, 9, 180000, NULL,
        'Поддержка и развитие сайта technopark.ru и других проектов холдинга. Поддержка и на высоком уровне культуры разработки и эффективности взаимодействия в команде.',
        'OPEN'),
       (10, 5, 5, 48000, NULL,
        'Привет, друг! Ты сделал правильный выбор, кликнув на нашу вакансию, потому что «МегаФон Ритейл» – лучшая компания для тебя и твоей карьеры.',
        'OPEN');

INSERT INTO hh.vacancy_to_skills(vacancy_id, skill_id)
VALUES (1, 1),
       (4, 4),
       (5, 5);

INSERT INTO hh.talks(resume_id, vacancy_id, status)
VALUES (1, 1, 'OPEN'),
       (2, 2, 'ACCEPT'),
       (3, 3, 'ACCEPT_APP'),
       (4, 4, 'ACCEPT_EMP'),
       (5, 5, 'OPEN');

INSERT INTO hh.messages(talk_id, send_time, type, body)
VALUES (1, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL),
       (2, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'VACANCY', NULL),
       (3, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'VACANCY', NULL),
       (4, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL),
       (5, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL);
INSERT INTO hh.messages(talk_id, send_time, type, body)
SELECT TRUNC(RANDOM() * 5 + 1),
       date(now() - trunc(1000 * random()) * '1 hour'::interval),
       CASE WHEN (random() > 0.5) THEN hh.message_type('TEXT_APP') ELSE hh.message_type('TEXT_EMP') END,
       'some message text'
FROM generate_series(1, 50);