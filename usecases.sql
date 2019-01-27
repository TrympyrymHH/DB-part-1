-- работодатель ищет людей, подходящих на конкретную вакансию
SELECT distinct a.applicant_id, a.name
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v ON (v.vacancy_id = 3 AND v.occupation_id = r.occupation_id AND v.city_id = r.city_id);

-- работодатель ищет людей, подходящих на конкретную вакансию, но еще не подавщих на нее
SELECT distinct a.applicant_id, a.name
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v ON (v.vacancy_id = 3 AND v.occupation_id = r.occupation_id AND v.city_id = r.city_id)
WHERE (a.applicant_id NOT IN (
		SELECT (a.applicant_id)
		FROM applicant a
		JOIN application app ON (app.vacancy_id = 3 AND a.applicant_id = app.applicant_id)
	)	
);

-- работодатель ищет людей, подходящих на любую свою вакансию
SELECT distinct a.applicant_id, a.name
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v ON (v.employer_id = 1 AND v.occupation_id = r.occupation_id AND v.city_id = r.city_id);

-- работодатель приглашает всех подходящих людей, подавших на его вакансии, на собеседование
INSERT INTO invite (vacancy_id, applicant_id, seen)
SELECT distinct v.vacancy_id, a.applicant_id, FALSE
FROM applicant a
JOIN application app USING (applicant_id)
JOIN vacancy v ON (v.employer_id = 1 AND v.vacancy_id = app.vacancy_id)
JOIN resume r ON (a.applicant_id = r.applicant_id AND r.occupation_id = v.occupation_id AND v.city_id = r.city_id);

-- соискатель выбирает все подходящие по опыту вакансии в конкретной области
SELECT v.text, v.experience, c.name, e.name
FROM vacancy v
JOIN employer e USING (employer_id)
JOIN city c USING (city_id)
WHERE v.occupation_id = 1 AND v.experience <= 90;

-- соискатель подает на вакансию
INSERT INTO application (vacancy_id, applicant_id) VALUES (3, 1);

-- соискатель логинится
UPDATE applicant a
SET (login_timestamp, logout_timestamp) = (NOW(), '1970-01-01 00:00:00')
WHERE a.applicant_id = (SELECT a.applicant_id FROM applicant a WHERE a.login = '1' AND a.password = '1');

-- соискатель видит количество непрочитанных приглашений
SELECT COUNT(i.invite_id)
FROM invite i
JOIN applicant a USING (applicant_id)
WHERE a.applicant_id = 1 AND i.seen = FALSE;

-- соискатель видит переписку по приглашению в обратном порядке
SELECT m.time, ' : ', m.text, m.seen
FROM message m
WHERE m.invite_id = 1
ORDER BY m.time DESC;

