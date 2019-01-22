TRUNCATE hh.account CASCADE;
ALTER SEQUENCE IF EXISTS hh.account_account_id_seq RESTART;
TRUNCATE hh.applicant CASCADE;
TRUNCATE hh.educational_institution CASCADE;
ALTER SEQUENCE IF EXISTS hh.educational_institution_institution_id_seq RESTART;
TRUNCATE hh.faculty CASCADE;
ALTER SEQUENCE IF EXISTS hh.faculty_faculty_id_seq RESTART;
TRUNCATE hh.speciality CASCADE;
ALTER SEQUENCE IF EXISTS hh.speciality_speciality_id_seq RESTART;
TRUNCATE hh.education CASCADE;
ALTER SEQUENCE IF EXISTS hh.education_education_id_seq RESTART;
TRUNCATE hh.experience CASCADE;
ALTER SEQUENCE IF EXISTS hh.experience_experience_id_seq RESTART;
TRUNCATE hh.skill CASCADE;
ALTER SEQUENCE IF EXISTS hh.skill_skill_id_seq RESTART;
TRUNCATE hh.resume CASCADE;
ALTER SEQUENCE IF EXISTS hh.resume_resume_id_seq RESTART;
TRUNCATE hh.resume_education CASCADE;
TRUNCATE hh.resume_experience CASCADE;
TRUNCATE hh.resume_skill CASCADE;
TRUNCATE hh.employer CASCADE;
ALTER SEQUENCE IF EXISTS hh.employer_employer_id_seq RESTART;
TRUNCATE hh.employer_account CASCADE;
TRUNCATE hh.vacancy CASCADE;
ALTER SEQUENCE IF EXISTS hh.vacancy_vacancy_id_seq RESTART;
TRUNCATE hh.vacancy_skill CASCADE;
TRUNCATE hh.message CASCADE;
ALTER SEQUENCE IF EXISTS hh.message_message_id_seq RESTART;

INSERT INTO hh.account(email, password)
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

INSERT INTO hh.applicant(account_id, name, gender, birthday, city)
VALUES (1, 'Пупкин Василий Владимирович', 'MAN', '1991-06-27', 'Москва'),
       (2, 'Иванов Пётр Васильевич', 'MAN', '1987-05-14', 'Санкт-Петербург'),
       (3, 'Петров Николай Петрович', 'MAN', '1961-01-01', 'Нижний Новгород'),
       (4, 'Сидоров Александр Николаевич', 'MAN', '1974-03-08', 'Краснодар'),
       (5, 'Попова Екатерина Андреевна', 'WOMAN', '2001-01-17', 'Воронеж');

INSERT INTO hh.educational_institution(short_name, name, city)
VALUES ('МЭИ (ТУ)', 'Московский Энергетический Институт', 'Москва'),
       ('МГУ', 'Московский государственный университет им. М.В. Ломоносова', 'Москва'),
       ('ДВФУ', 'Дальневосточный федеральный университет', 'Владивосток'),
       ('ВолгГТУ', 'Волгоградский государственный технический университет', 'Волгоград'),
       ('УрГПУ', 'Уральский государственный педагогический университет', 'Екатеринбург');

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

INSERT INTO hh.education(applicant_id, level, speciality_id, year)
VALUES (1, 'MASTER', 5, 2015),
       (2, 'SPECIALIST', 2, 2010),
       (3, 'SPECIALIST', 3, 1984),
       (4, 'SPECIALIST', 1, 1997),
       (5, 'AVERAGE_SCHOOL', NULL, 2019);

INSERT INTO hh.experience(applicant_id, date_begin, date_end, organization_name, position, about)
VALUES (1, '2015-09-01', NULL, 'Ломоносовская школа', 'Учитель русского языка и литературы', 'Работал очень хорошо'),
       (2, '2010-08-01', NULL, 'ГБОУ Школа № 1741', 'Учитель физики', 'Ну очень хорошо работал'),
       (3, '1984-07-01', NULL, 'ООО "Озеленитель Строй"', 'Агроном - почвовед', 'Лучший почвовед'),
       (4, '1997-06-01', NULL, 'ООО Центр Управления Ресурсами', 'PHP разработчик', 'Есть рекомендации');

INSERT INTO hh.skill(title)
VALUES ('Преподавание русского языка'),
       ('Обучение и развитие'),
       ('Ориентация на результат'),
       ('Работа в команде'),
       ('Стрессоустойчивость');

INSERT INTO hh.resume(applicant_id, phone, position, salary, about, shedule, status)
VALUES (1, '+79101234567', 'Учитель русского языка', 100000, 'Я очень ценный учитель', 'FULL_DAY', 'SHOW'),
       (2, '+79031234567', 'Технический руководитель проектов по разработке аналитического оборудования/биофизика',
        90000, 'Я очень ценный физик', 'FULL_DAY', 'SHOW'),
       (3, '+79261234567', 'Инженер-эколог', 45000, 'Я очень ценный почвовед', 'FULL_DAY', 'SHOW'),
       (4, '+79161234567', 'Ведущий разработчик PHP', 200000, 'Я очень ценный разработчик', 'FULL_DAY', 'SHOW'),
       (5, '+79051234567', 'Продавец-консультант', 50000, 'Я очень хочу работать', 'FULL_DAY', 'SHOW');

INSERT INTO hh.resume_education(resume_id, education_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

INSERT INTO hh.resume_experience(resume_id, experience_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);

INSERT INTO hh.resume_skill(resume_id, skill_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

INSERT INTO hh.employer(organization_name)
VALUES ('Школа Летово'),
       ('ООО Оптофарм'),
       ('ООО Малое инновационное предприятие Почвенного института им. В.В. Докучаева'),
       ('Технопарк'),
       ('АО МегаФон Ритейл');

INSERT INTO hh.employer_account(employer_id, account_id)
VALUES (1, 6),
       (2, 7),
       (3, 8),
       (4, 9),
       (5, 10);

INSERT INTO hh.vacancy(employer_id, position, city, salary_from, salary_to, about, status)
VALUES (1, 'Учитель русского языка', 'Москва', NULL, NULL,
        'Школа «Летово» — школа-пансион для одаренных и мотивированных детей, реализует обучение по стандартам ФГОС и программе Международного Бакалавриата.',
        'OPEN'),
       (2, 'Технический руководитель проектов по разработке аналитического оборудования/биофизика', 'Санкт-Петербург',
        50000, 100000,
        'Предприятие, входящее в группу компаний радиоэлектронной отрасли, ищет технического руководителя для долгосрочной работы.',
        'OPEN'),
       (3, 'Инженер-эколог', 'Нижний Новгород', NULL, NULL,
        'Отбор проб компонентов окружающей среды и проведение инструментальных замеров в полевых условиях.', 'OPEN'),
       (4, 'Ведущий разработчик PHP', 'Краснодар', 180000, NULL,
        'Поддержка и развитие сайта technopark.ru и других проектов холдинга. Поддержка и на высоком уровне культуры разработки и эффективности взаимодействия в команде.',
        'OPEN'),
       (5, 'Продавец-консультант', 'Воронеж', 48000, NULL,
        'Привет, друг! Ты сделал правильный выбор, кликнув на нашу вакансию, потому что «МегаФон Ритейл» – лучшая компания для тебя и твоей карьеры.',
        'OPEN');

INSERT INTO hh.vacancy_skill(vacancy_id, skill_id)
VALUES (1, 1),
       (4, 4),
       (5, 5);

INSERT INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES (1, 1, 1, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL, TRUE),
       (2, 2, 2, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'VACANCY', NULL, TRUE),
       (3, 3, 3, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'VACANCY', NULL, TRUE),
       (4, 4, 4, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL, TRUE),
       (5, 5, 5, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL, TRUE);
INSERT INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
SELECT id,id,id,send_time,type,body,view
FROM (
       SELECT TRUNC(RANDOM() * 5 + 1)                                                                          AS id,
              date(now() - trunc(1000 * random()) * '1 hour'::interval)                                        AS send_time,
              CASE WHEN (random() > 0.5) THEN hh.MESSAGE_TYPE('TEXT_APP') ELSE hh.MESSAGE_TYPE('TEXT_EMP') END AS type,
              'some message text'                                                                              AS body,
              CASE WHEN (random() > 0.5) THEN TRUE ELSE FALSE END                                              AS view
       FROM generate_series(1, 50)
     ) q;