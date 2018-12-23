-- банально выбрать резюме и вакансии по id пользователя
SELECT id, date_created, date_updated, "position", fio, age, salary_min, salary_max FROM headhunter.resume WHERE user_id = 8;

-- найти резюме в которых встречается скил "Компьютерная безопасность"
SELECT * FROM headhunter.resume WHERE 'Компьютерная безопасность' = ANY(skills)  ;

-- для всех вакансий найти резюме, подходящие по зарплатам :-)
SELECT * FROM headhunter.vacancy LEFT JOIN headhunter.resume ON(
	headhunter.vacancy.salary_max >= headhunter.resume.salary_min
		AND
	headhunter.vacancy.wanted_skills && headhunter.resume.skills
) where headhunter.resume.id IS NOT NULL;

-- выбрать непрочитанные сообщения для пользователя 8. Запрос страшный, однако он позволил дёргать только индексы, практически не прибегая к seq скану.
SELECT *, count(headhunter.messages.id) OVER() AS full_count
	FROM headhunter.messages 
	WHERE ((headhunter.messages.resume_id in (SELECT headhunter.resume.id FROM headhunter.resume WHERE headhunter.resume.user_id = 8) AND  headhunter.messages.message_type IN ('invite','message_to_resume'))
			OR 
	      (headhunter.messages.vacancy_id in (SELECT headhunter.vacancy.id FROM headhunter.vacancy WHERE headhunter.vacancy.company_id IN
			(SELECT headhunter.company.id FROM headhunter.company WHERE headhunter.company.user_id = 8)) AND  headhunter.messages.message_type IN ('reply','message_to_vacancy')))
		AND headhunter.messages.unread = true
		ORDER BY date_create ASC 
		LIMIT 10 OFFSET 20
		
