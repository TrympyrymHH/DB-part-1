------------------------------------------------------------------------------------------------------------------------
-- банально выбрать резюме и вакансии по id пользователя
SELECT resume_id, time_created, time_updated, "position", fio, age, salary_min, salary_max FROM headhunter.resume WHERE user_id = 8;

------------------------------------------------------------------------------------------------------------------------
-- найти резюме в которых встречается скил "Компьютерная безопасность"
SELECT resume_id, user_id FROM headhunter.resume WHERE 'Компьютерная безопасность' = ANY(skills);

------------------------------------------------------------------------------------------------------------------------
-- для всех вакансий найти резюме, подходящие по зарплатам :-)
SELECT resume_id, user_id FROM headhunter.vacancy LEFT JOIN headhunter.resume ON(
	headhunter.vacancy.salary_max >= headhunter.resume.salary_min
		AND
	headhunter.vacancy.wanted_skills && headhunter.resume.skills
) where headhunter.resume.id IS NOT NULL;

------------------------------------------------------------------------------------------------------------------------
-- выбрать непрочитанные сообщения для пользователя 8. Запрос страшный, однако он позволил дёргать только индексы, практически не прибегая к seq скану.
SELECT messages.messages_id, count(headhunter.messages.messages_id) OVER() AS full_count
	FROM headhunter.messages
	WHERE (
		-- if user have resume - check messages to his resumes
		(headhunter.messages.resume_id in (
		    SELECT
			headhunter.resume.resume_id
		    FROM headhunter.resume
		    WHERE headhunter.resume.user_id = 8)
			AND
			headhunter.messages.message_type IN ('invite','message_to_resume'))

		OR

		-- if user has relations to company, check nessages for vacansies of his companys
		(headhunter.messages.vacancy_id IN
			(SELECT headhunter.vacancy.vacancy_id
			FROM headhunter.vacancy
			WHERE headhunter.vacancy.company_id IN
				(SELECT DISTINCT headhunter.user_to_company_relations.company_id
				FROM headhunter.user_to_company_relations
				WHERE headhunter.user_to_company_relations.user_id = 8)
			)
			AND  headhunter.messages.message_type IN ('reply','message_to_vacancy'))

		)

		AND headhunter.messages.unread = true
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

