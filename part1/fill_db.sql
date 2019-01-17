TRUNCATE hh.users CASCADE;
ALTER SEQUENCE IF EXISTS hh.users_user_id_seq RESTART;
TRUNCATE hh.towns CASCADE;
ALTER SEQUENCE IF EXISTS hh.towns_city_id_seq RESTART;
TRUNCATE hh.applicants CASCADE;
TRUNCATE hh.educational_institution CASCADE;
ALTER SEQUENCE IF EXISTS hh.educational_institution_institution_id_seq RESTART;
TRUNCATE hh.faculty CASCADE;
ALTER SEQUENCE IF EXISTS hh.faculty_faculty_id_seq RESTART;
TRUNCATE hh.speciality CASCADE;
ALTER SEQUENCE IF EXISTS hh.speciality_speciality_id_seq RESTART;
TRUNCATE hh.education CASCADE;
ALTER SEQUENCE IF EXISTS hh.education_education_id_seq RESTART;
TRUNCATE hh.organizations CASCADE;
ALTER SEQUENCE IF EXISTS hh.organizations_organization_id_seq RESTART;
TRUNCATE hh.positions CASCADE;
ALTER SEQUENCE IF EXISTS hh.positions_position_id_seq RESTART;
TRUNCATE hh.experience CASCADE;
ALTER SEQUENCE IF EXISTS hh.experience_experience_id_seq RESTART;
TRUNCATE hh.skills CASCADE;
ALTER SEQUENCE IF EXISTS hh.skills_skill_id_seq RESTART;
TRUNCATE hh.resume CASCADE;
ALTER SEQUENCE IF EXISTS hh.resume_resume_id_seq RESTART;
TRUNCATE hh.resume_to_education CASCADE;
TRUNCATE hh.resume_to_experience CASCADE;
TRUNCATE hh.resume_to_skills CASCADE;
TRUNCATE hh.employers CASCADE;
TRUNCATE hh.vacancy CASCADE;
ALTER SEQUENCE IF EXISTS hh.vacancy_vacancy_id_seq RESTART;
TRUNCATE hh.vacancy_to_skills CASCADE;
TRUNCATE hh.talks CASCADE;
ALTER SEQUENCE IF EXISTS hh.talks_talk_id_seq RESTART;
TRUNCATE hh.messages CASCADE;
ALTER SEQUENCE IF EXISTS hh.messages_message_id_seq RESTART;

INSERT INTO hh.users(email, password)
VALUES ('vasya@gmail.com', md5('000000')),
       ('petya@yandex.ru', md5('123456')),
       ('kolya@ya.ru', md5('qwerty')),
       ('sanya@mail.ru', md5('asdfgh')),
       ('katya@list.ru', md5('zxcvbn')),
       ('letovo@ya.ru', md5('poiuyt')),
       ('optofarm@gmail.com', md5('lkjhgf')),
       ('aleksej-izosimov@rambler.ru', md5('mnbvcx')),
       ('kadri@technopark.ru', md5('lkjhgf')),
       ('svetlana.smirnova01@megafon-retail.ru', md5('mnbvcx'));

INSERT INTO hh.towns(title)
VALUES ('������'),
       ('�����-���������'),
       ('�����������'),
       ('���������'),
       ('�������'),
       ('������������'),
       ('������'),
       ('������'),
       ('���������'),
       ('����������'),
       ('������ ��������');

INSERT INTO hh.applicants(user_id, name, sex, birthday, city_id)
VALUES (1, '������ ������� ������������', 'MEN', '1991-06-27', 1),
       (2, '������ ϸ�� ����������', 'MEN', '1987-05-14', 2),
       (3, '������ ������� ��������', 'MEN', '1961-01-01', 11),
       (4, '������� ��������� ����������', 'MEN', '1974-03-08', 9),
       (5, '������ ��������� ���������', 'WOMEN', '2001-01-17', 5);

INSERT INTO hh.educational_institution(short_name, name, city_id)
VALUES ('��� (��)', '���������� �������������� ��������', 1),
       ('���', '���������� ��������������� ����������� ��. �.�. ����������', 1),
       ('����', '��������������� ����������� �����������', 3),
       ('�������', '������������� ��������������� ����������� �����������', 4),
       ('�����', '��������� ��������������� �������������� �����������', 6);

INSERT INTO hh.faculty(institution_id, name)
VALUES (1, '����'),
       (2, '���������� ���������'),
       (3, '����� ������������ ����'),
       (4, '��������� ��������� � ����������'),
       (5, '�������� ���������, ������������� � ������������� ������������');

INSERT INTO hh.speciality(faculty_id, name)
VALUES (1, '�������������� ������, ���������, ������� � ����'),
       (2, '������� ������������ ������'),
       (3, '������� ������������'),
       (4, '������� ��������� � ������������� ������'),
       (5, '������� ������ ����������� � �������� �����');

INSERT INTO hh.education(user_id, level, speciality_id, year)
VALUES (1, 'MASTER', 5, 2015),
       (2, 'SPECIALIST', 2, 2010),
       (3, 'SPECIALIST', 3, 1984),
       (4, 'SPECIALIST', 1, 1997),
       (5, 'AVERAGE_SCHOOL', NULL, 2019);

INSERT INTO hh.organizations(name)
VALUES ('����� ������'),
       ('��� ��������'),
       ('��� ����� ������������� ����������� ���������� ��������� ��. �.�. ���������'),
       ('���������'),
       ('�� ������� ������'),
       ('������������� �����'),
       ('���� ����� � 1741'),
       ('��� "����������� �����"'),
       ('��� ����� ���������� ���������');

INSERT INTO hh.positions(title)
VALUES ('������� �������� �����'),
       ('����������� ������������ �������� �� ���������� �������������� ������������/���������'),
       ('�������-������'),
       ('������� ����������� PHP'),
       ('��������-�����������'),
       ('������� �������� ����� � ����������'),
       ('������� ������'),
       ('������� - ��������'),
       ('PHP �����������');

INSERT INTO hh.experience(user_id, date_begin, date_end, organization_id, position_id, about)
VALUES (1, '2015-09-01', NULL, 6, 6, '������� ����� ������'),
       (2, '2010-08-01', NULL, 7, 7, '�� ����� ������ �������'),
       (3, '1984-07-01', NULL, 8, 8, '������ ��������'),
       (4, '1997-06-01', NULL, 9, 9, '���� ������������');

INSERT INTO hh.skills(title)
VALUES ('������������ �������� �����'),
       ('�������� � ��������'),
       ('���������� �� ���������'),
       ('������ � �������'),
       ('�������������������');

INSERT INTO hh.resume(user_id, phone, position_id, salary, about, shedule, status)
VALUES (1, '+79101234567', 1, 100000, '� ����� ������ �������', 'FULL_DAY', 'SHOW'),
       (2, '+79031234567', 2, 90000, '� ����� ������ �����', 'FULL_DAY', 'SHOW'),
       (3, '+79261234567', 3, 45000, '� ����� ������ ��������', 'FULL_DAY', 'SHOW'),
       (4, '+79161234567', 4, 200000, '� ����� ������ �����������', 'FULL_DAY', 'SHOW'),
       (5, '+79051234567', 5, 50000, '� ����� ���� ��������', 'FULL_DAY', 'SHOW');

INSERT INTO hh.resume_to_education(resume_id, education_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

INSERT INTO hh.resume_to_experience(resume_id, experience_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);

INSERT INTO hh.resume_to_skills(resume_id, skill_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

INSERT INTO hh.employers(user_id, organization_id)
VALUES (6, 1),
       (7, 2),
       (8, 3),
       (9, 4),
       (10, 5);

INSERT INTO hh.vacancy(user_id, position_id, city_id, salary_from, salary_to, about, status)
VALUES (6, 1, 1, NULL, NULL,
        '����� ������� � �����-������� ��� ��������� � �������������� �����, ��������� �������� �� ���������� ���� � ��������� �������������� ������������.',
        'OPEN'),
       (7, 2, 2, 50000, 100000,
        '�����������, �������� � ������ �������� ���������������� �������, ���� ������������ ������������ ��� ������������ ������.',
        'OPEN'),
       (8, 3, 11, NULL, NULL,
        '����� ���� ����������� ���������� ����� � ���������� ���������������� ������� � ������� ��������.', 'OPEN'),
       (9, 4, 9, 180000, NULL,
        '��������� � �������� ����� technopark.ru � ������ �������� ��������. ��������� � �� ������� ������ �������� ���������� � ������������� �������������� � �������.',
        'OPEN'),
       (10, 5, 5, 48000, NULL,
        '������, ����! �� ������ ���������� �����, ������� �� ���� ��������, ������ ��� �������� ������ � ������ �������� ��� ���� � ����� �������.',
        'OPEN');

INSERT INTO hh.vacancy_to_skills(vacancy_id, skill_id)
VALUES (1, 1),
       (4, 4),
       (5, 5);

INSERT INTO hh.talks(resume_id, vacancy_id, status)
VALUES (1, 1, 'OPEN'),
       (2, 2, 'ACCEPT'),
       (3, 3, 'ACCEPT_APP'),
       (4, 4, 'ACCEPT_EMP'),
       (5, 5, 'OPEN');

INSERT INTO hh.messages(talk_id, send_time, type, body)
VALUES (1, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL),
       (2, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'VACANCY', NULL),
       (3, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'VACANCY', NULL),
       (4, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL),
       (5, date(now() - trunc(1000 * random()) * '1 hour'::interval), 'RESUME', NULL);
INSERT INTO hh.messages(talk_id, send_time, type, body)
SELECT TRUNC(RANDOM() * 5 + 1),
       date(now() - trunc(1000 * random()) * '1 hour'::interval),
       CASE WHEN (random() > 0.5) THEN hh.message_type('TEXT_APP') ELSE hh.message_type('TEXT_EMP') END,
       'some message text'
FROM generate_series(1, 50);