INSERT INTO hh_import.message (resume_id, vacancy_id, send_time, type, body, view)
SELECT round((({1} - 0.1) * random()) + 0.5),
       round((({2} - 0.1) * random()) + 0.5),
       current_date - (interval '15 years' * RANDOM()),
       CASE WHEN (random() < 0.5) THEN hh.MESSAGE_TYPE('TEXT_APP') ELSE hh.MESSAGE_TYPE('TEXT_EMP') END,
       'Привет' || i,
       FALSE
FROM generate_series(1, {0}) AS g(i) RETURNING message_id;
UPDATE hh_import.message
SET account_id = resume.account_id
FROM hh_import.resume
WHERE type = 'TEXT_APP'
  AND (message.resume_id = resume.resume_id) RETURNING message_id;
UPDATE hh_import.message
SET account_id = employer_account.account_id
FROM hh_import.vacancy
INNER JOIN hh_import.employer_account USING (employer_id)
WHERE type = 'TEXT_EMP'
  AND (message.vacancy_id = vacancy.vacancy_id) RETURNING message_id;