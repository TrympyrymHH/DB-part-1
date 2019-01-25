INSERT INTO hh_import.vacancy (employer_id, city, position, shedule, education_level, experience_years, salary_from,
                               about, status)
SELECT round((({1}-0.1) * random()) + 0.5),
       'city' || i,
       'position' || i,
       CASE round(10 * random())
         WHEN (1) THEN hh.SCHEDULE_TYPE('SHIFT_METHOD')
         WHEN (2) THEN hh.SCHEDULE_TYPE('DISTANT')
         WHEN (3) THEN hh.SCHEDULE_TYPE('FLEXIBLE')
         WHEN (4) THEN hh.SCHEDULE_TYPE('REPLACEABLE')
         ELSE hh.SCHEDULE_TYPE('FULL_DAY') END,
       CASE round(8 * random())
         WHEN (0) THEN hh.EDUCATION_TYPE('PRESCHOOL')
         WHEN (1) THEN hh.EDUCATION_TYPE('ELEMENTARY_SCHOOL')
         WHEN (2) THEN hh.EDUCATION_TYPE('BASIC_SCHOOL')
         WHEN (3) THEN hh.EDUCATION_TYPE('AVERAGE_SCHOOL')
         WHEN (4) THEN hh.EDUCATION_TYPE('AVERAGE_PROFESSIONAL')
         WHEN (5) THEN hh.EDUCATION_TYPE('BACHELOR')
         WHEN (6) THEN hh.EDUCATION_TYPE('MASTER')
         WHEN (7) THEN hh.EDUCATION_TYPE('SPECIALIST')
         ELSE hh.EDUCATION_TYPE('TOP_SKILLS') END,
       CASE round(4 * random())
         WHEN (0) THEN hh.EXPERIENCE_YEARS('0-1')
         WHEN (1) THEN hh.EXPERIENCE_YEARS('1-3')
         WHEN (2) THEN hh.EXPERIENCE_YEARS('3-6')
         ELSE hh.EXPERIENCE_YEARS('6+') END,
       1000 * round(500 * random()),
       'about' || i,
       CASE WHEN (random() < 0.8) THEN hh.VACANCY_STATUS('OPEN') ELSE hh.VACANCY_STATUS('CLOSE') END
FROM generate_series(1, {0}) AS g(i) RETURNING vacancy_id
