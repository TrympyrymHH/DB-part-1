--1. Соискатель
--    1. Хочу зарегистрироваться
WITH created_account AS
       (
         INSERT INTO hh.account (email, password)
           VALUES ('michnick@mail.ru', md5('password'))
           RETURNING account_id
       ),
     my_city AS
       (SELECT city_id
        from hh.city
        WHERE title = 'Краснодар')
INSERT
INTO hh.applicant (account_id, name, gender, birthday, city_id)
VALUES ((SELECT account_id FROM created_account), 'Васечкин Михаил Николаевич', 'MAN', '1975-03-08',
        (SELECT city_id FROM my_city));

--    2. Хочу войти
WITH logged_account AS
       (
         SELECT account_id
         FROM hh.account
         WHERE email = 'michnick@mail.ru'
           AND password = md5('password')
       )
UPDATE hh.account
SET session_password = md5('12345')
WHERE account_id in (SELECT account_id FROM logged_account) RETURNING account_id;

--    3. Хочу создать резюме
--Добавляем резюме
WITH logged_account AS
       (
         SELECT account_id
         FROM hh.account
         WHERE email = 'michnick@mail.ru'
           AND session_password = md5('12345')
       ),
     my_position AS
       (SELECT position_id
        FROM hh.position
        WHERE title = 'Ведущий разработчик PHP'),
     my_resume AS
       (INSERT INTO hh.resume (applicant_id, phone, position_id, salary, about, shedule, status)
         VALUES ((SELECT account_id FROM logged_account), '+79151234567', (SELECT position_id FROM my_position), 150000,
                 'Я очень хороший человек', 'FLEXIBLE', 'SHOW') RETURNING resume_id),
     --Добавляем образование
     my_educational_institution AS
       (SELECT institution_id FROM hh.educational_institution WHERE short_name = 'МЭИ (ТУ)'),
     my_faculty AS
       (SELECT faculty_id
        FROM hh.faculty
        WHERE institution_id in (SELECT institution_id FROM my_educational_institution)
          AND name = 'АВТИ'),
     my_speciality AS
       (SELECT speciality_id
        FROM hh.speciality
        WHERE faculty_id in (SELECT faculty_id FROM my_faculty)
          AND name ~* 'Вычислительные'),
     my_education AS
       (INSERT INTO hh.education (applicant_id, level, speciality_id, year)
         VALUES ((SELECT account_id FROM logged_account), 'SPECIALIST', (SELECT speciality_id FROM my_speciality),
                 1998) RETURNING education_id),
     my_resume_education AS
       (INSERT INTO hh.resume_education (resume_id, education_id)
         VALUES ((SELECT resume_id FROM my_resume), (SELECT education_id FROM my_education))),
     --Добавляем опыт
     my_old_organization AS
         (SELECT organization_id FROM hh.organization WHERE name = 'Технопарк'),
     my_old_position AS
       (SELECT position_id
        FROM hh.position
        WHERE title ~* 'PHP разработчик'),
     my_experience AS
       (INSERT INTO hh.experience (applicant_id, date_begin, date_end, organization_id, position_id, about)
         VALUES ((SELECT account_id FROM logged_account), '1998-09-01', NULL,
                 (SELECT organization_id FROM my_old_organization), (SELECT position_id FROM my_old_position),
                 'Работал очень хорошо') RETURNING experience_id),
     my_resume_experience AS
       (INSERT INTO hh.resume_experience (resume_id, experience_id)
         VALUES ((SELECT resume_id FROM my_resume), (SELECT experience_id FROM my_experience))),
     --Добавляем умения
     my_skill AS
       (SELECT skill_id
        FROM hh.skill
        WHERE title ~* 'коман')
INSERT
INTO hh.resume_skill (resume_id, skill_id)
VALUES ((SELECT resume_id FROM my_resume), (SELECT skill_id
                                            FROM my_skill));

--    4. Хочу найти вакансию
WITH logged_account AS
       (
         SELECT account_id
         FROM hh.account
         WHERE email = 'michnick@mail.ru'
           AND session_password = md5('12345')
       ),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE applicant_id = (SELECT account_id FROM logged_account))
SELECT vacancy_id, position.title, organization.name, vacancy.salary_from, vacancy.salary_to, vacancy.about
FROM hh.resume
       JOIN hh.applicant ON (resume.applicant_id = applicant.account_id)
       JOIN hh.position USING (position_id)
       JOIN hh.vacancy USING (position_id, city_id)
       JOIN hh.employer USING (employer_id)
       JOIN hh.organization USING (organization_id)
WHERE resume_id = (SELECT resume_id FROM my_resume)
  AND (vacancy.salary_to ISNULL OR vacancy.salary_to > resume.salary);

--    5. Хочу откликнуться на вакансию (отправить резюме)
WITH logged_account AS
       (
         SELECT account_id
         FROM hh.account
         WHERE email = 'michnick@mail.ru'
           AND session_password = md5('12345')
       ),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE applicant_id = (SELECT account_id FROM logged_account)),
     vacancy_for_me AS
       (SELECT vacancy_id, position.title, organization.name, vacancy.salary_from, vacancy.salary_to, vacancy.about
        FROM hh.resume
               JOIN hh.applicant ON (resume.applicant_id = applicant.account_id)
               JOIN hh.position USING (position_id)
               JOIN hh.vacancy USING (position_id, city_id)
               JOIN hh.employer USING (employer_id)
               JOIN hh.organization USING (organization_id)
        WHERE resume_id = (SELECT resume_id FROM my_resume)
          AND (vacancy.salary_to ISNULL OR vacancy.salary_to > resume.salary))
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM my_resume), (SELECT vacancy_id FROM vacancy_for_me),
        (SELECT account_id FROM logged_account), now(), 'RESUME', 'Моё резюме', FALSE);

--    6. Хочу посмотреть работодателей, которые мне ответили
WITH logged_account AS
       (
         SELECT account_id
         FROM hh.account
         WHERE email = 'michnick@mail.ru'
           AND session_password = md5('12345')
       )
SELECT vacancy_id
FROM hh.message
       JOIN hh.resume USING (resume_id)
WHERE resume.applicant_id = (SELECT account_id FROM logged_account)
  AND resume.applicant_id != message.account_id
  AND message.view = FALSE;

--    7. Хочу написать работодателю с вакансией 2
WITH logged_account AS
       (
         SELECT account_id
         FROM hh.account
         WHERE email = 'michnick@mail.ru'
           AND session_password = md5('12345')
       ),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE applicant_id = (SELECT account_id FROM logged_account))
INSERT
INTO hh.message(resume_id, vacancy_id, account_id, send_time, type, body, view)
VALUES ((SELECT resume_id FROM my_resume), 2, (SELECT account_id FROM logged_account), now(), 'TEXT_APP', 'Привет', FALSE);

--    8. Хочу закрыть резюме
WITH logged_account AS
       (
         SELECT account_id
         FROM hh.account
         WHERE email = 'michnick@mail.ru'
           AND session_password = md5('12345')
       ),
     my_resume AS
       (SELECT resume_id FROM hh.resume WHERE applicant_id = (SELECT account_id FROM logged_account))
UPDATE hh.resume
SET status = 'HIDE'
WHERE resume_id in (SELECT resume_id FROM my_resume) RETURNING resume_id;

--2. Работодатель
--    1. Хочу зарегистрироваться
--    2. Хочу войти
--    3. Хочу создать описание компании
--    4. Хочу создать вакансию
--    5. Хочу найти резюме
--    6. Хочу предложить вакансию
--    7. Хочу посмотреть соискателей, которым интересна моя вакансия
--    8. Хочу начать переписку с соискателем
--    9. Хочу согласиться на сотрудничество
--    10. Хочу отказать в сотрудничестве
--    11. Хочу закрыть вакансию