TRUNCATE headhunter.users CASCADE;
ALTER SEQUENCE IF EXISTS headhunter.users_users_id_seq RESTART;

INSERT INTO headhunter.users(login, password, time_register)
VALUES 
    ('vasya', 	md5('querty'), now()),
    ('petya', 	md5('123456'), now()),
    ('kostya', 	md5('qazwsx'), now()),
    ('vanya', 	md5('querty'), now()),
    ('natasha', md5('000000'), now()),
    ('sveta', 	md5('******'), now()),
    ('vova', 	  md5('querty'), now()),
    ('superman',md5('querty'), now()),
    ('batman', 	md5('querty'), now());

------------------------------------------------------------------------------------------------------------------------

TRUNCATE headhunter.company CASCADE;
ALTER SEQUENCE IF EXISTS headhunter.company_company_id_seq RESTART;

INSERT INTO headhunter.company(name, description, path_to_logo)
VALUES 
    ('Майкрософт', 'молодая подающая надежды компания', 'c:/logos/ms.logo'),
    ('Гугл', 'мы умеем говорить ОК', 'c:/logos/gl.logo'),
    ('Яху', 'Описание компании', 'c:/logos/ms.logo'),
    ('ИП Виноградова', 'В 2018 году мы подняли продажи на 100%, реализовав целых 2 принтера!', 'c:/logos/ms.logo'),
    ('ООО "Рога & Копыта"', 'Магазин охотничьих трофеев', 'c:/logos/ms.logo');

------------------------------------------------------------------------------------------------------------------------

TRUNCATE headhunter.user_to_company_rights;
ALTER SEQUENCE IF EXISTS headhunter.user_to_company_rights_user_to_company_rights_id_seq RESTART;

INSERT INTO headhunter.user_to_company_rights(user_to_company_rights_id, name, description)
VALUES
    (0,'Создатель',     'Главный победитель и ROOT по жизни'),
    (1,'Администратор', 'Смотрящий'),
    (2,'HR',            'Человек, рулящий вакансиями в организации'),
    (3,'Младший помошник HR', 'Просмотр откликов без возможности редактирования');

------------------------------------------------------------------------------------------------------------------------

TRUNCATE headhunter.user_to_company_relations;
ALTER SEQUENCE IF EXISTS headhunter.user_to_company_relations_user_to_company_relations_id_seq RESTART;

INSERT INTO headhunter.user_to_company_relations(user_id, company_id, rights, time_updated,who_update)
VALUES
    (2,1,'{0,1}',now(),1),
    (3,1,'{2}',now(),1),
    (5,2,'{0,1}',now(),1),
    (6,3,'{3}',now(),1),
    (8,4,'{0}',now(),1),
    (8,5,'{3}',now(),1);

------------------------------------------------------------------------------------------------------------------------

TRUNCATE headhunter.vacancy CASCADE;
ALTER SEQUENCE IF EXISTS headhunter.vacancy_vacancy_id_seq RESTART;

INSERT INTO headhunter.vacancy
(	company_id, 
	"position", 
	description, 
	salary_min, salary_max, 
	wanted_experience, 
	wanted_skills, 
	time_to_unpublish,
  salary_currency,
  time_created)
VALUES 
(	1,
	'Уборщица',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{"2 высших профильных образования","английский intermediate","опыт работы в высоконагруженных системах"}',
	'2019-01-01',
	'RUR',
	now()),
	
(	1,
	'Сторож',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{"2 высших профильных образования","английский intermediate"}',
	'2019-01-01',
	'RUR',
	now()),
	
(	2,
	'Программист BrainF*ck',
	'Описание',
	25000, 30000,
	'опыт работы в высоконагруженных системах',
	'{"3 высших профильных образования","английский godlike","опыт работы в аду"}',
	'2019-01-01',
	'RUR',
	now()),
	
(	2,
	'PHP Developer',
	'нужен фронтенд разработчик',
	10000, 20000,
	'компьютерщик на все руки',
	'{"установка windows всех версий","заправка картриджей","настройка программ", "Программирование, Разработка"}',
	'2019-01-01',
	'RUR',
	now()),
	
(	4,
	'Уборщица',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{"2 высших профильных образования","английский intermediate","опыт работы в высоконагруженных системах"}',
	'2019-01-01',
	'RUR',
	now());

------------------------------------------------------------------------------------------------------------------------
TRUNCATE headhunter.resume CASCADE;
ALTER SEQUENCE IF EXISTS headhunter.resume_resume_id_seq RESTART;

INSERT INTO headhunter.resume
(	user_id, 
	"position", 
	fio, 
	age, 
        salary_min, 
        salary_max, 
        salary_currency, 
        skills,
        time_created,
        time_updated)
VALUES 
(	5,
	'Программист C++ (стажёр)',
	'Иванов Василий',
	25,
	50000,
	70000,
	'RUR',
	'{"Информационные технологии","Интернет","Мультимедиа"}',
	now(),
	NOW() + interval '1 month'
	),
	
(	6,
	'рограммист C/С++ (Builder, Qt)',
	'Иванов Пётр',
	55,
	10000,
	170000,
	'RUR',
	'{"Информационные технологии","Интернет","телеком","Программирование, Разработка", "Компьютерная безопасность"}',
	now(),
	NOW() + interval '1 month'),

(	7,
	'Ведущий программист С++)',
	'Иванов Геннадий',
	34,
	70000,
	70000,
	'RUR',
	'{"Информационные технологии","Сетевые технологии","Телекоммуникации"}',
	now(),
	NOW() + interval '1 month'),

(	8,
	'Программист С++',
	'Иванов Николай',
	72,
	18000,
	20000,
	'RUR',
	'{"Информационные технологии","Поддержка, Helpdesk", " Работа в SONY VEGAS 7"}',
	now(),
	NOW() + interval '1 month'),

(	8,
	'Программист (Junior C++)',
	'Иванов Иван',
	23,
	50000,
	50010,
	'RUR',
	'{"Информационные технологии","Производство, Технологии"}',
	now(),
	NOW() + interval '1 month');

------------------------------------------------------------------------------------------------------------------------
TRUNCATE headhunter.resume_experience CASCADE;
ALTER SEQUENCE IF EXISTS headhunter.resume_experience_resume_experience_id_seq RESTART;

INSERT INTO headhunter.resume_experience(
            resume_id, 	time_start, 	time_finish, 	"position", 	description)
VALUES
(		2,	'2017-01-05',	'2018-05-01',	'инженер-программист',	
'Должность: инженер-программист.
Деятельность: разработка системы визуализации территории и объектов военных действий, оснащённой функциями масштабирования, измерения углов, расстояний и определения относительных координат, для береговых ракетных систем средней дальности.'
),

(		2,	'2015-05-01',	'2019-01-02',	'ведущий инженер отдела',	
'Деятельность: разработка программного обеспечения для систем автоматического управления и обмена информацией со спутниками связи. Разработка велась под Linux (Debian, МСВС) с использованием Qt, выдача заданий в виде UML-диаграмм. Контроль версий с помощью SVN.'
),

(		2,	'2019-01-02',	'2020-04-06',	'программист',	
'Деятельность: разработка программного обеспечения для систем тестирования и программирования гиростабиллизированных платформ с блоком акселерометров третьего поколения для ракетных систем'
),

(		2,	'2011-02-02',	'2017-01-05',	'ведущий инженер',	
'Должность: программист.
Деятельность: разработка программного обеспечения для устройств коммутации и программирования, а также обработки и воспроизведения звуковой информации со звукозаписывающих устройств'
),

(		2,	'2009-01-05',	'2011-02-01',	'Программист C/С++',	
'Разработка и поддержка программного обеспечения для учёта, внесения в БД и обработки данных абонентов, а также тех. поддержка менеджеров по вопросам использования ПО.Написание SQL-запросов для построения сложных отчётов, интеграция SQL-запросов в C++ приложения, разработка приложений на C++ Builder и Delphi с использованием FastReport, EhLib, DevExpress, ODAC, MyDAC. Контроль версий с помощью Git.'
);
------------------------------------------------------------------------------------------------------------------------
TRUNCATE headhunter.messages CASCADE;
ALTER SEQUENCE IF EXISTS headhunter.messages_messages_id_seq RESTART;

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'invite',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,100) ;

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'reply',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,100) ;

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'message_to_resume',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,10000) ;

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'message_to_vacancy',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,10000) ;
