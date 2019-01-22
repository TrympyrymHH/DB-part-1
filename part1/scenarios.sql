--1. Соискатель
--    1. Хочу зарегистрироваться
INSERT INTO hh.account (email, password)
VALUES ('michnick@mail.ru', md5('password')) RETURNING account_id;

--    2. Хочу войти
SELECT account_id
FROM hh.account
WHERE email = 'michnick@mail.ru'
  AND password = md5('password');

--    3. Хочу создать резюме
--Добавляем резюме
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password'))
INSERT
INTO hh.resume(account_id, name, city, position, shedule, education_level, experience_years, salary, about)
VALUES ((SELECT account_id FROM logged_account), 'Васечкин Михаил Николаевич', 'Краснодар', 'Ведущий разработчик PHP',
        'FLEXIBLE', 'SPECIALIST', 20, 150000, 'Я очень хороший человек');

--    4. Хочу найти вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password')),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE account_id = (SELECT account_id FROM logged_account))
SELECT vacancy_id,
       vacancy.position,
       employer.organization_name,
       vacancy.salary_from,
       vacancy.salary_to,
       vacancy.about
FROM hh.resume
       JOIN hh.vacancy USING (position, city)
       JOIN hh.employer USING (employer_id)
WHERE resume_id = (SELECT resume_id FROM my_resume)
  AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary);

--    5. Хочу откликнуться на вакансию (отправить резюме)
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password')),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE account_id = (SELECT account_id FROM logged_account)),
     vacancy_for_me AS
       (SELECT vacancy_id
        FROM hh.resume
               JOIN hh.vacancy USING (position, city)
               JOIN hh.employer USING (employer_id)
        WHERE resume_id = (SELECT resume_id FROM my_resume)
          AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary))
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM my_resume), (SELECT vacancy_id FROM vacancy_for_me),
        (SELECT account_id FROM logged_account), now(), 'RESUME', 'Моё резюме', FALSE);

--    6. Хочу посмотреть работодателей, которые мне ответили
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password'))
SELECT vacancy_id
FROM hh.message
       JOIN hh.resume USING (resume_id)
WHERE resume.account_id = (SELECT account_id FROM logged_account)
  AND resume.account_id != message.account_id
  AND message.view = FALSE;

--    7. Хочу написать работодателю с вакансией 2
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'michnick@mail.ru' AND password = md5('password')),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE account_id = (SELECT account_id FROM logged_account))
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM my_resume), 2, (SELECT account_id FROM logged_account), now(), 'TEXT_APP', 'Привет',
        FALSE);

--2. Работодатель
--    1. Хочу зарегистрироваться
WITH created_account AS
       (INSERT INTO hh.account (email, password) VALUES ('zharinova@vsk.ru', md5('password')) RETURNING account_id),
     created_employer AS
       (INSERT INTO hh.employer (organization_name) VALUES ('ВСК, САО') RETURNING employer_id)
INSERT
INTO hh.employer_account (employer_id, account_id)
VALUES ((SELECT employer_id FROM created_employer), (SELECT account_id FROM created_account)) RETURNING account_id;

--    2. Хочу войти
SELECT account_id
FROM hh.account
WHERE email = 'zharinova@vsk.ru'
  AND password = md5('password');

--    3. Хочу создать вакансию
--Добавляем вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (SELECT employer_id
        FROM hh.employer
               JOIN hh.employer_account USING (employer_id)
        WHERE employer_account.account_id = (SELECT account_id FROM logged_account))
INSERT
INTO hh.vacancy (employer_id, position, city, salary_from, salary_to, about, status)
VALUES ((SELECT employer_id FROM my_employer), 'Врач-куратор', 'Калуга', 75000, 75000,
        'В связи с внедрением новых услуг по ДМС компания увеличивает штат сотрудников.', 'OPEN');

--    4. Хочу найти резюме
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (SELECT employer_id
        FROM hh.employer
               JOIN hh.employer_account USING (employer_id)
        WHERE employer_account.account_id = (SELECT account_id FROM logged_account)),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer))
SELECT resume_id,
       resume.position,
       resume.name,
       resume.salary,
       resume.about
FROM hh.resume
       JOIN hh.vacancy USING (position, city)
WHERE vacancy_id = (SELECT vacancy_id FROM my_vacancy)
  AND (vacancy.salary_to ISNULL OR vacancy.salary_to >= resume.salary)
  AND (vacancy.salary_from ISNULL OR vacancy.salary_from <= resume.salary);

--    5. Хочу предложить вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (SELECT employer_id
        FROM hh.employer
               JOIN hh.employer_account USING (employer_id)
        WHERE employer_account.account_id = (SELECT account_id FROM logged_account)),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer))
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES (1, (SELECT vacancy_id FROM my_vacancy),
        (SELECT account_id FROM logged_account), now(), 'VACANCY', 'Наша вакансия', FALSE);

--    6. Хочу посмотреть соискателей, которые мне ответили
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (SELECT employer_id
        FROM hh.employer
               JOIN hh.employer_account USING (employer_id)
        WHERE employer_account.account_id = (SELECT account_id FROM logged_account))
SELECT resume_id
FROM hh.message
       JOIN hh.vacancy USING (vacancy_id)
WHERE vacancy.employer_id = (SELECT employer_id FROM my_employer)
  AND message.account_id != (SELECT account_id FROM logged_account)
  AND message.view = FALSE;

--    7. Хочу написать соискателю с резюме 1
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (SELECT employer_id
        FROM hh.employer
               JOIN hh.employer_account USING (employer_id)
        WHERE employer_account.account_id = (SELECT account_id FROM logged_account)),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer))
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES (1, (SELECT vacancy_id FROM my_vacancy),
        (SELECT account_id FROM logged_account), now(), 'TEXT_EMP', 'Привет', FALSE);

--    8. Хочу закрыть вакансию
WITH logged_account AS
       (SELECT account_id FROM hh.account WHERE email = 'zharinova@vsk.ru' AND password = md5('password')),
     my_employer AS
       (SELECT employer_id
        FROM hh.employer
               JOIN hh.employer_account USING (employer_id)
        WHERE employer_account.account_id = (SELECT account_id FROM logged_account)),
     my_vacancy AS
       (SELECT vacancy_id FROM hh.vacancy WHERE employer_id = (SELECT employer_id FROM my_employer))
UPDATE hh.vacancy
SET status = 'CLOSE'
WHERE vacancy_id in (SELECT vacancy_id FROM my_vacancy) RETURNING vacancy_id;