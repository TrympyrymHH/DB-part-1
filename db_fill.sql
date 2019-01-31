-- Заполним таблицу с городами --

INSERT INTO town (town_name, region, country) 
VALUES
	('Москва', NULL, 'Россия'), 
	('Санкт-Петербург', NULL, 'Россия'),
	('Самара', 'Cамарская область', 'Россия'),
	('Cкотопригоньевск', 'N-ская губерния', 'Россия')
;

---------------------------------------------------------------------------------------------------------

-- Заполним таблицу аккаунтов --

INSERT INTO account (login, password)
VALUES
	-- соискатели -- 
	('yagodka23@yandex.ru', '12345'), -- Алевтина -- 
	('aristocrator@rambler.ru', 'qwerty'), -- Поликарп -- 
	('superman14@gmail.com', 'password'), -- Шмуэль -- 
	('gryaz@noski.su', 'qwerty'), -- HR колхоза -- 
	('lenin@yandex.ru', '123456'), -- у РСДРП(б) два менеджера -- 
	('trotsky@yandex.ru', '12345'),
	('klop17@gmail.com', 'password') -- а у Бунда только один -- 
;

---------------------------------------------------------------------------------------------------------

-- Заполним таблицу соискателей --

INSERT INTO applicant (first_name, last_name, birth_date, email, telephone_num) 
VALUES
	('Алевтина', 'Твердопупова', '1934-01-12', 'yagodka23@yandex.ru', '+79183244562'),
	('Поликарп', 'фон Шульцбергенхоф', '1881-11-02', 'aristocrator@rambler.ru', '+3993447566782'),
	('Шмуэль', 'Фукс', '1984-06-22', 'superman14@gmail.com', '+193457644562')
;
---------------------------------------------------------------------------------------------------------


-- Из-за того что некоторые данные могут опускаться при оставлении резюме, создадим несколько insert'ов в таблицу 
-- резюме с разным набором данных. Вот, например, Алевтина из Самары не указала максимальную зарплату (что естественно)
INSERT INTO resume (active, applicant_id, cv_header, field, curriculum_vitae, external_link,
					  min_salary, init_location_id, work_schedule, ready_to_move) 
VALUES
	(TRUE, 1, 'Тракторист-зерноуборщик', ARRAY['AGRO']::FIELD[],  '(тут CV Алевтины)', 
	 ARRAY['(тут ссылки на грамоту Алевтине как герою-трактористу)'], 20000,
	3, ARRAY['REMOTE']::SCHEDULE[], ARRAY['TRIP']::APPLICANT_MOBITILY[]);


-- А вот господин фон Шульцбергенхоф не указал опыт из-за страсти графа к продолжительным путешествиям  --
-- Да и финансовая сторона потомственного аристократа не заботит --
INSERT INTO resume (active, applicant_id, cv_header, field, curriculum_vitae, external_link,
					  work_schedule, ready_to_move) 
VALUES
	(TRUE, 2, 'Великосветский повеса 8 разряда', ARRAY['OTHER']::FIELD[],  '(тут CV-житие Поликарпа-аристократа)', 
	 ARRAY['(ссылка на благодарственное письмо от Его Величества)'], 
	ARRAY['FULL-TIME', 'TOUR']::SCHEDULE[], ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);
	
-- Но вообще у графа фон Шульцбергенхофе есть и другая сторона, которую он пока не афиширует --
INSERT INTO resume (active, applicant_id, cv_header, field, curriculum_vitae, external_link,
					  min_salary, init_location_id, work_schedule, ready_to_move) 
VALUES
	(FALSE, 2, 'Профессиональный революционер', ARRAY['PUBLIC RELATIONS']::FIELD[],  '(тут CV Поликарпа-эсэра)', 
		ARRAY['(ссылка на тайное письмо от Ленина)'], 180000, 2, 
		ARRAY['REMOTE', 'PART-TIME']::SCHEDULE[], ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);
	
-- Конкурентом Поликарпа по революционному ремеслу является некто Фукс из Петрограда, у которого нет прикрепленных ссылок --
INSERT INTO resume (active, applicant_id, cv_header, field, curriculum_vitae,
					  min_salary, init_location_id, work_schedule, ready_to_move) 
VALUES
	(TRUE, 3, 'Самый профессиональный революционер', 
	ARRAY['PUBLIC RELATIONS']::FIELD[],  '(тут CV господина Фукса)', 200000, 2, 
	 ARRAY['REMOTE']::SCHEDULE[], ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);

---------------------------------------------------------------------------------------------------------

-- Заполним таблицу трудовых похождений соискателей --

INSERT INTO experience (applicant_id, date_start, date_finish, company_name, job_position, description) 
VALUES
	(1, '1974-01-12', '1979-04-11', 'Совхоз Красные зорьки', 'Тракторист-зерноуборщик', 'Пахала поля, чинила двигатель'),
	(2, '1903-01-12', '1913-03-23', 'Английский клуб', 'Великосветский повеса 7 разряда', 
		'Светил лицом в лучших домах Петербурга; ненизко кланялся (не всем)'),
	(2, '1913-04-12', '1920-03-23', 'Эсэр Company Inc.', 'Агитатор', 
	'Сподвигал крестянские массы к социал-демократической революции (не очень удачно)'),
	(3, '1914-01-12', '1925-03-23', 'Совет народных депутатов', 'Братель Зимнего дворца высшей категории', 
	'Брал Зимнего Дворца (удачно)')
;

-------------------------------- ТАБЛИЦЫ РАБОТОДАТЕЛЕЙ --------------------------------

-- Создадим учетные записи организаций-работодателей --

INSERT INTO company (company_name, description, external_link, email, telephone_num) 
VALUES
	('Колхоз имени носков Ильича', 'Пашем поле со времен Рюрика', ARRAY['noski.su'], 'gryaz@noski.su', '+791823244562'),
	('РСДРП(б)', 'Революционируем со времен Александра III', ARRAY['rsdrp.de'], 'vlast_sovetam@rsdrp.de', '+3993447566782'),
	('Бунд', 'Свобода! Равенство! Упячка!', ARRAY['bund.com'], 'kill_tzar@bund.com', '+193457644562')
;

-- Создадим учетные записи представителей работодателей --

INSERT INTO employer (account_id, company_id, first_name, last_name, email, telephone_num) 
VALUES
	(4, 1, 'Фрол', 'Ефремыч', 'gryaz@noski.su', '+791823244562'),
	(5, 2, 'Владимир', 'Ульянов', 'lenin@yandex.ru', '+3993447566782'),
	(6, 2, 'Лев', 'Бронштейн', 'trotsky@yandex.ru', '+3993447566783'),
	(7, 3, NULL, NULL, 'klop17@bund.com', '+193457644562') -- менеджер пожелал остаться инкогнито (коспирация, все дела) --
;

----------------------------------------------------------------------------------------------------

-- Создадим вакансии --
	 
-- В колхоз требуется тракторист с опытом работы  --
INSERT INTO vacancy (active, company_id, vacancy_header, field, description, max_salary, experience, ready_to_move) 
VALUES
	(TRUE, 1, 'Тракторист с опытом работы', ARRAY['AGRO']::FIELD[], 'Нужно весь день дыметь и рычать',  30000, 
	 5, ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]);														   	

-- Также в колхоз требуется великосветский повеса 
-- (верхняя граница з/п не указана, потому что ставка устанавливается по результатам собеседования) --
INSERT INTO vacancy (active, company_id, vacancy_header, field, description, experience) 
VALUES
	(TRUE, 1, 'Великосветский повеса высшей категории', ARRAY['OTHER']::FIELD[], 
		'Обязанности: просыпаться к обеду, носить монокль, курить опиум с другими повесами', 3);	
	 

-- А вот и вакансия революционера от Российской социал-демократической рабочей партии (большевиков) --
INSERT INTO vacancy (active, company_id, vacancy_header, field, description, max_salary, ready_to_move) 
VALUES
	(TRUE, 2, 'Революционер-большевик', ARRAY['PUBLIC RELATIONS']::FIELD[],
	 'Обязанности: на горе всем буржуям раздувать мировой пожар, опыт значения не имеет',  200000, ARRAY['MOVING', 'TRIP']::APPLICANT_MOBITILY[]); 


-- И в Бунд тракторист тоже не помешает: чтобы разгребать баррикады --
INSERT INTO vacancy (active, company_id, vacancy_header, field, description, max_salary,
					   location_id, experience) 
VALUES
	(TRUE, 3, 'Молодой и перспективный тракторист', ARRAY['AGRO']::FIELD[], 'Нужно весь день рычать, дыметь и сметать баррикады',  35000, 2, 0);


-- А вот как раз ревоюционеры уже не очень нужны: и так штат переполнен --
INSERT INTO vacancy (active, company_id, vacancy_header, field, description, max_salary,
					   location_id, experience) 
VALUES
	(FALSE, 3, 'Молодой и перспективный ревлюционер', ARRAY['PUBLIC RELATIONS', 'MEDIA']::FIELD[], 'Нужно весь день орать и сподвигать',  35000, 3, 0);	 	
	 
-- Уточним графу опыта в резюме (понимаю, что грубо, но сроки сжаты) --
UPDATE resume SET experience =
	(SELECT SUM (DATE_PART('year', date_finish::date) - DATE_PART('year', date_start::date)) FROM experience WHERE applicant_id = 1)
			WHERE applicant_id = 1;			 
UPDATE resume SET experience =
	(SELECT SUM (DATE_PART('year', date_finish::date) - DATE_PART('year', date_start::date)) FROM experience WHERE applicant_id = 2)
			WHERE applicant_id = 2;			 
UPDATE resume SET experience =
	(SELECT SUM (DATE_PART('year', date_finish::date) - DATE_PART('year', date_start::date)) FROM experience WHERE applicant_id = 3)
			WHERE applicant_id = 3;
	 
	 
	 
	 