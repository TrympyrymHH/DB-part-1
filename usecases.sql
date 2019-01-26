-- работодатель ищет людей, подходящих на конкретную вакансию
SELECT distinct a.applicant_id, a.name 
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v ON (v.occupation_id = r.occupation_id AND r.experience >= v.experience AND v.vacancy_id = 3);

-- работодатель ищет людей, подходящих на конкретную вакансию, но еще не подавщих на нее
SELECT distinct a.applicant_id, a.name 
FROM applicant a
JOIN resume r USING (applicant_id)
JOIN vacancy v ON (v.vacancy_id = 3 AND v.occupation_id = r.occupation_id AND r.experience >= v.experience)
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
JOIN vacancy v ON (v.employer_id = 1 AND v.occupation_id = r.occupation_id AND r.experience >= v.experience);

-- работодатель приглашает всех подходящих людей, подавших на его вакансии, на собеседование
INSERT INTO invite (vacancy_id, applicant_id)
SELECT distinct v.vacancy_id, a.applicant_id
FROM applicant a
JOIN application app USING (applicant_id)
JOIN vacancy v ON (v.employer_id = 1 AND v.vacancy_id = app.vacancy_id)
JOIN resume r ON (a.applicant_id = r.applicant_id AND r.occupation_id = v.occupation_id AND r.experience >= v.experience);

-- соискатель выбирает все подходящие по опыту вакансии в конкретной области
SELECT v.text, v.experience, e.name
FROM vacancy v
JOIN employer e USING (employer_id)
where v.occupation_id = 1 and v.experience <= 90

-- соискатель подает на вакансию
INSERT INTO application (vacancy_id, applicant_id) VALUES (3, 1);
