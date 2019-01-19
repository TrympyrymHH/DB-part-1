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
	(resume_id, date_start, date_finish,
	position, description)
VALUES
	(2, '2011-03-04', '2011-06-06',
	'технический специалист', 'работал замечательно'),
	(2, '2012-01-01', '2012-01-07',
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
  description
FROM headhunter.resume_experience
WHERE resume_id = 2
ORDER BY date_start DESC;

-- 2.4 с апдейтами всё просто ------------------------------------------------------------------------------------------
-- дату изменения резюме меняют триггеры
UPDATE
  headhunter.resume
SET
  fio = 'Васильев Геннадий',
  position = 'Программист',
  birthday = '2018-01-01',
  salary_min = 150000,
  salary_max = 170000,
  skill_ids = '{3,2,1}'
WHERE
  resume_id = 2

UPDATE headhunter.resume_experience
   SET date_start='2011-05-05', date_finish='2013-05-06',
       "position"='Другая позиция', description='Другое описание'
 WHERE resume_id=2;



