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
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password')),
     my_resume AS
       (
         INSERT
           INTO hh.resume (account_id, name, city, position, shedule, education_level, experience_years, salary, about,
                           status)
             VALUES ((SELECT account_id FROM logged_account), 'Васечкин Михаил Николаевич', 'Калуга', 'Врач-куратор',
                     'FULL_DAY', 'SPECIALIST', '6+', 75000, 'Я очень хороший человек', 'SHOW') RETURNING resume_id
       )
INSERT
INTO hh.experience (resume_id, date_begin, date_end, organization_name, position, about)
VALUES ((SELECT resume_id FROM my_resume), '1998-09-01', NULL, 'Технопарк', 'PHP разработчик', 'Работал очень хорошо');

--    2. Хочу создать вакансию
--Добавляем вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = (SELECT account_id FROM logged_account)
       )
INSERT
INTO hh.vacancy(employer_id, city, position, shedule, education_level, experience_years, salary_from, salary_to, about,
                status)
VALUES ((SELECT employer_id FROM my_employer), 'Калуга', 'Врач-куратор', 'FULL_DAY', 'SPECIALIST', '1-3', 75000, 75000,
        'В связи с внедрением новых услуг по ДМС компания увеличивает штат сотрудников.', 'OPEN');

--    1. Хочу найти вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password')),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE account_id = (SELECT account_id FROM logged_account))
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
WHERE resume_id = (SELECT resume_id FROM my_resume)
  AND vacancy.status = 'OPEN'
  AND vacancy.education_level <= resume.education_level
  AND vacancy.experience_years <= resume.experience_years
  AND (vacancy.salary_from ISNULL OR vacancy.salary_from <= resume.salary)
  AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary);

--    2. Хочу найти резюме
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = (SELECT account_id FROM logged_account)
       ),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer))
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
WHERE vacancy_id = (SELECT vacancy_id FROM my_vacancy)
  AND resume.status = 'SHOW'
  AND vacancy.education_level <= resume.education_level
  AND vacancy.experience_years <= resume.experience_years
  AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary)
  AND (vacancy.salary_from ISNULL OR vacancy.salary_from <= resume.salary);

--    1. Хочу откликнуться на вакансию (отправить резюме)
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password')),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE account_id = (SELECT account_id FROM logged_account)),
     vacancy_for_me AS
       (
         SELECT vacancy_id
         FROM hh.vacancy
                JOIN hh.resume USING (city, position, shedule)
         WHERE resume_id = (SELECT resume_id FROM my_resume)
           AND vacancy.status = 'OPEN'
           AND vacancy.education_level <= resume.education_level
           AND vacancy.experience_years <= resume.experience_years
           AND (vacancy.salary_from ISNULL OR vacancy.salary_from <= resume.salary)
           AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary)
       )
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM my_resume), (SELECT vacancy_id FROM vacancy_for_me),
        (SELECT account_id FROM logged_account), now(), 'RESUME', 'Моё резюме', FALSE);

--    2. Хочу предложить вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = (SELECT account_id FROM logged_account)
       ),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer)),
     resume_for_me AS
       (
         SELECT resume_id
         FROM hh.resume
                JOIN hh.vacancy USING (city, position, shedule)
         WHERE vacancy_id = (SELECT vacancy_id FROM my_vacancy)
           AND resume.status = 'SHOW'
           AND vacancy.education_level <= resume.education_level
           AND vacancy.experience_years <= resume.experience_years
           AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary)
           AND (vacancy.salary_from ISNULL OR vacancy.salary_from <= resume.salary)
       )
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM resume_for_me), (SELECT vacancy_id FROM my_vacancy),
        (SELECT account_id FROM logged_account), now(), 'VACANCY', 'Наша вакансия', FALSE);

--    1. Хочу посмотреть работодателей, которые мне написали/ответили
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password'))
SELECT vacancy_id
FROM hh.message
       JOIN hh.resume USING (resume_id)
WHERE resume.account_id = (SELECT account_id FROM logged_account)
  AND resume.account_id != message.account_id
  AND message.view = FALSE;

--    2. Хочу посмотреть переписки, в которых появились новые сообщения
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = (SELECT account_id FROM logged_account)
       )
SELECT resume_id
FROM hh.message
       JOIN hh.vacancy USING (vacancy_id)
WHERE vacancy.employer_id = (SELECT employer_id FROM my_employer)
  AND message.account_id != (SELECT account_id FROM logged_account)
  AND message.view = FALSE;

--    1. Хочу написать работодателю
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password')),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE account_id = (SELECT account_id FROM logged_account)),
     vacancy_for_me AS
       (
         SELECT vacancy_id
         FROM hh.vacancy
                JOIN hh.resume USING (city, position, shedule)
         WHERE resume_id = (SELECT resume_id FROM my_resume)
           AND vacancy.status = 'OPEN'
           AND vacancy.education_level <= resume.education_level
           AND vacancy.experience_years <= resume.experience_years
           AND (vacancy.salary_from ISNULL OR vacancy.salary_from <= resume.salary)
           AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary)
       )
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM my_resume), (SELECT vacancy_id FROM vacancy_for_me),
        (SELECT account_id FROM logged_account), now(), 'TEXT_APP', 'Привет', FALSE);

--    2. Хочу написать соискателю
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = (SELECT account_id FROM logged_account)
       ),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer)),
     resume_for_me AS
       (
         SELECT resume_id
         FROM hh.resume
                JOIN hh.vacancy USING (city, position, shedule)
         WHERE vacancy_id = (SELECT vacancy_id FROM my_vacancy)
           AND resume.status = 'SHOW'
           AND vacancy.education_level <= resume.education_level
           AND vacancy.experience_years <= resume.experience_years
           AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary)
           AND (vacancy.salary_from ISNULL OR vacancy.salary_from <= resume.salary)
       )
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM resume_for_me), (SELECT vacancy_id FROM my_vacancy),
        (SELECT account_id FROM logged_account), now(), 'TEXT_EMP', 'Привет', FALSE);

--    2. Хочу закрыть вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (
         SELECT employer_id
         FROM hh.employer
                JOIN hh.employer_account USING (employer_id)
         WHERE employer_account.account_id = (SELECT account_id FROM logged_account)
       ),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer))
UPDATE hh.vacancy
SET status = 'CLOSE'
WHERE vacancy_id in (SELECT vacancy_id FROM my_vacancy);
