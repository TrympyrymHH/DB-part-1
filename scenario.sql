-- ПРИМЕРЫ ДЛЯ РАБОТОДАТЕЛЯ --

-- 1. Подыщем тракториста в Самаре с опытом больше 3 лет. Больше 30к не заплатим, но в командировки отправлять будем --
SELECT * FROM application_letter
WHERE position('тракторист' in lower(cv_header)) <> 0
AND init_location = 'SAMARA'
AND (min_salary < 30000 OR min_salary=NULL)   -- если минимальную приемлемую з/п соискатель в резюме не указал -- 
AND array_position(ready_to_move, 'TRIP') <> 0
AND experience > 3;

-- 2. Подыщем тысяч за 200 общественного деятеля на полставки, чтобы откомандировать его в Норильск --
SELECT * FROM application_letter
WHERE applicant_field = 'PUBLIC RELATIONS'
AND (min_salary <= 200000 OR min_salary=NULL)
AND array_position(ready_to_move, 'TRIP') <> 0;

-- 3. Чем вообще по жизни занимается этот петербургский повеса помимо Английского клуба? --
SELECT * FROM application_letter
WHERE applicant_account_id = (SELECT applicant_account_id FROM application_letter WHERE position('повеса' in lower(cv_header)) <> 0)
AND position('повеса' in lower(cv_header)) = 0; 
-- опа, а повеса-граф ревоюционером подрабатывает на полставки --

----------------------------------------------------------------------------------------------------------

-- ПРИМЕРЫ ДЛЯ СОИСКАТЕЛЯ --

-- 1. Ищу работу как молодой тракторист (з/п не меньше 20к) --
SELECT * from vacancy
WHERE position('тракторист' in lower(vacancy_header)) <> 0
AND (max_salary >= 20000 OR min_salary=NULL)
AND experience >= 3;

-- 2. Рядом с домом находится колхоз, хочу найти там любую работу, обладая стажем 4 года --
SELECT * from vacancy 
WHERE employer_id = (SELECT employer_id FROM employer_account WHERE position('колхоз' in lower(company_name)) <> 0) 
AND experience >= 3;
																	 
-- 3. Хочу удаленно заниматься черт знает чем и черт знает где, а опыта нет --
SELECT * from vacancy 
WHERE vacancy_field = 'OTHER'
AND experience >= 0;
																		
																			 