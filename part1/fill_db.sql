TRUNCATE hh.account CASCADE;
ALTER SEQUENCE IF EXISTS hh.account_account_id_seq RESTART;
TRUNCATE hh.resume CASCADE;
ALTER SEQUENCE IF EXISTS hh.resume_resume_id_seq RESTART;
TRUNCATE hh.employer CASCADE;
ALTER SEQUENCE IF EXISTS hh.employer_employer_id_seq RESTART;
TRUNCATE hh.employer_account CASCADE;
TRUNCATE hh.vacancy CASCADE;
ALTER SEQUENCE IF EXISTS hh.vacancy_vacancy_id_seq RESTART;
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

INSERT INTO hh.resume(account_id, name, city, position, shedule, education_level, experience_years, salary, about)
VALUES (1, 'Пупкин Василий Владимирович', 'Москва', 'Учитель русского языка', 'FULL_DAY', 'MASTER', 3, 100000,
        'Я очень ценный учитель'),
       (2, 'Иванов Пётр Васильевич', 'Санкт-Петербург',
        'Технический руководитель проектов по разработке аналитического оборудования/биофизика', 'FULL_DAY',
        'SPECIALIST', 8, 90000, 'Я очень ценный физик'),
       (3, 'Петров Николай Петрович', 'Нижний Новгород', 'Инженер-эколог', 'FULL_DAY', 'SPECIALIST', 34, 45000,
        'Я очень ценный почвовед'),
       (4, 'Сидоров Александр Николаевич', 'Краснодар', 'Ведущий разработчик PHP', 'FULL_DAY', 'SPECIALIST', 21, 200000,
        'Я очень ценный разработчик'),
       (5, 'Попова Екатерина Андреевна', 'Воронеж', 'Продавец-консультант', 'FULL_DAY', 'AVERAGE_SCHOOL', 0, 50000,
        'Я очень хочу работать');

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

INSERT INTO hh.vacancy(employer_id, city, position, shedule, education_level, experience_years, salary_from, salary_to,
                       about, status)
VALUES (1, 'Москва', 'Учитель русского языка', 'FULL_DAY', 'MASTER', 3, NULL, NULL,
        'Школа «Летово» — школа-пансион для одаренных и мотивированных детей, реализует обучение по стандартам ФГОС и программе Международного Бакалавриата.',
        'OPEN'),
       (2, 'Санкт-Петербург', 'Технический руководитель проектов по разработке аналитического оборудования/биофизика',
        'FULL_DAY', 'MASTER', 5, 50000, 100000,
        'Предприятие, входящее в группу компаний радиоэлектронной отрасли, ищет технического руководителя для долгосрочной работы.',
        'OPEN'),
       (3, 'Нижний Новгород', 'Инженер-эколог', 'FULL_DAY', 'MASTER', 3, NULL, NULL,
        'Отбор проб компонентов окружающей среды и проведение инструментальных замеров в полевых условиях.', 'OPEN'),
       (4, 'Краснодар', 'Ведущий разработчик PHP', 'FULL_DAY', 'MASTER', 7, 180000, NULL,
        'Поддержка и развитие сайта technopark.ru и других проектов холдинга. Поддержка и на высоком уровне культуры разработки и эффективности взаимодействия в команде.',
        'OPEN'),
       (5, 'Воронеж', 'Продавец-консультант', 'FULL_DAY', 'AVERAGE_SCHOOL', 0, 48000, NULL,
        'Привет, друг! Ты сделал правильный выбор, кликнув на нашу вакансию, потому что «МегаФон Ритейл» – лучшая компания для тебя и твоей карьеры.',
        'OPEN');

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
