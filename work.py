#!/usr/bin/python
import psycopg2
from psycopg2 import extras

def update_table_field_sql(table, field):
    return """
        UPDATE {}
        SET {} = data.new_index 
        FROM (VALUES %s) AS data(old_index, new_index)
        WHERE {} = data.old_index;
        """.format(table, field, field)

def update_message_table(connection, cursor):
        # request limit
        N = 10000
    
        # update table indexes
        get_message_data_sql = """
        SELECT request_id, text, from_employer, time, seen
        FROM new_message
        ORDER BY message_id;

        """

        get_message_indexes_sql = """
        SELECT message_id
        FROM new_message
        ORDER BY message_id;

        """        

        insert_new_message_sql = """
        INSERT INTO message(request_id, text, from_employer, time, seen)
        VALUES (%s, %s, %s, %s, %s) RETURNING message_id;

        """

        cursor.execute(get_message_indexes_sql)
        new_items_indexes = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_message_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            new_indexes = []

            for i in items_to_insert:
                cursor.execute(insert_new_message_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indexes += [cursor.fetchone()[0]]
                            
            new_items_inserting_indexes = list(map(lambda x: x[0], new_items_inserting_indexes))
            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

def update_request_table(connection, cursor):
        # request limit
        N = 10000
        
        # update table indexes
        get_request_data_sql = """
        SELECT is_invite, vacancy_id, applicant_id, seen
        FROM new_request
        ORDER BY request_id;

        """

        get_request_indexes_sql = """
        SELECT request_id
        FROM new_request
        ORDER BY request_id;

        """        

        insert_new_request_sql = """
        INSERT INTO request(is_invite, vacancy_id, applicant_id, seen)
        VALUES (%s, %s, %s, %s) RETURNING request_id;

        """

        update_message_request_sql = update_table_field_sql('new_message', 'request_id')

        cursor.execute(get_request_indexes_sql)
        new_items_indexes = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_request_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            new_indexes = []

            for i in items_to_insert:
                cursor.execute(insert_new_request_sql, (i[0], i[1], i[2], i[3]))
                new_indexes += [cursor.fetchone()[0]]
                            
            new_items_inserting_indexes = list(map(lambda x: x[0], new_items_inserting_indexes))
            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_message_request_sql, same_items_index_pair)

def update_vacancy_table(connection, cursor):
        # request limit
        N = 10000
    
        # update table indexes
        get_vacancy_data_sql = """
        SELECT text, employer_id, occupation_id, experience, city_id
        FROM new_vacancy
        ORDER BY vacancy_id;

        """

        get_vacancy_indexes_sql = """
        SELECT vacancy_id
        FROM new_vacancy
        ORDER BY vacancy_id;

        """        

        insert_new_vacancy_sql = """
        INSERT INTO vacancy(text, employer_id, occupation_id, experience, city_id)
        VALUES (%s, %s, %s, %s, %s) RETURNING vacancy_id;

        """

        update_request_vacancy_sql = update_table_field_sql('new_request', 'vacancy_id')

        cursor.execute(get_vacancy_indexes_sql)
        new_items_indexes = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_vacancy_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            new_indexes = []

            for i in items_to_insert:
                cursor.execute(insert_new_vacancy_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indexes += [cursor.fetchone()[0]]
                            
            new_items_inserting_indexes = list(map(lambda x: x[0], new_items_inserting_indexes))
            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_request_vacancy_sql, same_items_index_pair)

def update_experience_table(connection, cursor):
        # request limit
        N = 10000
    
        # update table indexes
        get_experience_data_sql = """
        SELECT resume_id, city_id, start_date, finish_date, occupation_id
        FROM new_experience
        ORDER BY experience_id;

        """

        get_experience_indexes_sql = """
        SELECT experience_id
        FROM new_experience
        ORDER BY experience_id;

        """        

        insert_new_experience_sql = """
        INSERT INTO experience(resume_id, city_id, start_date, finish_date, occupation_id)
        VALUES (%s, %s, %s, %s, %s) RETURNING experience_id;

        """

        cursor.execute(get_experience_indexes_sql)
        new_items_indexes = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_experience_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            new_indexes = []

            for i in items_to_insert:
                cursor.execute(insert_new_experience_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indexes += [cursor.fetchone()[0]]
                            
            new_items_inserting_indexes = list(map(lambda x: x[0], new_items_inserting_indexes))
            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

def update_resume_table(connection, cursor):
        # request limit
        N = 10000

        # update table indexes
        get_resume_data_sql = """
        SELECT applicant_id, occupation_id, text, city_id
        FROM new_resume
        ORDER BY resume_id;

        """

        get_resume_indexes_sql = """
        SELECT resume_id
        FROM new_resume
        ORDER BY resume_id;

        """        

        insert_new_resume_sql = """
        INSERT INTO resume(applicant_id, occupation_id, text, city_id)
        VALUES (%s, %s, %s, %s) RETURNING resume_id;

        """

        update_experience_resume_sql = update_table_field_sql('new_experience', 'resume_id')

        cursor.execute(get_resume_indexes_sql)
        new_items_indexes = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_resume_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            new_indexes = []

            for i in items_to_insert:
                cursor.execute(insert_new_resume_sql, (i[0], i[1], i[2], i[3]))
                new_indexes += [cursor.fetchone()[0]]
                            
            new_items_inserting_indexes = list(map(lambda x: x[0], new_items_inserting_indexes))
            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_experience_resume_sql, same_items_index_pair)

def update_applicant_table(connection, cursor):
        # request limit
        N = 10000

        # update table indexes
        get_applicant_data_sql = """
        SELECT name, login, password, login_timestamp, logout_timestamp
        FROM new_applicant
        ORDER BY applicant_id;

        """

        get_applicant_indexes_sql = """
        SELECT applicant_id
        FROM new_applicant
        ORDER BY applicant_id;

        """        

        insert_new_applicant_sql = """
        INSERT INTO applicant(name, login, password, login_timestamp, logout_timestamp)
        VALUES (%s, %s, %s, %s, %s) RETURNING applicant_id;

        """

        update_resume_applicant_sql = update_table_field_sql('new_resume', 'applicant_id')
        update_request_applicant_sql = update_table_field_sql('new_request', 'applicant_id')

        cursor.execute(get_applicant_indexes_sql)
        new_items_indexes = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_applicant_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            new_indexes = []

            for i in items_to_insert:
                cursor.execute(insert_new_applicant_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indexes += [cursor.fetchone()[0]]
                            
            new_items_inserting_indexes = list(map(lambda x: x[0], new_items_inserting_indexes))
            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_resume_applicant_sql, same_items_index_pair)
        extras.execute_values(cursor, update_request_applicant_sql, same_items_index_pair)

def update_occupation_table(connection, cursor):
        # request limit
        N = 10000

        # update table indexes
        compare_occupation_indexes_sql = """
        SELECT new_occupation.occupation_id, occupation.occupation_id, new_occupation.name
        FROM new_occupation
        LEFT JOIN occupation USING (name);
        """
        
        insert_new_occupation_indexes_sql = """
        INSERT INTO occupation (name)
        SELECT field
        FROM unnest(%s) s(field)
        RETURNING occupation_id
        """

        update_vacancy_occupation_sql = update_table_field_sql('new_vacancy', 'occupation_id')

        update_resume_occupation_sql = update_table_field_sql('new_resume', 'occupation_id')

        update_experience_occupation_sql = update_table_field_sql('new_experience', 'occupation_id')

        cursor.execute(compare_occupation_indexes_sql)
        old_new_indexes = cursor.fetchall()
        
        same_items = list(filter(lambda x: x[1] != None, old_new_indexes))
        same_items_index_pair = list(map(lambda x: [x[0], x[1]], same_items))
        
        new_items = list(filter(lambda x: x[1] == None, old_new_indexes))
        new_items_data = list(map(lambda x: (x[2], ), new_items))
        new_items_indexes = list(map(lambda x: x[0], new_items))

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            cursor.execute(insert_new_occupation_indexes_sql, (items_to_insert, ))

            new_indexes = cursor.fetchall()
            new_indexes = list(map(lambda x: x[0], new_indexes))

            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))

            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_vacancy_occupation_sql, same_items_index_pair)

def update_employer_table(connection, cursor):
        # request limit
        N = 10000

        # update table indexes
        compare_employer_indexes_sql = """
        SELECT new_employer.employer_id, employer.employer_id, new_employer.name
        FROM new_employer
        LEFT JOIN employer USING (name);
        """
        
        insert_new_employer_indexes_sql = """
        INSERT INTO employer (name)
        SELECT field
        FROM unnest(%s) s(field)
        RETURNING employer_id
        """

        update_vacancy_employer_sql = update_table_field_sql('new_vacancy', 'employer_id')

        cursor.execute(compare_employer_indexes_sql)
        old_new_indexes = cursor.fetchall()
        
        same_items = list(filter(lambda x: x[1] != None, old_new_indexes))
        same_items_index_pair = list(map(lambda x: [x[0], x[1]], same_items))
        
        new_items = list(filter(lambda x: x[1] == None, old_new_indexes))
        new_items_data = list(map(lambda x: (x[2], ), new_items))
        new_items_indexes = list(map(lambda x: x[0], new_items))

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indexes = new_items_indexes[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indexes = new_items_indexes[N : ]

            cursor.execute(insert_new_employer_indexes_sql, (items_to_insert, ))

            new_indexes = cursor.fetchall()
            new_indexes = list(map(lambda x: x[0], new_indexes))

            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))

            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_vacancy_employer_sql, same_items_index_pair)

def update_city_table(connection, cursor):
        # request limit
        N = 10000

        # update table indexes
        compare_city_indexes_sql = """
        SELECT new_city.city_id, city.city_id, new_city.name
        FROM new_city
        LEFT JOIN city USING (name);
        """
        
        insert_new_city_indexes_sql = """
        INSERT INTO city (name)
        SELECT field
        FROM unnest(%s) s(field)
        RETURNING city_id
        """

        update_vacancy_city_sql = update_table_field_sql('new_vacancy', 'city_id')

        update_resume_city_sql = update_table_field_sql('new_resume', 'city_id')

        update_experience_city_sql = update_table_field_sql('new_experience', 'city_id')

        cursor.execute(compare_city_indexes_sql)
        old_new_indexes = cursor.fetchall()
        
        same_cities = list(filter(lambda x: x[1] != None, old_new_indexes))
        same_cities_index_pair = list(map(lambda x: [x[0], x[1]], same_cities))
        
        new_cities = list(filter(lambda x: x[1] == None, old_new_indexes))
        new_cities_data = list(map(lambda x: (x[2], ), new_cities))
        new_cities_indexes = list(map(lambda x: x[0], new_cities))

        while len(new_cities_data) > 0:
            cities_to_insert = new_cities_data[0 : N]
            new_cities_inserting_indexes = new_cities_indexes[0 : N]

            new_cities_data = new_cities_data[N : ]
            new_cities_indexes = new_cities_indexes[N : ]

            cursor.execute(insert_new_city_indexes_sql, (cities_to_insert, ))

            new_indexes = cursor.fetchall()
            new_indexes = list(map(lambda x: x[0], new_indexes))

            new_index_pairs = list(zip(new_cities_inserting_indexes, new_indexes))

            same_cities_index_pair += new_index_pairs

            connection.commit()

        extras.execute_values(cursor, update_vacancy_city_sql, same_cities_index_pair)
        extras.execute_values(cursor, update_resume_city_sql, same_cities_index_pair)
        extras.execute_values(cursor, update_experience_city_sql, same_cities_index_pair)


def add_db():
    conn = None
    try:
        connection = psycopg2.connect(host="localhost", database="postgres", user="postgres", password="")
        cursor = connection.cursor()

        print('city...')
        update_city_table(connection, cursor)
        print('employer...')
        update_employer_table(connection, cursor)
        print('occupation...')
        update_occupation_table(connection, cursor)
        print('applicant...')
        update_applicant_table(connection, cursor)
        print('resume...')
        update_resume_table(connection, cursor)
        print('experience...')
        update_experience_table(connection, cursor)
        print('vacancy...')
        update_vacancy_table(connection, cursor)
        print('request...')
        update_request_table(connection, cursor)
        print('message...')
        update_message_table(connection, cursor)


        cursor.close() 
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if connection is not None:
            connection.close()    
  
if __name__ == '__main__':
    add_db()
