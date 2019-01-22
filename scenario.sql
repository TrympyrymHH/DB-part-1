-- ПРИМЕРЫ ДЛЯ РАБОТОДАТЕЛЯ --

-- 1. Подыщем тракториста в Самаре с опытом больше 3 лет. Больше 30к не заплатим, но в командировки отправлять будем --
SELECT * FROM applicant
WHERE position('тракторист' in lower(cv_header)) <> 0
AND init_location = 'Самара'
AND min_salary < 30000
AND array_position(ready_to_move, 'командировки') <> 0
AND (experience = '3-6 лет' OR experience = '6-15 лет' OR experience = 'больше 15 лет');

-- 2. Подыщем тысяч за 200 общественного деятеля на полставки, чтобы откомандировать его в Норильск --
SELECT * FROM applicant
WHERE applicant_field = 'общественная деятельность'
AND min_salary <= 200000
AND array_position(ready_to_move, 'командировки') <> 0;

-- 3. Чем вообще по жизни занимается этот петербургский повеса помимо Английского клуба? --
SELECT * FROM applicant
WHERE account_id = 
(SELECT account_id FROM applicant WHERE position('повеса' in lower(cv_header)) <> 0)
AND position('повеса' in lower(cv_header)) = 0; 
-- опа, а повеса-граф ревоюционером подрабатывает на полставки --

----------------------------------------------------------------------------------------------------------

-- ПРИМЕРЫ ДЛЯ СОИСКАТЕЛЯ --

-- 1. Ищу работу как молодой тракторист (з/п не меньше 20к) --
SELECT * from vacancy
WHERE position('тракторист' in lower(vacancy_header)) <> 0
AND max_salary >= 20000
AND array_position(experience, '3-6 лет') <> 0;

-- 2. Рядом с домом находится колхоз, хочу найти там любую работу, обладая стажем 4 года --
SELECT * from vacancy 
WHERE employer_id = (SELECT employer_id FROM employer WHERE position('колхоз' in lower(company_name)) <> 0) 
AND array_position(experience, '3-6 лет') <> 0;
																	 
-- 3. Хочу удаленно заниматься черт знает чем в Петербурге, опыта нет --
SELECT * from vacancy 
WHERE vacancy_field = 'другое'
AND job_location = 'Санкт-Петербург'
AND array_position(experience, 'без опыта') <> 0;