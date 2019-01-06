TRUNCATE employer CASCADE;
ALTER SEQUENCE employer_employer_id_seq RESTART WITH 1;

TRUNCATE applicant CASCADE;
ALTER SEQUENCE applicant_applicant_id_seq RESTART WITH 1;

TRUNCATE employer CASCADE;
ALTER SEQUENCE resume_resume_id_seq RESTART WITH 1;

TRUNCATE employer CASCADE;
ALTER SEQUENCE vacancy_vacancy_id_seq RESTART WITH 1;

TRUNCATE application CASCADE;
ALTER SEQUENCE application_application_id_seq RESTART WITH 1;

INSERT INTO employer(
  title,
  email,
  password
) VALUES
  ('Ромашка', 'romashka@email', crypt('12345', gen_salt('bf'))),
  ('Лютик', 'lyutik@email', crypt('abcde', gen_salt('bf'))),
  ('Березка', 'berezka@email', crypt('p455w0rd', gen_salt('bf'))),
  ('Рога и копыта', 'roga-i-kopyta@email', crypt('    ', gen_salt('bf'))),
  ('ООО ЕПРСТ-Инвест', 'eprst-invest@email', crypt('qwerty', gen_salt('bf')));

INSERT INTO applicant(
  name,
  email,
  password
) VALUES
  ('Василий Иванович Пупкин', 'pupkine@email', crypt('12345', gen_salt('bf'))),
  ('Мария Петровна Сидорова', 'sidorowa@email', crypt('abcde', gen_salt('bf'))),
  ('Михайло Потапович Топтыгин', 'toptygin@email', crypt('p455w0rd', gen_salt('bf'))),
  ('Лиса Патрикеевна Рыжая', 'patrikeevna@email', crypt('    ', gen_salt('bf'))),
  ('Максим Максимович Исаев', 'isaev@email', crypt('qwerty', gen_salt('bf')));

INSERT INTO vacancy(
  employer_id,
  title,
  city,
  salary,
  expyears_key,
  schedule,
  description
) VALUES
    (1, 'Менеджер по продажам', 'Москва', INT4RANGE(25000, 35000), '1-3', 'FULL_TIME',
    'Лучший в мире менеджер по продажам для лучшей в мире компании!'),
    (1, 'Генеральный директор', 'Москва', INT4RANGE(150000, 200000), '3-6', 'FULL_TIME',
    'Лучший в мире генеральный директор для лучшей в мире компании!'),
    (1, 'Курьер', 'Тула', NULL, 'ANY', 'FLEXIBLE',
    'Лучший в мире курьер для лучшей в мире компании!
График свободный, оплата сдельная'),
    (2, 'Java-программист', 'Москва', INT4RANGE(75000, 120000), '1-3', 'FULL_TIME',
    'Проектирование и разработка высоконагруженных и отказоустойчивых систем.
Знание Java, SQL (умение писать сложные запросы), Python обязательны.
Желательно знать что-то из набора: Perl, PHP, C++.
Наличие open-source разработок в портфолио будет плюсом.'),
    (2, 'Программист C++', 'Челябинск', INT4RANGE(NULL, 130000), '1-3', 'FULL_TIME',
    'Хорошее знание STL, SQL (опыт работы с PostgreSQL желателен)')
    ;

INSERT INTO resume(
  applicant_id,
  title,
  city,
  salary,
  experience_years,
  schedule,
  text
) VALUES
    (1, 'Менеджер по продажам', 'Москва', INT4RANGE(25000, 35000), 1, 'FULL_TIME',
    'Опыт работы:
1. Сентябрь 2016-Ноябрь 2017. ООО Березка, Курьер
2. Ноябрь 2017-Настоящее время. ООО Березка, Менеджер по продажам'),
    (1, 'Курьер', 'Москва', INT4RANGE(15000, NULL), 1, 'PART_TIME',
    'Опыт работы:
1. Сентябрь 2016-Ноябрь 2017. ООО Березка, Курьер
2. Ноябрь 2017-Настоящее время. ООО Березка, Менеджер по продажам'),
    (2, 'Java-программист', 'Красногорск', INT4RANGE(50000, NULL), 1, 'FULL_TIME',
    'Опыт работы:
1. Апрель 2017-Декабрь 2018. Программист Java, ЗАО АБВГДБанк'),
    (3, 'Генеральный директор', 'Москва', INT4RANGE(250000, 300000), 5, 'FULL_TIME',
    'Опыт работы:
1. Март 2013-Август 2015. Зам. руководителя департамента меда, ЗАО Темный лес
2. Август 2015-Настоящее время. Руководитель департамента меда, ЗАО Темный лес'),
    (4, 'Java-программист', 'Москва', INT4RANGE(75000, 120000), 3, 'FULL_TIME',
    'Опыт работы:
1. Май 2015-Настоящее время. Программист JavaScript, ЗАО Темный лес
    Ключевые навыки: Java, Python, PostgreSQL')
    ;

INSERT INTO application(
  resume_id,
  vacancy_id
) VALUES
    (1, 1),
    (4, 2),
    (5, 4),
    (2, 3)
;

INSERT INTO message(
  application_id,
  text,
  applicant_to_employer,
  created
) VALUES
    (1,
    'Привет!
Возьмите меня к себе менеджером по продажам.
Вася',
    TRUE,
    '2019-01-01 10:00:00'
    ),
    (2,
    'Добрый вечер, коллеги.
Прошу рассмотреть мою кандидатуру на должность гендира Вашей компании
С уважением, Топтыгин М. П.',
    TRUE,
    '2019-01-01 11:00:00'),
    (3,
    '',
    TRUE,
    '2019-01-01 12:00:00'),
    (4,
    'Привет!
Возьмите меня к себе курьером.
Вася',
    TRUE,
    '2019-01-01 13:00:00'
    ),
    (1,
    'Привет, Вася!
Приходи в четверг на собеседование.
Ромашкин Р. Р.',
    FALSE,
    '2019-01-02 10:00:00'),
    (2,
    'Добрый день, Михайло Потапович!
К сожалению, мы вынуждены Вам отказать.
Вряд ли мы сможем удовлетворить Ваши финансовые запросы :(.
Ромашкин Р. Р.',
    FALSE,
    '2019-01-02 11:00:00'),
    (4,
    'Привет, Вася!
Нам курьер в Туле нужен, а не в Москве.
Ромашкин Р. Р.',
    FALSE,
    '2019-01-02 12:00:00'
    )
;
