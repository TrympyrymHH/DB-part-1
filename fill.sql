TRUNCATE headhunter.users CASCADE;
ALTER SEQUENCE headhunter.users_id_seq RESTART;

INSERT INTO headhunter.users(login, password)
VALUES 
    ('vasya', 	md5('querty')),
    ('petya', 	md5('123456')),
    ('kostya', 	md5('qazwsx')),
    ('vanya', 	md5('querty')),
    ('natasha', md5('000000')),
    ('sveta', 	md5('******')),
    ('vova', 	md5('querty')),
    ('superman',md5('querty')),
    ('batman', 	md5('querty'));

------------------------------------------------------------------------------------------------------------------------

TRUNCATE headhunter.company CASCADE;
ALTER SEQUENCE headhunter.company_id_seq RESTART;

INSERT INTO headhunter.company(user_id, name, description, path_to_logo)
VALUES 
    (1, 'Майкрософт', 'молодая подающая надежды компания', 'c:/logos/ms.logo'),
    (2, 'Гугл', 'мы умеем говорить ОК', 'c:/logos/gl.logo'),
    (3, 'Яху', 'Описание компании', 'c:/logos/ms.logo'),
    (4, 'ИП Виноградова', 'В 2018 году мы подняли продажи на 100%, реализовав целых 2 принтера!', 'c:/logos/ms.logo'),
    (4, 'ООО "Рога & Копыта"', 'Магазин охотничьих трофеев', 'c:/logos/ms.logo');

------------------------------------------------------------------------------------------------------------------------

TRUNCATE headhunter.vacancy CASCADE;
ALTER SEQUENCE headhunter.vacancy_id_seq RESTART;

INSERT INTO headhunter.vacancy
(	company_id, 
	"position", 
	description, 
	salary_min, salary_max, 
	wanted_experience, 
	wanted_skills, 
	date_to_unpublish, 
        salary_currency)
VALUES 
(	1,
	'Уборщица',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{"2 высших профильных образования","английский intermediate","опыт работы в высоконагруженных системах"}',
	'2019-01-01',
	'RUR'),
	
(	1,
	'Сторож',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{"2 высших профильных образования","английский intermediate"}',
	'2019-01-01',
	'RUR'),
	
(	2,
	'Программист BrainF*ck',
	'Описание',
	25000, 30000,
	'опыт работы в высоконагруженных системах',
	'{"3 высших профильных образования","английский godlike","опыт работы в аду"}',
	'2019-01-01',
	'RUR'),
	
(	2,
	'PHP Developer',
	'нужен фронтенд разработчик',
	10000, 20000,
	'компьютерщик на все руки',
	'{"установка windows всех версий","заправка картриджей","настройка программ", "Программирование, Разработка"}',
	'2019-01-01',
	'RUR'),
	
(	4,
	'Уборщица',
	'Мы ищем эффективного активного сотрудника',
	180000, 250000,
	'опыт работы в высоконагруженных системах',
	'{"2 высших профильных образования","английский intermediate","опыт работы в высоконагруженных системах"}',
	'2019-01-01',
	'RUR');

------------------------------------------------------------------------------------------------------------------------
TRUNCATE headhunter.resume CASCADE;
ALTER SEQUENCE headhunter.resume_id_seq RESTART;

INSERT INTO headhunter.resume
(	user_id, 
	"position", 
	fio, 
	age, 
        salary_min, 
        salary_max, 
        salary_currency, 
        skills)
VALUES 
(	5,
	'Программист C++ (стажёр)',
	'Иванов Василий',
	25,
	50000,
	70000,
	'RUR',
	'{"Информационные технологии","Интернет","Мультимедиа"}'),
	
(	6,
	'рограммист C/С++ (Builder, Qt)',
	'Иванов Пётр',
	55,
	10000,
	170000,
	'RUR',
	'{"Информационные технологии","Интернет","телеком","Программирование, Разработка", "Компьютерная безопасность"}'),
	
(	7,
	'Ведущий программист С++)',
	'Иванов Геннадий',
	34,
	70000,
	70000,
	'RUR',
	'{"Информационные технологии","Сетевые технологии","Телекоммуникации"}'),
	
(	8,
	'Программист С++',
	'Иванов Николай',
	72,
	18000,
	20000,
	'RUR',
	'{"Информационные технологии","Поддержка, Helpdesk", " Работа в SONY VEGAS 7"}'),
	
(	8,
	'Программист (Junior C++)',
	'Иванов Иван',
	23,
	50000,
	50010,
	'RUR',
	'{"Информационные технологии","Производство, Технологии"}');

------------------------------------------------------------------------------------------------------------------------
TRUNCATE headhunter.resume_experience CASCADE;
ALTER SEQUENCE headhunter.resume_experience_id_seq RESTART;

INSERT INTO headhunter.resume_experience(
            resume_id, 	date_start, 	date_finish, 	"position", 	description)
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
ALTER SEQUENCE headhunter.messages_id_seq RESTART;

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread )
	SELECT ROUND(1 + RANDOM()*4),ROUND(1 + RANDOM()*4), 'art'||random(),'art'||random(), 'invite', CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END FROM generate_series(1,100);

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread )
	SELECT ROUND(1 + RANDOM()*4),ROUND(1 + RANDOM()*4), 'art'||random(),'art'||random(), 'reply', CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END FROM generate_series(1,100);

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread )
	SELECT ROUND(1 + RANDOM()*4),ROUND(1 + RANDOM()*4), 'art'||random(),'art'||random(), 'message_to_resume', CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END FROM generate_series(1,10000);

INSERT INTO headhunter.messages
	(vacancy_id, resume_id, article, description, message_type, unread )
	SELECT ROUND(1 + RANDOM()*4),ROUND(1 + RANDOM()*4), 'art'||random(),'art'||random(), 'message_to_vacancy', CASE WHEN (random()>0.9) THEN TRUE ELSE FALSE END FROM generate_series(1,10000);

------------------------------------------------------------------------------------------------------------------------

