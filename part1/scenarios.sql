--1. Соискатель
--2. Работодатель

--    1. Хочу зарегистрироваться
INSERT INTO hh.account (email, password)
VALUES ('michnick@mail.ru', md5('password')) RETURNING account_id;

--    2. Хочу зарегистрироваться
WITH created_account AS
       (INSERT INTO hh.account (email, password) VALUES ('zharinova@vsk.ru', md5('password')) RETURNING account_id),
     created_employer AS
       (INSERT INTO hh.employer (organization_name) VALUES ('ВСК, САО') RETURNING employer_id)
INSERT
INTO hh.employer_account (employer_id, account_id)
VALUES ((SELECT employer_id FROM created_employer), (SELECT account_id FROM created_account)) RETURNING account_id;

--    1. Хочу войти
SELECT account_id
FROM hh.account
WHERE email = 'michnick@mail.ru'
  AND password = md5('password');

--    2. Хочу войти
SELECT account_id
FROM hh.account
WHERE email = 'zharinova@vsk.ru'
  AND password = md5('password');

--    1. Хочу создать резюме
INSERT INTO hh.resume (account_id, name, city, position, shedule, education_level, experience_years, salary, about,
                       status)
VALUES (11, 'Васечкин Михаил Николаевич', 'Калуга', 'Врач-куратор', 'FULL_DAY', 'SPECIALIST', '6+', 75000,
        'Я очень хороший человек', 'SHOW');

--    1. Хочу добавить прежднее место работы
INSERT INTO hh.experience (resume_id, date_begin, date_end, organization_name, position, about)
VALUES (6, '1998-09-01', NULL, 'Технопарк', 'PHP разработчик', 'Работал очень хорошо');

--    2. Хочу создать вакансию
WITH my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = 12
       )
INSERT
INTO hh.vacancy(employer_id, city, position, shedule, education_level, experience_years, salary_from, salary_to, about,
                status)
VALUES ((SELECT employer_id FROM my_employer), 'Калуга', 'Врач-куратор', 'FULL_DAY', 'SPECIALIST', '1-3', 75000, 75000,
        'В связи с внедрением новых услуг по ДМС компания увеличивает штат сотрудников.', 'OPEN');

--    1. Хочу посмотреть список моих резюме
SELECT resume_id,position
FROM hh.resume
WHERE account_id = 11;

--    2. Хочу посмотреть список моих вакансий
WITH my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = 12
       )
SELECT vacancy_id,position
FROM hh.vacancy
WHERE employer_id IN (SELECT employer_id FROM my_employer);

--    1. Хочу найти вакансию
SELECT vacancy_id,
       employer.organization_name,
       vacancy.city,
       vacancy.position,
       vacancy.shedule,
       vacancy.education_level,
       vacancy.experience_years,
       vacancy.salary_from,
       vacancy.salary_to,
       vacancy.about
FROM hh.vacancy
       JOIN hh.employer USING (employer_id)
       JOIN hh.resume USING (city, position, shedule)
WHERE resume_id = 6
  AND vacancy.status = 'OPEN'
  AND vacancy.education_level <= resume.education_level
  AND vacancy.experience_years <= resume.experience_years
  AND (vacancy.salary_from IS NULL OR vacancy.salary_from <= resume.salary)
  AND (vacancy.salary_to IS NULL OR vacancy.salary_to >= resume.salary);

--    2. Хочу найти резюме
SELECT resume_id,
       resume.name,
       resume.city,
       resume.position,
       resume.shedule,
       resume.education_level,
       resume.experience_years,
       resume.salary,
       resume.about
FROM hh.resume
       JOIN hh.vacancy USING (city, position, shedule)
WHERE vacancy_id = 6
  AND resume.status = 'SHOW'
  AND vacancy.education_level <= resume.education_level
  AND vacancy.experience_years <= resume.experience_years
  AND (vacancy.salary_to IS NULL OR vacancy.salary_to >= resume.salary)
  AND (vacancy.salary_from IS NULL OR vacancy.salary_from <= resume.salary);

--    1. Хочу откликнуться на вакансию (отправить резюме)
INSERT INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES (6, 6, 11, now(), 'RESUME', 'Моё резюме', FALSE);

--    2. Хочу предложить вакансию
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES (6, 6, 12, now(), 'VACANCY', 'Наша вакансия', FALSE);

--    1. Хочу посмотреть работодателей, с которыми я общался по определённому резюме
SELECT employer.organization_name, vacancy.position, message.view, count(message.message_id)
         FROM hh.message
                JOIN hh.vacancy USING (vacancy_id)
                JOIN hh.employer USING (employer_id)
         WHERE message.resume_id = 6
           AND message.account_id != 11
         GROUP BY (employer.employer_id, vacancy.vacancy_id, message.view) ORDER BY message.view;

--    2. Хочу посмотреть соискателей, с которыми я общался по определённой вакансии
SELECT resume.name, resume.position, message.view, count(message.message_id)
         FROM hh.message
                JOIN hh.resume USING (resume_id)
         WHERE message.vacancy_id = 6
           AND message.account_id != 12
         GROUP BY (resume.resume_id, message.view) ORDER BY message.view;

     --    1. Хочу посмотреть работодателей, которые мне написали/ответили
SELECT vacancy_id
FROM hh.message
       JOIN hh.resume USING (resume_id)
WHERE resume.account_id = 11
  AND resume.account_id != message.account_id
  AND message.view = FALSE;

--    2. Хочу посмотреть переписки, в которых появились новые сообщения
WITH my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = 12
       )
SELECT resume_id
FROM hh.message
       JOIN hh.vacancy USING (vacancy_id)
WHERE vacancy.employer_id = (SELECT employer_id FROM my_employer)
  AND message.account_id != 12
  AND message.view = FALSE;

--    1. Хочу прочитать сообщения от работодателя
WITH messages AS
       (
         SELECT message.message_id,
                message.account_id,
                account.email,
                message.send_time,
                message.type,
                message.body,
                message.view
         FROM hh.message
                JOIN hh.account USING (account_id)
         WHERE message.resume_id = 6
           AND message.vacancy_id = 6
         ORDER BY send_time
       ),
     update_messages AS
       (
         UPDATE hh.message
           SET view = TRUE
           WHERE message_id in (SELECT message_id FROM messages)
             AND account_id != 11
       )
SELECT *
FROM messages;

--    1. Хочу прочитать сообщения от соискателя
WITH messages AS
       (
         SELECT message.message_id,
                resume.account_id AS applicant_id,
                message.account_id,
                account.email,
                message.send_time,
                message.type,
                message.body,
                message.view
         FROM hh.message
                JOIN hh.account USING (account_id)
                JOIN hh.resume USING (resume_id)
         WHERE message.resume_id = 6
           AND message.vacancy_id = 6
         ORDER BY send_time
       ),
     update_messages AS
       (
         UPDATE hh.message
           SET view = TRUE
           WHERE message_id IN (SELECT message_id FROM messages)
             AND (account_id IN (SELECT applicant_id FROM messages))
       )
SELECT *
FROM messages;

--    1. Хочу написать работодателю
INSERT INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES (6, 6, 11, now(), 'TEXT_APP', 'Привет', FALSE);

--    2. Хочу написать соискателю
INSERT INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES (6, 6, 12, now(), 'TEXT_EMP', 'Привет', FALSE);

--    1. Хочу скрыть резюме
UPDATE hh.resume
SET status = 'HIDE'
WHERE resume_id = 6;

--    2. Хочу закрыть вакансию
UPDATE hh.vacancy
SET status = 'CLOSE'
WHERE vacancy_id = 6;
