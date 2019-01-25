INSERT INTO hh_import.account (email, password)
SELECT 'email' || i || '@ya.ru', md5('password')
FROM generate_series(1, {0}) AS g(i) RETURNING account_id