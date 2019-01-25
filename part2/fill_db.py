from db import dbConn
import random

conn=dbConn('dbconnect.conf')
account_applicant_length = 1500#000
resume_length            = 2500#000
experience_length        = 5000#000
account_employer_length  =  500#000
employer_length          =  200#000
vacancy_length           = 1000#000
message_resume_length    = 1000#000
message_vacancy_length   = 1000#000
message_another_length   = 8000#000

print("1. Создаём таблицы")
conn.executeFile("./sql/create_db.sql")

print("2. Создаём соискателей")
print("	1. Заполняем таблицу пользователей")
conn.executeFile("./sql/fill_account.sql", account_applicant_length)

print("	2. Заполняем таблицу с резюме")
conn.executeFile("./sql/fill_resume.sql", resume_length, account_applicant_length)

print("	3. Заполняем таблицу с опытом работы")
if experience_length>resume_length:
	conn.executeFile("./sql/fill_experience.sql", experience_length, 1, resume_length, resume_length)
else:
	conn.executeFile("./sql/fill_experience.sql", experience_length, 1, 0, resume_length)

print("3. Создаём работодателей")
print("	1. Заполняем таблицу пользователей")
conn.executeFile("./sql/fill_account.sql", account_employer_length)

print("	2. Заполняем таблицу организаций")
conn.executeFile("./sql/fill_employer.sql", employer_length)

print("	3. Заполняем таблицу employer_account")
conn.executeFile("./sql/fill_employer_account.sql", account_employer_length, employer_length, account_applicant_length, 0)

print("	4. Заполняем таблицу вакансий")
conn.executeFile("./sql/fill_vacancy.sql", vacancy_length, employer_length)

print("4. Заполняем переписку")
print("	1. Заполняем обмен откликами")
conn.executeFile("./sql/fill_message_resume.sql", message_resume_length, resume_length, vacancy_length)
print("	2. Заполняем обмен предложениями")
conn.executeFile("./sql/fill_message_vacancy.sql", message_vacancy_length, resume_length, vacancy_length)
print("	3. Заполняем обмен сообщениями")
conn.executeFile("./sql/fill_message_another.sql", message_another_length, resume_length, vacancy_length)

print("Готово")