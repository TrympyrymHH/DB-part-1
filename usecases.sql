-- работодатель ищет людей, подходящих на конкретную вакансию
EXPLAIN ANALYZE SELECT distinct a.applicant_id, a.name
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v USING (occupation_id, city_id)
WHERE vacancy_id = 3;

-- работодатель ищет людей, подходящих на конкретную вакансию, но еще не подавших и не приглашенных на нее
EXPLAIN ANALYZE SELECT distinct a.applicant_id, a.name
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v USING (occupation_id, city_id)
WHERE vacancy_id = 3 AND NOT EXISTS (
		SELECT 1
		FROM request req
		WHERE req.vacancy_id = 3 AND a.applicant_id = req.applicant_id
	);

-- работодатель ищет людей, подходящих на любую свою вакансию
EXPLAIN ANALYZE SELECT distinct a.applicant_id, a.name
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v ON (v.employer_id = 1 AND v.occupation_id = r.occupation_id AND v.city_id = r.city_id);

-- работодатель приглашает всех подходящих людей, подавших на его вакансии, на собеседование
EXPLAIN ANALYZE INSERT INTO message (request_id, text, from_employer, time, seen)
SELECT DISTINCT req.request_id, 'You`re welcome!', TRUE, NOW(), FALSE
FROM applicant a
JOIN request req USING (applicant_id)
JOIN vacancy v USING (vacancy_id)
JOIN resume r USING (applicant_id, occupation_id, city_id)
WHERE employer_id = 1 AND NOT req.is_invite;

-- соискатель выбирает все подходящие по опыту вакансии в конкретной области
EXPLAIN ANALYZE SELECT v.text, v.experience, c.name, e.name
FROM vacancy v
JOIN employer e USING (employer_id)
JOIN city c USING (city_id)
WHERE v.occupation_id = 1 AND v.experience <= 90;

-- соискатель подает на вакансию
EXPLAIN ANALYZE INSERT INTO request (is_invite, vacancy_id, applicant_id, seen) VALUES (FALSE, 3, 1, FALSE);

-- соискатель логинится
EXPLAIN ANALYZE INSERT INTO request (is_invite, vacancy_id, applicant_id, seen) VALUES (FALSE, 3, 1, FALSE);UPDATE applicant a
SET (login_timestamp, logout_timestamp) = (NOW(), NULL)
WHERE a.applicant_id = (SELECT a.applicant_id FROM applicant a WHERE a.login = '1' AND a.password = '1');

-- соискатель видит количество непрочитанных приглашений
EXPLAIN ANALYZE INSERT INTO request (is_invite, vacancy_id, applicant_id, seen) VALUES (FALSE, 3, 1, FALSE);SELECT COUNT(req.request_id)
FROM request req
JOIN applicant a USING (applicant_id)
WHERE a.applicant_id = 1 AND req.is_invite AND req.seen = FALSE;

-- соискатель видит список приглашений с отметкой просмотра
EXPLAIN ANALYZE INSERT INTO request (is_invite, vacancy_id, applicant_id, seen) VALUES (FALSE, 3, 1, FALSE);SELECT v.text, req.seen
FROM request req
JOIN vacancy v USING (vacancy_id)
JOIN applicant a USING (applicant_id)
WHERE a.applicant_id = 1 AND req.is_invite;

-- соискатель видит переписку по приглашению в обратном порядке
EXPLAIN ANALYZE INSERT INTO request (is_invite, vacancy_id, applicant_id, seen) VALUES (FALSE, 3, 1, FALSE);SELECT m.time, ' : ', m.text, m.seen
FROM message m
WHERE m.request_id = 1
ORDER BY m.time DESC;

-- работодатель видит количество непрочитанных заявок по каждой вакансии
EXPLAIN ANALYZE INSERT INTO request (is_invite, vacancy_id, applicant_id, seen) VALUES (FALSE, 3, 1, FALSE);SELECT v.vacancy_id, COUNT(req.request_id)
FROM employer e
JOIN vacancy v USING (employer_id)
JOIN request req USING (vacancy_id)
WHERE e.employer_id = 1 AND NOT req.is_invite AND req.seen = FALSE
GROUP BY vacancy_id;

-- работодатель видит список соискателей из заявок на конкретную вакансию
EXPLAIN ANALYZE INSERT INTO request (is_invite, vacancy_id, applicant_id, seen) VALUES (FALSE, 3, 1, FALSE);SELECT a.applicant_id, req.seen
FROM request req
JOIN vacancy v USING (vacancy_id)
JOIN applicant a USING (applicant_id)
WHERE v.vacancy_id = 1 AND NOT req.is_invite;
