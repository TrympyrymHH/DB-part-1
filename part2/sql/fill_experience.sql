INSERT INTO hh_import.experience (resume_id, date_begin, organization_name, position, about)
SELECT i,
       current_date - (interval '15 years' * RANDOM()),
       'organization' || trunc(1+random()*{0}),
       'position' || trunc(1+random()*{0}),
       'about' || trunc(1+random()*{0})
FROM generate_series({1}, {2}) AS g(i);

INSERT INTO hh_import.experience (resume_id, date_begin, organization_name, position, about)
SELECT round((({3}-0.1)*random())+0.5),
       current_date - (interval '15 years' * RANDOM()),
       'organization' || trunc(1+random()*{0}),
       'position' || trunc(1+random()*{0}),
       'about' || trunc(1+random()*{0})
FROM generate_series({2}+1, {0}) AS g(i);

UPDATE hh_import.experience SET  date_end = date_begin+((current_date+interval '0 year'-date_begin)*random()) RETURNING experience_id;