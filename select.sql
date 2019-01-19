------------------------------------------------------------------------------------------------------------------------
-- банально выбрать резюме по id пользователя
SELECT
	resume_id,
	time_created,
	time_updated,
	position,
	fio,
	date_part('year',age(birthday)) as age,
	salary_min,
	salary_max
FROM
	headhunter.resume
WHERE
	account_id = 8;

------------------------------------------------------------------------------------------------------------------------
-- найти резюме в которых встречается скил с ID = 3
SELECT
  resume_id,
  account_id
FROM
  headhunter.resume
WHERE 3 = ANY(skill_ids);

------------------------------------------------------------------------------------------------------------------------
-- для вакансии найти подходящих работников
SELECT headhunter.resume.resume_id,  headhunter.resume.fio
FROM headhunter.vacancy
LEFT JOIN headhunter.resume ON(
	headhunter.vacancy.salary_max >= headhunter.resume.salary_min
		AND
	headhunter.vacancy.wanted_skill_ids && headhunter.resume.skill_ids
)
WHERE headhunter.vacancy.vacancy_id = 1;

------------------------------------------------------------------------------------------------------------------------
-- выбрать непрочитанные сообщения для пользователя 8.

WITH resume_ids AS
(SELECT	headhunter.resume.resume_id
 FROM 	headhunter.resume
 WHERE	headhunter.resume.account_id = 8),

conpany_ids AS
(SELECT DISTINCT headhunter.account_to_company_relation.company_id
 FROM headhunter.account_to_company_relation
 WHERE headhunter.account_to_company_relation.account_id = 8),

vacancy_ids AS
(SELECT headhunter.vacancy.vacancy_id
 FROM headhunter.vacancy
 WHERE headhunter.vacancy.company_id IN (select company_id from conpany_ids))

 SELECT message.message_id, count(headhunter.message.message_id) OVER() AS full_count
FROM headhunter.message
WHERE
-- if user have resume - check messages to his resumes
	((headhunter.message.resume_id in (SELECT resume_id FROM resume_ids)
		AND
	headhunter.message.message_type IN ('INVITE','MESSAGE_TO_RESUME')))

			OR

-- if user has relations to company, check nessages for vacansies of his companys
	((headhunter.message.vacancy_id IN (SELECT vacancy_id FROM vacancy_ids))
		AND
	headhunter.message.message_type IN ('REPLY','MESSAGE_TO_VACANCY'))

			AND
	headhunter.message.unread = true

ORDER BY time_create ASC
LIMIT 10 OFFSET 20;

------------------------------------------------------------------------------------------------------------------------
-- добавить нового пользователя - не интересно, я считаю
INSERT INTO headhunter.users(login, password, time_register)
VALUES
    ('vasya2', 	md5('querty2'), now());

------------------------------------------------------------------------------------------------------------------------
-- интересней, если пользователь с id = 8 добавляет новую компанию
WITH new_company as ( INSERT INTO headhunter.company(name, description, path_to_logo)
	VALUES ('User8Company & CO', 'описание компании', 'c:/logos/u8.logo')
	RETURNING company_id)
INSERT INTO headhunter.user_to_company_relations (user_id, company_id, rights, time_updated,who_update)
VALUES (8,	(select company_id from new_company),	'{0}',	now(),	8)
RETURNING company_id;

------------------------------------------------------------------------------------------------------------------------
-- ну и запрос для поиска скилов для автоподстановки
select skill_id, name
from headhunter.skill
where name ~* 'Технологии'
order by
	name ~ '^Технологии$' DESC,
	name ~* '^Технологии$' DESC,
	name ~* '^Технологии' DESC