-- АВТОРИЗАЦИЯ --

-- Пользователь ввел пароль для логина 'yagodka23@yandex.ru' --
SELECT password FROM account WHERE login = 'yagodka23@yandex.ru';
-- Если пароль совпал с введенным, то: --
UPDATE account SET online = TRUE WHERE login = 'yagodka23@yandex.ru';


-- ПРИМЕРЫ ДЛЯ РАБОТОДАТЕЛЯ --

-- 1. Подыщем тракториста в Самаре с опытом больше 3 лет. Больше 30к не заплатим, но в командировки отправлять будем --
SELECT * FROM resume
	WHERE active = TRUE
	AND position('тракторист' in lower(cv_header)) <> 0
  	AND init_location_id = (SELECT location_id FROM town WHERE town_name = 'Самара')
	AND (min_salary < 30000 OR min_salary=NULL)   -- если минимальную приемлемую з/п соискатель в резюме не указал -- 
	AND array_position(ready_to_move, 'TRIP') <> 0
	AND experience > 3;

-- 2. Подыщем тысяч за 200 общественного деятеля на полставки, чтобы откомандировать его в Норильск --
SELECT * FROM resume
	WHERE active = TRUE
	AND array_position(field, 'PUBLIC RELATIONS') <> 0
	AND (min_salary <= 200000 OR min_salary=NULL)
	AND array_position(ready_to_move, 'TRIP') <> 0;

-- 3. Чем вообще по жизни занимается этот петербургский повеса помимо Английского клуба? --
SELECT * FROM resume
WHERE applicant_id = (SELECT applicant_id FROM resume WHERE position('повеса' in lower(cv_header)) <> 0)
	AND position('повеса' in lower(cv_header)) = 0; 
-- опа, а повеса-граф ревоюционером подрабатывает на полставки --

----------------------------------------------------------------------------------------------------------

-- ПРИМЕРЫ ДЛЯ СОИСКАТЕЛЯ --

-- 1. Ищу работу как молодой тракторист (з/п не меньше 20к) --
SELECT * from vacancy
WHERE position('тракторист' in lower(vacancy_header)) <> 0
 	AND max_salary >= 20000
	AND experience >= 3;

-- 2. Рядом с домом находится колхоз, хочу найти там любую работу, обладая стажем 4 года --
SELECT * from vacancy 
WHERE company_id = (SELECT company_id FROM company WHERE position('колхоз' in lower(company_name)) <> 0) 
AND experience >= 3;
																	 
-- 3. Хочу удаленно заниматься черт знает чем и черт знает где, а опыта нет --
SELECT * from vacancy 
WHERE array_position(field, 'OTHER') <> 0
AND experience >= 0;
																  

-- ОБЩИЕ СЦЕНАРИИ --
																  
-- Поликарп-повеса пишет письмо Ленину по поводу вакансии революционера --													
INSERT INTO message (vacancy_id, resume_id, time_create, unread)
VALUES
	(2, 2, 'Привет, Ильич!', FALSE);
																			 