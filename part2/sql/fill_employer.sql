INSERT INTO hh_import.employer (organization_name)
SELECT 'organization' || i
FROM generate_series(1, {0}) AS g(i) RETURNING employer_id