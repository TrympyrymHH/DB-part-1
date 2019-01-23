----------------------------------------------------------------------------USER------------------------------------------
TRUNCATE hh.user CASCADE;
ALTER SEQUENCE IF EXISTS hh.user_user_id_seq RESTART WITH 1;

INSERT INTO hh.user(login, password, time_of_register)
VALUES
	('andrei', 	'password1', now()),
	('vova', 	'password2', now()),
	('katya', 	'password3', now()),
	('smbdy',	'password4', now()),
	('hero', 	'password5', now());

-------------------------------------------------------------------------------COMPANY-----------------------------------------

TRUNCATE hh.company CASCADE;
ALTER SEQUENCE IF EXISTS hh.company_company_id_seq RESTART WITH 1;

INSERT INTO hh.company(name)
OVERRIDING SYSTEM VALUE
VALUES
	('yandex'),
	('google'),
	('hh'),
	('mailru'),
	('kfc');

-----------------------------------------------------------------------USER_COMPANY---------------------------------------

TRUNCATE hh.user_company CASCADE;
ALTER SEQUENCE IF EXISTS hh.user_company_user_company_id_seq RESTART WITH 1;
	 
INSERT INTO hh.user_company(user_id, company_id, position)
VALUES
	(1, 1, 'proger'),
	(2, 2, 'sniper'),
	(3, 3, 'headhunter'),
	(5, 4, 'mailman');
	
		 
---------------------------------------------------------------------------VACANCY-------------------------------------------

TRUNCATE hh.vacancy CASCADE;
ALTER SEQUENCE IF EXISTS hh.vacancy_vacancy_id_seq RESTART WITH 1;
	 
INSERT INTO hh.vacancy(company_id, position, description, salary_min, salary_max, required_exp,	required_skills)
VALUES
	 (1, 'web dev', 'нужно сделать сайт яндексу', 100000, 100010, 'опыт работы web dev от 2х лет', 'javascript, java, html, css'),
	 (2, 'designer', 'нужно поменять местами 2ю и 3ю буква логотипа google', 100000, 200000, 'окончить художку', 'фотошоп'),
	 (3, 'hr', 'искать сотрудников', 100000, 150000, 'опыт', 'microsoft office'),
	 (4, 'кассир', 'свободная касса!', null, '10000', 'опыт не нужен', 'терпение');

	 
------------------------------------------------------------------------------RESUME-------------------------------------------
TRUNCATE hh.resume CASCADE;
ALTER SEQUENCE IF EXISTS hh.resume_resume_id_seq RESTART WITH 1;
	 
INSERT INTO hh.resume(user_id, full_name, birthday, salary_min, salary_max, skills)
VALUES
	 (1, 'Андрей Вячеславович', '1996-07-29', null, null, 'programming'),
	 (2, 'Вовов Вова Владимирович', '1956-02-02', 10000, null, 'manager'),
	 (3, 'Петрова Екатерина Петровна', '1971-01-01', 120000, 200000, 'data science'),
	 (5, 'Кларк Кент (Кал Эл)', '1926-01-29', null, null, 'журналистика');

	 
--------------------------------------------------------------------------EXPERIENCE-------------------------------------------- 
TRUNCATE hh.experience CASCADE;
ALTER SEQUENCE IF EXISTS hh.experience_experience_id_seq RESTART WITH 1;
	 
INSERT INTO hh.experience(resume_id, company_id, position, description)
VALUES
	 (1, 1, 'software engineer', 'development'),
	 (2, 4, 'manager', 'managment'),
	 (4, null, 'freelance', 'youtube blog');
	 
--------------------------------------------------------------------------RESPONSE------------------------------------------------
TRUNCATE hh.response CASCADE;
ALTER SEQUENCE IF EXISTS hh.response_response_id_seq RESTART WITH 1;
	 
INSERT INTO hh.response(vacancy_id, resume_id, header, message)
VALUES
	(1, 1, 'Мы рады пригласить вас на работу', 'ПОздравление и тд...');
