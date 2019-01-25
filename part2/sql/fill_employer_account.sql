INSERT INTO hh_import.employer_account (employer_id, account_id)
SELECT {3} + i,
       {2} + i
FROM generate_series(1, {1}) AS g(i);

INSERT INTO hh_import.employer_account (employer_id, account_id)
SELECT round((({1} - 0.1)*random())+0.5),
       {2}+i
FROM generate_series( {1} +1, {0}) AS g(i);