TRUNCATE new_big.account CASCADE;

INSERT INTO new_big.account(account_id, login, password, time_register)
VALUES
    (1,'vasya', 	md5('querty'), now()),
    (2,'petya', 	md5('123456'), now()),
    (3, 'kostya', 	md5('qazwsx'), now()),
    (4,'vanya', 	md5('querty'), now()),
    (5,'natasha', md5('000000'), now()),
    (6,'sveta', 	md5('******'), now()),
    (7,'vova', 	  md5('querty'), now()),
    (8,'superman',md5('querty'), now()),
    (9,'batman', 	md5('querty'), now());

ALTER SEQUENCE IF EXISTS new_big.account_account_id_seq RESTART WITH 10;

------------------------------------------------------------------------------------------------------------------------

TRUNCATE new_big.company CASCADE;

INSERT INTO new_big.company(company_id, name, description, path_to_logo)

VALUES
    (1, 'Майкрософт', 'молодая подающая надежды компания', 'c:/logos/ms.logo'),
    (2, 'Гугл', 'мы умеем говорить ОК', 'c:/logos/gl.logo'),
    (3, 'Яху', 'Описание компании', 'c:/logos/ms.logo'),
    (4, 'ИП Виноградова', 'В 2018 году мы подняли продажи на 100%, реализовав целых 2 принтера!', 'c:/logos/ms.logo'),
    (5, 'ООО "Рога & Копыта"', 'Магазин охотничьих трофеев', 'c:/logos/ms.logo');

ALTER SEQUENCE IF EXISTS new_big.company_company_id_seq RESTART WITH 6;

------------------------------------------------------------------------------------------------------------------------

TRUNCATE new_big.acc_to_comp_permission;

INSERT INTO new_big.acc_to_comp_permission(acc_to_comp_permission_id, name, description)
VALUES
    (1,'Создатель',           'Главный победитель и ROOT по жизни'),
    (2,'Администратор',       'Смотрящий без права просмотра откликов'),
    (3,'HR',                  'Человек, рулящий вакансиями в организации'),
    (4,'Младший помошник HR', 'Просмотр откликов без возможности редактирования');

ALTER SEQUENCE IF EXISTS new_big.acc_to_comp_permission_acc_to_comp_permission_id_seq RESTART WITH 4;

------------------------------------------------------------------------------------------------------------------------
TRUNCATE new_big.skill;

INSERT INTO new_big.skill(skill_id, name)
VALUES
    (1, '2 высших профильных образования'),
    (2, 'английский intermediate'),
    (3, 'опыт работы в высоконагруженных системах'),
    (4, '3 высших профильных образования'),
    (5, 'английский godlike'),
    (6, 'опыт работы в аду'),
    (7, 'установка windows всех версий'),
    (8, 'заправка картриджей'),
    (9, 'настройка программ'),
    (10, 'Программирование, Разработка'),
    (11, 'Информационные технологии'),
    (12, 'Интернет'),
    (13, 'Мультимедиа'),
    (14, 'телеком'),
    (15, 'Компьютерная безопасность'),
    (16, 'Сетевые технологии'),
    (17, 'Телекоммуникации'),
    (18, 'Поддержка'),
    (19, 'Helpdesk'),
    (20, 'Работа в SONY VEGAS 7'),
    (21, 'Производство'),
    (22, 'Технологии успеха'),
    (23, 'Технологии');

ALTER SEQUENCE IF EXISTS new_big.skill_skill_id_seq RESTART WITH 24;

------------------------------------------------------------------------------------------------------------------------

TRUNCATE new_big.account_to_company_relation;

ALTER SEQUENCE IF EXISTS new_big.account_to_company_relation_account_to_company_relation_id_seq RESTART;

INSERT INTO new_big.account_to_company_relation(account_id, company_id, rights, time_updated,who_update)
VALUES
    (2,1,'{0,1}',now(),1),
    (3,1,'{2}',now(),1),
    (5,2,'{0,1}',now(),1),
    (6,3,'{3}',now(),1),
    (8,4,'{0}',now(),1),
    (8,5,'{3}',now(),1);

------------------------------------------------------------------------------------------------------------------------

TRUNCATE new_big.vacancy CASCADE;

ALTER SEQUENCE IF EXISTS new_big.vacancy_vacancy_id_seq RESTART;

INSERT INTO new_big.vacancy
(	company_id,
	position,
	description,
	salary_min, salary_max,
	wanted_experience,
	wanted_skill_ids,
	time_to_unpublish,
  time_created)
VALUES
(	1,
	'Уборщица MS',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{1,2,3}',
	'2019-01-01',
	now()),

(	1,
	'Сторож',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{1,2}',
	'2019-01-01',

	now()),

(	2,
	'Программист BrainF*ck',
	'Описание',
	25000, 30000,
	'опыт работы в высоконагруженных системах',
	'{4,5,6}',
	'2019-01-01',
	now()),

(	2,
	'PHP Developer',
	'нужен фронтенд разработчик',
	10000, 20000,
	'компьютерщик на все руки',
	'{7,8,9, 10}',
	'2019-01-01',
	now()),

(	4,
	'Уборщица ИП',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{1,2,3}',
	'2019-01-01',
	now());

------------------------------------------------------------------------------------------------------------------------
TRUNCATE new_big.resume CASCADE;

ALTER SEQUENCE IF EXISTS new_big.resume_resume_id_seq RESTART;

INSERT INTO new_big.resume
(	account_id,
	position,
	fio,
	birthday,
  salary_min,
  salary_max,
  skill_ids,
  time_created,
  time_updated)
VALUES
(	5,
	'Программист C++ (стажёр)',
	'Иванов Василий',
	'1983-05-04',
	50000,
	70000,
	'{11,12,13}',
	now(),
	NOW() + interval '1 month'
	),

(	6,
	'рограммист C/С++ (Builder, Qt)',
	'Иванов Пётр',
	'1973-05-01',
	10000,
	170000,
	'{11,12,14,10,15,1}',
	now(),
	NOW() + interval '1 month'),

(	7,
	'Ведущий программист С++)',
	'Иванов Геннадий',
	'1993-06-04',
	70000,
	70000,
	'{11,16,17,3}',
	now(),
	NOW() + interval '1 month'),

(	8,
	'Программист С++',
	'Иванов Николай',
	'1912-01-01',
	18000,
	20000,
	'{11,18,19, 20,6}',
	now(),
	NOW() + interval '1 month'),

(	8,
	'Программист (Junior C++)',
	'Иванов Иван',
	'1989-01-04',
	50000,
	50010,
	'{11,21,22,8}',
	now(),
	NOW() + interval '1 month');

------------------------------------------------------------------------------------------------------------------------
TRUNCATE new_big.resume_experience CASCADE;

ALTER SEQUENCE IF EXISTS new_big.resume_experience_resume_experience_id_seq RESTART;

INSERT INTO new_big.resume_experience(
            resume_id, 	date_start, 	date_finish, company_name, 	position, 	description)
VALUES
(		2,	'2017-01-05',	'2018-05-01',	'Компания 1 ', 'инженер-программист',
'Должность: инженер-программист.
Деятельность: разработка системы визуализации территории и объектов военных действий, оснащённой функциями масштабирования, измерения углов, расстояний и определения относительных координат, для береговых ракетных систем средней дальности.'
),

(		3,	'2015-05-01',	'2019-01-02', 'Компания 2 ', 	'ведущий инженер отдела',
'Деятельность: разработка программного обеспечения для систем автоматического управления и обмена информацией со спутниками связи. Разработка велась под Linux (Debian, МСВС) с использованием Qt, выдача заданий в виде UML-диаграмм. Контроль версий с помощью SVN.'
),

(		4,	'2019-01-02',	'2020-04-06', 'Компания 3 ', 	'программист',
'Деятельность: разработка программного обеспечения для систем тестирования и программирования гиростабиллизированных платформ с блоком акселерометров третьего поколения для ракетных систем'
),

(		5,	'2011-02-02',	'2017-01-05', 'Компания 4 ', 	'ведущий инженер',
'Должность: программист.
Деятельность: разработка программного обеспечения для устройств коммутации и программирования, а также обработки и воспроизведения звуковой информации со звукозаписывающих устройств'
),

(		5,	'2009-01-05',	'2011-02-01','Компания 5 ', 	'Программист C/С++',
'Разработка и поддержка программного обеспечения для учёта, внесения в БД и обработки данных абонентов, а также тех. поддержка менеджеров по вопросам использования ПО.Написание SQL-запросов для построения сложных отчётов, интеграция SQL-запросов в C++ приложения, разработка приложений на C++ Builder и Delphi с использованием FastReport, EhLib, DevExpress, ODAC, MyDAC. Контроль версий с помощью Git.'
);
------------------------------------------------------------------------------------------------------------------------
TRUNCATE new_big.message CASCADE;

ALTER SEQUENCE IF EXISTS new_big.message_message_id_seq RESTART;

INSERT INTO new_big.message
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'INVITE',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,100) ;

INSERT INTO new_big.message
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'REPLY',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,100) ;

INSERT INTO new_big.message
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'MESSAGE_TO_RESUME',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,10000) ;

INSERT INTO new_big.message
	(vacancy_id, resume_id, article, description, message_type, unread ,time_create)
	SELECT
		ROUND(1 + RANDOM()*4),
		ROUND(1 + RANDOM()*4),
		'art'||random(),'art'||random(),
		'MESSAGE_TO_VACANCY',
		CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END,
		date(now() - trunc(random()  * 365) * '1 day'::interval)
	FROM
		generate_series(1,10000) ;
