DROP TABLE IF EXISTS resume CASCADE;
DROP TABLE IF EXISTS applicant CASCADE;
DROP TABLE IF EXISTS employer CASCADE;
DROP TABLE IF EXISTS company CASCADE;
DROP TABLE IF EXISTS vacancy CASCADE;
DROP TABLE IF EXISTS town CASCADE;
DROP TABLE IF EXISTS experience CASCADE;
DROP TABLE IF EXISTS message CASCADE;
DROP TABLE IF EXISTS account CASCADE;

DROP TYPE IF EXISTS FIELD CASCADE;
DROP TYPE IF EXISTS APPLICANT_MOBITILY CASCADE;
DROP TYPE IF EXISTS SCHEDULE CASCADE;

CREATE TYPE FIELD AS ENUM ('TRADING', 'SCIENCE & EDUCATION', 'SERVICE', 'IT', 'MANUFACTURING', 
						   'AGRO', 'MEDIA', 'PUBLIC RELATIONS', 'OTHER');

CREATE TYPE APPLICANT_MOBITILY AS ENUM ('MOVING', 'TRIP'); -- переезд и командироки соответственно --

-- график работы (TOUR - вахта, ABNORMAL SCHEDULE - ненормированный рабочий график) --
CREATE TYPE SCHEDULE AS ENUM ('FLEX SCHEDULE', 'FULL-TIME', 'PART-TIME', 'REMOTE',
							 'TOUR', 'ABNORMAL SCHEDULE');

-------------------------------- СЛУЖЕБНЫЕ ТАБЛИЦЫ --------------------------------
							 
-- Таблица населенных пунктов --
-- тут, конечно, нужен hh.api c деревом населенных пунктов --								   
CREATE TABLE town (
	location_id		SERIAL PRIMARY KEY,
	town_name		VARCHAR(20) NOT NULL, 
	region 			VARCHAR(50), 	-- город === регион, как в случае Москвы, Петербурга и Севастополя --
	country			VARCHAR(20) NOT NULL 
);


-- Таблица аккаунтов заведена для авторизации. Поэтому она общая для соискателей и HR'ов --
CREATE TABLE account (
	account_id		SERIAL PRIMARY KEY,
	login			VARCHAR (256) NOT NULL UNIQUE,
	password		VARCHAR (30)
	);

-------------------------------- ТАБЛИЦЫ СОИСКАТЕЛЕЙ --------------------------------


-- Таблица учетных записей соискателей --
CREATE TABLE applicant (
	applicant_id		SERIAL PRIMARY KEY,
	account_id			INT REFERENCES account (account_id),
	first_name 			VARCHAR(20) NOT NULL, 
	last_name 			VARCHAR(60) NOT NULL, 	-- на случай господина Пятитрясогусковича-Крестовоздвиженского --
	birth_date 			DATE,			
	email 				VARCHAR(256),
	telephone_num 		VARCHAR(20)
);


-- Таблица резюме --
-- В эту таблицу входит та информация, которая касается непосредственно резюме о поиске работы --
-- Она будет использоваться работодателем при поиске соискателя (и работодателю на этом этапе действительно --
-- не так важны личные данные соискателя - имя, номер телефона и т.д.). --
CREATE TABLE resume (
	resume_id				SERIAL PRIMARY KEY,
	active					BOOLEAN,
	applicant_id 			INT REFERENCES applicant (applicant_id), 
	cv_header				VARCHAR (100) NOT NULL,	-- то, что будет высвечиваться в качестве заголовка при поиске --
	field     				FIELD [],				-- если работа на стыке разных областей деятельности --
	curriculum_vitae		TEXT,					-- для текста резюме --
	external_link 			VARCHAR(500) [],		-- для грамот, портфолио и прочих загружаемых документов --
	min_salary				INT,					-- если желаемая зарплата не указана, то рассматриваем все варианты --
	max_salary				INT, 					-- а-ля бесконечность --
	init_location_id 		INT REFERENCES town (location_id),
	experience 				INT,			
	work_schedule			SCHEDULE [],			-- если соискатель рассматривает разные графики --
	ready_to_move			APPLICANT_MOBITILY []	-- аналог SET из MySQL реализован как массив enum'ов, --
);													-- то есть может быть несколько вариантов ответа (например, ['командировки', 'переезд']) --


-- Таблица трудовых похождений соискателей--
CREATE TABLE experience (
	experience_id 	SERIAL PRIMARY KEY,
	applicant_id 	INT REFERENCES applicant (applicant_id),
	date_start 		DATE NOT NULL,
	date_finish 	DATE NOT NULL,
	company_name 	VARCHAR(512) NOT NULL,
	job_position	VARCHAR(512) NOT NULL,
	description 	TEXT
);

-------------------------------- ТАБЛИЦЫ РАБОТОДАТЕЛЕЙ --------------------------------


-- Таблица компаний-работодателей --
CREATE TABLE company (
	company_id		SERIAL PRIMARY KEY,
	company_name 	VARCHAR(120) NOT NULL,	 
	description		TEXT NOT NULL,			-- описание компании --
	external_link 	VARCHAR(500) [],		-- ссылка на сайт организации-работодателя и прочие внешние ссылки --
	email 			VARCHAR(256),			-- контакты отдела кадров --
	telephone_num 	VARCHAR(20)
);


-- Таблица представителей компаний-работодателей --
CREATE TABLE employer (
	employer_id		SERIAL PRIMARY KEY,
	account_id 		INT REFERENCES account (account_id),
	company_id		INT NOT NULL REFERENCES company (company_id),
	first_name 		VARCHAR(60), 				-- ФИО можно не указывать --
	last_name 		VARCHAR(60), 	
	email 			VARCHAR(256),				-- контакты представителя компании --
	telephone_num 	VARCHAR(20)
);


-- Таблица предлагаемых вакансий -- 
CREATE TABLE vacancy (
	vacancy_id		SERIAL PRIMARY KEY,
	active			BOOLEAN,
	company_id		INT NOT NULL REFERENCES company (company_id),
	vacancy_header 	VARCHAR(100) NOT NULL, 		-- название вакансии (как заголовок в поиске) --
	field			FIELD [],
	description 	VARCHAR (1000),
	min_salary		INT,	
	max_salary		INT, 
	experience 		INT, 			
	location_id 	INT REFERENCES town (location_id),
	work_schedule	SCHEDULE [],				-- если работодатель рассматривает разные графики --
	ready_to_move   APPLICANT_MOBITILY []		-- указание потребностей работодателя в перемещении свжего сотрудника --
);	  


-------------------------------- СЛУЖЕБНЫЕ ТАБЛИЦЫ (ПРОДОЛЖЕНИЕ) --------------------------------

-- таблица с сообщениями -- 
CREATE TABLE message(
	message_id 	SERIAL PRIMARY KEY,
	vacancy_id 	INT REFERENCES vacancy (vacancy_id),
	resume_id 	INT REFERENCES resume (resume_id),
	time_create TIMESTAMP NOT NULL,
	unread 		BOOLEAN NOT NULL 	-- прочитано или не прочитано
);
	 
