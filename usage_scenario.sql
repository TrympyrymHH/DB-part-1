-- 1 ОБЩИЕ ДЕЙСТВИЯ ПОЛЬЗОВАТЕЛЕЙ

-- 1.1 регистрация -----------------------------------------------------------------------------------------------------
-- входные данные:
--- password
--- login

INSERT INTO headhunter.account
	(login, password, time_register)
VALUES
	('login', md5('password'), now());

-- 1.2 авторизация -----------------------------------------------------------------------------------------------------
-- входные данные:
--- password
--- login

WITH logged_account as
	(SELECT account_id
	FROM headhunter.account
	WHERE 	login = 'login' AND password = md5('password'))

UPDATE headhunter.account
SET  time_last_login = now()
WHERE account_id in (SELECT account_id FROM logged_account)
RETURNING account_id;

-- 1.3 смена пароля
-- входные данные:
--- old_password
--- new_password
--- login

WITH logged_account as
	(SELECT account_id
	FROM headhunter.account
	WHERE login = 'login' AND password = md5('old_password'))

UPDATE headhunter.account
SET password = md5('new_password')
WHERE account_id in (SELECT account_id FROM logged_account)
RETURNING account_id; -- не могу точно сказать, нужно ли тут оно. Будет зависеть от кода.

-- понятно, что если такие меры избыточны можно всегда сделать просто
UPDATE headhunter.account
SET password = md5('new_password')WHERE account_id = 8;

------------------------------------------------------------------------------------------------------------------------
-- 2. ДЕЙСТВИЯ СОИСКАТЕЛЯ

-- 2.1 создание резюме
-- входные данные
--- account_id
--- position
--- fio
--- birthday
--- salary_min
--- salary_max
--- skill_ids
--- несколько resume_experience в составе
---- date_start
---- date_finish
---- position
---- description

INSERT INTO headhunter.resume
  (account_id,  time_created,  position,
  fio,   birthday,  salary_min,
  salary_max,   skill_ids)
VALUES
	(8,	now(),	'прогроммист',
	'Жан Код Ван Дамм',	'1983-07-27',	30000,
	50000,	'{5,1}')
RETURNING resume_id;

-- где skill_ids массив id`шников скилов, содержащихса в соответствующей таблице
-- выборка доступных скилов для автодополнения может выбираться примерно таким запросом:
-- входные данные
--- кусок_строки

select skill_id, name
from headhunter.skill
where name ~* 'кусок_строки'
order by
	name ~ '^кусок_строки$' DESC,
	name ~* '^кусок_строки$' DESC,
	name ~* '^кусок_строки' DESC;

-- далее, поскольку мы получили кодом resume_id, можем запихнуть resume_experience
INSERT INTO headhunter.resume_experience
	(resume_id, date_start, date_finish, company_name,
	position, description)
VALUES
	(2, '2011-03-04', '2011-06-06', 'компания N',
	'технический специалист', 'работал замечательно'),
	(2, '2012-01-01', '2012-01-07','компания 2N',
	'системный администратор', 'пахал как краб на галерах');

-- 2.2 соискатель приходит на следующий день и смотрит список своих резюме и рядом циферки, ----------------------------
--      говорящие ему, есть ли по каждому резюме отклики или сообщения вообще
-- входные данные
-- account_id

with my_resumes as
(select resume_id, fio, position, salary_min, salary_max
from headhunter.resume
where account_id = 8),

new_messages as
(SELECT count(message_id), message_type, resume_id
FROM headhunter.message
WHERE resume_id IN(SELECT resume_id FROM my_resumes)
	AND unread = true
	AND message_type IN ('INVITE','MESSAGE_TO_RESUME')
GROUP BY message_type, resume_id)

SELECT my_resumes.resume_id, fio, position, salary_min, salary_max, new_invites.count as new_invites , new_messages.count as new_messages
FROM my_resumes
LEFT JOIN new_messages as new_invites on (new_invites.resume_id = my_resumes.resume_id AND new_invites.message_type = 'INVITE')
LEFT JOIN new_messages on (new_messages.resume_id = my_resumes.resume_id AND new_messages.message_type = 'MESSAGE_TO_RESUME');

-- 2.3 соискатель кликает по одному из резюме и видит всю инфу ---------------------------------------------------------
-- хотелось бы сделать всё одним запросом, но надо ли?
-- не так уж сложно дёрнуть три таблицы по индексам тремя запросами

-- полная инфа по резюме
SELECT
  time_created,
  time_updated,
  resume_id,
  fio,
  position,
  birthday,
  salary_min,
  salary_max,
  skill_ids
FROM headhunter.resume
WHERE resume_id = 2;

-- инфа по скилам
SELECT skill_id,name
FROM headhunter.skill
WHERE skill_id IN (11,21,22,8);

-- инфа по опыту работы
SELECT
  resume_experience_id,
  date_start,
  date_finish,
  position,
  company_name,
  description
FROM headhunter.resume_experience
WHERE resume_id = 2
ORDER BY date_start DESC;

-- 2.4 соискатель кликает по циферке с сообщениями или по спец. кнопке и видит, собственно, сообщения для резюме -------

SELECT
  count(*) OVER() AS full_count,
	message.message_id,
	vacancy.vacancy_id,
	company.company_id,

	message.article,
	message.description,
	message.time_create,
	message.unread,
	message.message_type,
	vacancy.position,
	company.name

FROM headhunter.message
LEFT JOIN headhunter.vacancy USING (vacancy_id)
LEFT JOIN headhunter.company USING (company_id)

WHERE message.resume_id = 2
ORDER BY message.time_create DESC

LIMIT 5
OFFSET 0

-- по какому-нибудь алгоритму, летящему из фронтенда мы устанавливаем
UPDATE headhunter.message SET unread = FALSE  WHERE message_id = 3011

-- 2.5 с апдейтами всё просто ------------------------------------------------------------------------------------------

UPDATE
  headhunter.resume
SET
  fio = 'Васильев Геннадий',
  position = 'Программист',
  birthday = '2018-01-01',
  salary_min = 150000,
  salary_max = 170000,
  skill_ids = '{3,2,1}',
  time_updated = now()
WHERE
  resume_id = 2;

-------------
UPDATE headhunter.resume_experience
   SET date_start='2011-05-05', date_finish='2013-05-06',
       position='Другая позиция', description='Другое описание'
WHERE resume_id=2;

UPDATE
  headhunter.resume
SET
  time_updated = now()
WHERE
  resume_id = 2;

------------------------------------------------------------------------------------------------------------------------
-- 3. ДЕЙСТВИЯ РАБОТОДАТЕЛЯ

-- 3.1 Создание новой компании

WITH new_company as
  (INSERT INTO headhunter.company(name, description, path_to_logo)
	VALUES ('User8Company & CO', 'описание компании', 'c:/logos/u8.logo')
	RETURNING company_id)

INSERT INTO headhunter.account_to_company_relation (account_id, company_id, rights, time_updated, who_update)
VALUES (8,	(select company_id from new_company),	'{0}',	now(),	8)
RETURNING company_id;

-- 3.2 Создание новой вакансии -----------------------------------------------------------------------------------------

INSERT INTO headhunter.vacancy
  (company_id,
  position,
  description,
  salary_min,
  salary_max,
  wanted_experience,
  wanted_skill_ids,
  time_created,
  time_to_unpublish)

VALUES
  (3,
  'прогроммист',
  'описание вакансии',
  30000,
  40000,
  'описание того, кто нас нужен',
  '{3,8,22}',
  now(),
  now()+ interval '1 month')

RETURNING vacancy_id;

-- 3.3 HR сотрудник заходит логинится и видит список своих кампаний ----------------------------------------------------
WITH my_conpanys AS
	(SELECT DISTINCT company_id, rights
	 FROM headhunter.account_to_company_relation
	 WHERE account_id = 8)

SELECT
	company.company_id,
	company.name,
	company.description,
	company.path_to_logo,
	my_conpanys.rights

FROM my_conpanys
LEFT JOIN headhunter.company USING (company_id)

-- 3.4 HR сотрудник заходит в кампанию и видит количество новых сообщений по каждой вакансии ---------------------------

WITH my_vacancys AS
(SELECT vacancy_id, position, salary_min, salary_max
 FROM headhunter.vacancy
 WHERE company_id  = 4),

new_messages as
(SELECT count(message_id), message_type, vacancy_id
FROM headhunter.message
WHERE vacancy_id IN(SELECT vacancy_id FROM my_vacancys)
	AND unread = true
	AND message_type IN ('REPLY','MESSAGE_TO_VACANCY')
GROUP BY message_type, vacancy_id)

SELECT
	my_vacancys.vacancy_id,
	position,
	salary_min,
	salary_max,
	new_replys.count as new_replys,
	new_messages.count as new_messages

FROM my_vacancys
LEFT JOIN new_messages as new_replys on (new_replys.vacancy_id = my_vacancys.vacancy_id AND new_replys.message_type = 'REPLY')
LEFT JOIN new_messages on (new_messages.vacancy_id = my_vacancys.vacancy_id AND new_messages.message_type = 'MESSAGE_TO_VACANCY');

-- 3.5 кликает по сообщениям -------------------------------------------------------------------------------------------
SELECT
	count(*) OVER() AS full_count,
	message.message_id,
	resume.resume_id,

	message.article,
	message.description,
	message.time_create,
	message.unread,
	message.message_type,
	resume.position,
	resume.fio

FROM headhunter.message
LEFT JOIN headhunter.resume USING (resume_id)

WHERE message.resume_id = 2
ORDER BY message.time_create DESC

LIMIT 5
OFFSET 0

-- 3.6 HR сотрудник просит систему найти резюме, которые подходят к выбранной вакансии по скилам и зп ------------
-- считаю непоное соответствие скилов тоже совпадением

SELECT resume.resume_id,  resume.fio
FROM headhunter.vacancy
LEFT JOIN headhunter.resume ON(
	vacancy.salary_max >= resume.salary_min
		AND
	vacancy.wanted_skill_ids && resume.skill_ids)

WHERE vacancy.vacancy_id = 1;

-- выбор данных по кликнутому резюме буду считать аналогичным тому,
-- что производится при клмке соискателя по своему резюме


-- 3.7 попробуем найти ключевое слово в опыте соискателей --------------------------------------------------------------
SELECT
	resume.resume_id,
	resume.fio,
	resume_experience.position,
	resume_experience.description
FROM headhunter.resume_experience
LEFT JOIN headhunter.resume USING (resume_id)
WHERE description ~* 'обмен'

-- 3.8 работодатель пишет соискателю приглашение

INSERT INTO headhunter.message
  (vacancy_id,
  resume_id,
  article,
  description,
  time_create,
  message_type,
  unread)

VALUES
  (1,
  3,
  'заголовок',
  'текст сообщения',
  now(),
  'INVITE',
  TRUE);

-- 2.6 на что соискатель опвечает --------------------------------------------------------------------------------------

INSERT INTO headhunter.message
  (vacancy_id,
  resume_id,
  article,
  description,
  time_create,
  message_type,
  unread)

VALUES
  (1,
  3,
  'чего?',
  'ни чего не понял из Вашего сообщения',
  now(),
  'MESSAGE_TO_VACANCY',
  TRUE);

-- 2.7 и сам ищет нормальные вакансии по соответствию скилов и зп-------------------------------------------------------

SELECT
	company.company_id,
	company.name,
	company.path_to_logo,

	vacancy.vacancy_id,
	vacancy.position,
	vacancy.salary_min,
	vacancy.salary_max

FROM headhunter.vacancy
LEFT JOIN headhunter.resume ON
	(vacancy.salary_max >= resume.salary_min
		AND
	vacancy.wanted_skill_ids && resume.skill_ids)

LEFT JOIN headhunter.company USING (company_id)

WHERE resume.resume_id = 2;

