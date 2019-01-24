DROP TABLE IF EXISTS application_letter CASCADE;
DROP TABLE IF EXISTS applicant_account CASCADE;
DROP TABLE IF EXISTS employer_account CASCADE;
DROP TABLE IF EXISTS vacancy CASCADE;

DROP TYPE IF EXISTS FIELD CASCADE;
DROP TYPE IF EXISTS APPLICANT_MOBITILY CASCADE;
DROP TYPE IF EXISTS TOWN CASCADE;
DROP TYPE IF EXISTS SCHEDULE CASCADE;

CREATE TYPE FIELD AS ENUM ('TRADING', 'SCIENCE & EDUCATION', 'SERVICE', 'IT', 'MANUFACTURING', 
						   'AGRO', 'MEDIA', 'PUBLIC RELATIONS', 'OTHER');

CREATE TYPE APPLICANT_MOBITILY AS ENUM ('MOVING', 'TRIP'); -- переезд и командироки соответственно --
								   
-- тут, конечно, нужен hh.api c деревом населенных пунктов --								   
CREATE TYPE TOWN AS ENUM ('MOSCOW', 'SAMARA', 'SAINT PETERSBURG', 'KAZAN', 
								'SKOTOPRIGONYEVSK', 'NOT SELECTED');

-- график работы (TOUR - вахта, ABNORMAL SCHEDULE - ненормированный рабочий график) --
CREATE TYPE SCHEDULE AS ENUM ('FLEX SCHEDULE', 'FULL-TIME', 'PART-TIME', 'REMOTE',
							 'TOUR', 'ABNORMAL SCHEDULE');
							 
-- Таблица учетных записей соискателей --
CREATE TABLE applicant_account (
	applicant_account_id 		SERIAL PRIMARY KEY,
	first_name 		VARCHAR(20) NOT NULL, 
	last_name 		VARCHAR(60) NOT NULL, 	-- на случай Ивана Сергеевича Пятитрясогусковича-Крестовоздвиженского --
	birth_date 		DATE,
	application_letter_id	INT [], 				--  --
	email 			VARCHAR(256),
	telephone_num 	VARCHAR(20)
);

-- Таблица резюме --
-- В эту таблицу входит та информация, которая касается непосредственно резюме о поиске работы --
-- Она будет использоваться работодателем при поиске соискателя (и работодателю на этом этапе действительно --
-- не так важны личные данные соискателя - имя, номер телефона и т.д.). --
CREATE TABLE application_letter (
	applicaion_letter_id		SERIAL PRIMARY KEY,
	applicant_account_id 			INT NOT NULL, 			-- для доступа к учетной записи соискателя --
	cv_header			VARCHAR (100) NOT NULL,	-- то, что будет высвечиваться в качестве заголовка при поиске ("инженер-технолог") --
	applicant_field     FIELD,
	curriculum_vitae	VARCHAR (2000),			-- для текста резюме --
	external_link 		VARCHAR(500) [],		-- для грамот, портфолио и прочих загружаемых документов --
	min_salary			INT,			-- если желаемая зарплата не указана, то рассматриваем все варианты --
	max_salary			INT, 	-- а-ля бесконечность --
	init_location 		TOWN,
	experience 			INT NOT NULL,
	work_schedule		SCHEDULE [],			-- если соискатель рассматривает разные графики --
	ready_to_move		APPLICANT_MOBITILY []		-- аналог set из MySQL реализован как массив enum'ов --
);											-- то есть может быть несколько вариантов ответа (например, ['командировки', 'переезд']) --


-- Таблица компаний-работодателей --
CREATE TABLE employer_account (
	employer_id		SERIAL PRIMARY KEY,
	company_name 	VARCHAR(60) NOT NULL, 	-- на случай Ивана Сергеевича Пятитрясогусковича-Крестовоздвиженского --
	vacancy_id		INT [], 				-- список вакансий, предлагаемых данной компанией-работодателем --
	email 			VARCHAR(256),			-- контакты отдела кадров
	telephone_num 	VARCHAR(20)
);

-- Таблица предлагаемых вакансий -- 
CREATE TABLE vacancy (
	vacancy_id		SERIAL PRIMARY KEY,
	employer_id		INT NOT NULL,
	vacancy_header 	VARCHAR(100) NOT NULL, 		-- название вакансии (как заголовок в поиске)
	vacancy_field	FIELD NOT NULL,
	description		VARCHAR (2000) NOT NULL,	-- описание вакансии (график, рабочие обязанности)
	min_salary		INT,	
	max_salary		INT, 
	experience 		INT, 			
	external_link 	VARCHAR(500) [],			-- ссылка на сайт организации-работодателя --
	job_location 	TOWN,
	work_schedule	SCHEDULE [],				-- если работодатель рассматривает разные графики --
	ready_to_move   APPLICANT_MOBITILY []			-- указание потребностей работодателя в перемещении свжего сотрудника --
);	 
	 

