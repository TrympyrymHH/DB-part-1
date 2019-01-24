-- Создадим аккаунты --

INSERT INTO applicant_account (first_name, last_name, birth_date, email, telephone_num) 
VALUES
	('Алевтина', 'Твердопупова', '1934-01-12', 'yagodka23@yandex.ru', '+79183244562'),
	('Поликарп', 'фон Шульцбергенхоф', '1881-11-02', 'aristocrator@rambler.ru', '+3993447566782'),
	('Шмуэль', 'Фукс', '1994-06-22', 'superman14@gmail.com', '+193457644562')
;

---------------------------------------------------------------------------------------------------------

-- Из-за того что некоторые данные могут опускаться при оставлении резюме, создадим несколько insert'ов в таблицу 
-- резюме с разным набором данных. Вот, например, Алевтина не указала максимальную зарплату (что естественно)
INSERT INTO application_letter (applicant_account_id, cv_header, applicant_field, curriculum_vitae, external_link,
					  min_salary, init_location, experience, work_schedule, ready_to_move) 
VALUES
	(1, 'Тракторист-зерноуборщик', 'AGRO',  '(тут CV Алевтины)', 
	 ARRAY['(тут ссылки на грамоту Алевтине как герою-трактористу)'], 20000,
	'SAMARA', 3, ARRAY['REMOTE']::SCHEDULE[], ARRAY['TRIP']::APPLICANT_MOBITILY[]);
-- и не забываем прикрепить резюме к аккаунту соответствующего соискателя --
-- тут id'шки аккаунта и резюме присутствуют в коде как "магические числа", но в "боевой" версии приложения --
-- будет доставать их из кэша сессии -- 
UPDATE applicant_account SET application_letter_id = application_letter_id || 1 WHERE applicant_account_id = 1;

-- А вот господин фон Шульцбергенхоф не указал опыт из-за страсти графа к продолжительным путешествиям  --
-- Да и финансовая сторона потомственного аристократа не заботит --
INSERT INTO application_letter (applicant_account_id, cv_header, applicant_field, curriculum_vitae, external_link,
					  experience, work_schedule, ready_to_move) 
VALUES
	(2, 'Великосветский повеса 8 разряда', 'OTHER',  '(тут CV-житие Поликарпа-аристократа)', 
	 ARRAY['(ссылка на благодарственное письмо от Его Величества)'], 
	15, ARRAY['FULL-TIME', 'TOUR']::SCHEDULE[], 
	ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);
UPDATE applicant_account SET application_letter_id = application_letter_id || 2 WHERE applicant_account_id = 2;
	
-- Но вообще у графа фон Шульцбергенхофе есть и другая сторона --
INSERT INTO application_letter (applicant_account_id, cv_header, applicant_field, curriculum_vitae, external_link,
					  min_salary, init_location, experience, work_schedule, ready_to_move) 
VALUES
	(2, 'Профессиональный революционер', 'PUBLIC RELATIONS',  '(тут CV Поликарпа-эсэра)', 
	 ARRAY['(ссылка на тайное письмо от Ленина)'], 180000, 
	'SAINT PETERSBURG', 3, ARRAY['REMOTE', 'PART-TIME']::SCHEDULE[], 
	ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);
UPDATE applicant_account SET application_letter_id = application_letter_id || 3 WHERE applicant_account_id = 2; 
	
-- Конкурентом Поликарпа по революционному ремеслу является некто Фукс, у которого нет прикрепленных ссылок --
INSERT INTO application_letter (applicant_account_id, cv_header, applicant_field, curriculum_vitae,
					  min_salary, init_location, experience, work_schedule, ready_to_move) 
VALUES
	(3, 'Самый профессиональный революционер', 
	'PUBLIC RELATIONS',  '(тут CV господина Фукса)', 200000, 'SAINT PETERSBURG', 5, 
	 ARRAY['REMOTE']::SCHEDULE[], ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);
UPDATE applicant_account SET application_letter_id = application_letter_id || 4 WHERE applicant_account_id = 3;

---------------------------------------------------------------------------------------------------------

-- Создадим учетные записи организаций-работодателей --

INSERT INTO employer_account (company_name, email, telephone_num) 
VALUES
	('Колхоз имени носков Ильича', 'gryaz@noski.su', '+791823244562'),
	('РСДРП(б)', 'vlast_sovetam@rsdrp.de', '+3993447566782'),
	('Бунд', 'kill_tzar@bund.com', '+193457644562')
;

----------------------------------------------------------------------------------------------------

-- Создадим вакансии --
	 
-- В колхоз требуется тракторист с опытом работы  --
INSERT INTO vacancy (employer_id, vacancy_header, vacancy_field, description, max_salary, experience, external_link, ready_to_move) 
VALUES
	(1, 'Тракторист с опытом работы', 'AGRO', 'Нужно весь день дыметь и рычать',  30000, 
	 5, ARRAY['noski.by'], ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);
-- А также нам надо привязать вакансию к учетной записи организации-работодателя 
UPDATE employer_account SET vacancy_id = vacancy_id || 1 WHERE employer_id = 1;	 

-- И в ЦНИИ свиноводства тракторист тоже не помешает --
INSERT INTO vacancy (employer_id, vacancy_header, vacancy_field, description, max_salary, external_link,
					   job_location, experience) 
VALUES
	(3, 'Молодой и перспективный тракторист', 'AGRO', 'Нужно весь день рычать и дыметь',  35000, ARRAY['schwine.de'], 'SAMARA', 0);
UPDATE employer_account SET vacancy_id = vacancy_id || 2 WHERE employer_id = 3;	  																			   
	
-- Также в колхоз требуется великосветский повеса 
-- (верхняя граница з/п не указана, потому что ставка устанавливается по результатам собеседования) --
INSERT INTO vacancy (employer_id, vacancy_header, vacancy_field, description, external_link, experience) 
VALUES
	(1, 'Великосветский повеса высшей категории', 'OTHER', 
		'Обязанности: просыпаться к обеду, носить монокль, курить опиум с другими повесами',  ARRAY['noski.by'], 3);
UPDATE employer_account SET vacancy_id = vacancy_id || 3 WHERE employer_id = 1;	  	
	 
-- А вот и вакансия революционера от Российской социал-демократической рабочей партии (большевиков) --
INSERT INTO vacancy (employer_id, vacancy_header, vacancy_field, description, max_salary, external_link, ready_to_move) 
VALUES
	(2, 'Революционер-большевик', 'PUBLIC RELATIONS',
	 'Обязанности: на горе всем буржуям раздувать мировой пожар, опыт значения не имеет',  200000, 
	 ARRAY['vlast_sovetam@rsdrp.de'], ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);
UPDATE employer_account SET vacancy_id = vacancy_id || 4 WHERE employer_id = 2;	  		 

	 