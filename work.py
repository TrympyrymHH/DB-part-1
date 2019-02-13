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
    
        # update table indices
        get_message_data_sql = """
        SELECT request_id, text, from_employer, time, seen
        FROM new_message
        ORDER BY message_id;

        """

        get_message_indices_sql = """
        SELECT message_id
        FROM new_message
        ORDER BY message_id;

        """        

        insert_new_message_sql = """
        INSERT INTO message(request_id, text, from_employer, time, seen)
        VALUES (%s, %s, %s, %s, %s) RETURNING message_id;

        """

        cursor.execute(get_message_indices_sql)
        new_items_indices = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_message_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            new_indices = []

            for i in items_to_insert:
                cursor.execute(insert_new_message_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indices += [cursor.fetchone()[0]]
                            
            new_items_inserting_indices = [x[0] for x in new_items_inserting_indices]
            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

def update_request_table(connection, cursor):
        # request limit
        N = 10000
        
        # update table indices
        get_request_data_sql = """
        SELECT is_invite, vacancy_id, applicant_id, seen
        FROM new_request
        ORDER BY request_id;

        """

        get_request_indices_sql = """
        SELECT request_id
        FROM new_request
        ORDER BY request_id;

        """        

        insert_new_request_sql = """
        INSERT INTO request(is_invite, vacancy_id, applicant_id, seen)
        VALUES (%s, %s, %s, %s) RETURNING request_id;

        """

        update_message_request_sql = update_table_field_sql('new_message', 'request_id')

        cursor.execute(get_request_indices_sql)
        new_items_indices = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_request_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            new_indices = []

            for i in items_to_insert:
                cursor.execute(insert_new_request_sql, (i[0], i[1], i[2], i[3]))
                new_indices += [cursor.fetchone()[0]]

            new_items_inserting_indices = [x[0] for x in new_items_inserting_indices]
            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_message_request_sql, same_items_index_pair)

def update_vacancy_table(connection, cursor):
        # request limit
        N = 10000
    
        # update table indices
        get_vacancy_data_sql = """
        SELECT text, employer_id, occupation_id, experience, city_id
        FROM new_vacancy
        ORDER BY vacancy_id;

        """

        get_vacancy_indices_sql = """
        SELECT vacancy_id
        FROM new_vacancy
        ORDER BY vacancy_id;

        """        

        insert_new_vacancy_sql = """
        INSERT INTO vacancy(text, employer_id, occupation_id, experience, city_id)
        VALUES (%s, %s, %s, %s, %s) RETURNING vacancy_id;

        """

        update_request_vacancy_sql = update_table_field_sql('new_request', 'vacancy_id')

        cursor.execute(get_vacancy_indices_sql)
        new_items_indices = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_vacancy_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            new_indices = []

            for i in items_to_insert:
                cursor.execute(insert_new_vacancy_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indices += [cursor.fetchone()[0]]
                            
            new_items_inserting_indices = [x[0] for x in new_items_inserting_indices]
            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_request_vacancy_sql, same_items_index_pair)

def update_experience_table(connection, cursor):
        # request limit
        N = 10000
    
        # update table indices
        get_experience_data_sql = """
        SELECT resume_id, city_id, start_date, finish_date, occupation_id
        FROM new_experience
        ORDER BY experience_id;

        """

        get_experience_indices_sql = """
        SELECT experience_id
        FROM new_experience
        ORDER BY experience_id;

        """        

        insert_new_experience_sql = """
        INSERT INTO experience(resume_id, city_id, start_date, finish_date, occupation_id)
        VALUES (%s, %s, %s, %s, %s) RETURNING experience_id;

        """

        cursor.execute(get_experience_indices_sql)
        new_items_indices = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_experience_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            new_indices = []

            for i in items_to_insert:
                cursor.execute(insert_new_experience_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indices += [cursor.fetchone()[0]]
                            
            new_items_inserting_indices = [x[0] for x in new_items_inserting_indices]
            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

def update_resume_table(connection, cursor):
        # request limit
        N = 10000

        # update table indices
        get_resume_data_sql = """
        SELECT applicant_id, occupation_id, text, city_id
        FROM new_resume
        ORDER BY resume_id;

        """

        get_resume_indices_sql = """
        SELECT resume_id
        FROM new_resume
        ORDER BY resume_id;

        """        

        insert_new_resume_sql = """
        INSERT INTO resume(applicant_id, occupation_id, text, city_id)
        VALUES (%s, %s, %s, %s) RETURNING resume_id;

        """

        update_experience_resume_sql = update_table_field_sql('new_experience', 'resume_id')

        cursor.execute(get_resume_indices_sql)
        new_items_indices = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_resume_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            new_indices = []

            for i in items_to_insert:
                cursor.execute(insert_new_resume_sql, (i[0], i[1], i[2], i[3]))
                new_indices += [cursor.fetchone()[0]]
                            
            new_items_inserting_indices = [x[0] for x in new_items_inserting_indices]
            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_experience_resume_sql, same_items_index_pair)

def update_applicant_table(connection, cursor):
        # request limit
        N = 10000

        # update table indices
        get_applicant_data_sql = """
        SELECT name, login, password, login_timestamp, logout_timestamp
        FROM new_applicant
        ORDER BY applicant_id;

        """

        get_applicant_indices_sql = """
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

        cursor.execute(get_applicant_indices_sql)
        new_items_indices = cursor.fetchall()
        
        same_items_index_pair = []
        
        cursor.execute(get_applicant_data_sql)
        new_items_data = cursor.fetchall()

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            new_indices = []

            for i in items_to_insert:
                cursor.execute(insert_new_applicant_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indices += [cursor.fetchone()[0]]
                            
            new_items_inserting_indices = [x[0] for x in new_items_inserting_indices]
            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))
            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_resume_applicant_sql, same_items_index_pair)
        extras.execute_values(cursor, update_request_applicant_sql, same_items_index_pair)

def update_occupation_table(connection, cursor):
        # request limit
        N = 10000

        # update table indices
        compare_occupation_indices_sql = """
        SELECT new_occupation.occupation_id, occupation.occupation_id, new_occupation.name
        FROM new_occupation
        LEFT JOIN occupation ON (lower(occupation.name) = lower(new_occupation.name));
        """
        
        insert_new_occupation_indices_sql = """
        INSERT INTO occupation (name)
        SELECT field
        FROM unnest(%s) s(field)
        RETURNING occupation_id
        """

        update_vacancy_occupation_sql = update_table_field_sql('new_vacancy', 'occupation_id')

        update_resume_occupation_sql = update_table_field_sql('new_resume', 'occupation_id')

        update_experience_occupation_sql = update_table_field_sql('new_experience', 'occupation_id')

        cursor.execute(compare_occupation_indices_sql)
        old_new_indices = cursor.fetchall()
        
        same_items = [x for x in old_new_indices if x[1] != None]
        same_items_index_pair = [[x[0], x[1]] for x in same_items]
        
        new_items = [x for x in old_new_indices if x[1] == None]
        new_items_data = [(x[2], ) for x in new_items]
        new_items_indices = [x[0] for x in new_items]

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            cursor.execute(insert_new_occupation_indices_sql, (items_to_insert, ))

            new_indices = cursor.fetchall()
            new_indices = [x[0] for x in new_indices]

            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))

            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_vacancy_occupation_sql, same_items_index_pair)

def update_employer_table(connection, cursor):
        # request limit
        N = 10000

        # update table indices
        compare_employer_indices_sql = """
        SELECT new_employer.employer_id, employer.employer_id, new_employer.name
        FROM new_employer
        LEFT JOIN employer ON (lower(employer.name) = lower(new_employer.name));
        """
        
        insert_new_employer_indices_sql = """
        INSERT INTO employer (name)
        SELECT field
        FROM unnest(%s) s(field)
        RETURNING employer_id
        """

        update_vacancy_employer_sql = update_table_field_sql('new_vacancy', 'employer_id')

        cursor.execute(compare_employer_indices_sql)
        old_new_indices = cursor.fetchall()

        same_items = [x for x in old_new_indices if x[1] != None]
        same_items_index_pair = [[x[0], x[1]] for x in same_items]
        
        new_items = [x for x in old_new_indices if x[1] == None]
        new_items_data = [(x[2], ) for x in new_items]
        new_items_indices = [x[0] for x in new_items]

        while len(new_items_data) > 0:
            items_to_insert = new_items_data[0 : N]
            new_items_inserting_indices = new_items_indices[0 : N]

            new_items_data = new_items_data[N : ]
            new_items_indices = new_items_indices[N : ]

            cursor.execute(insert_new_employer_indices_sql, (items_to_insert, ))

            new_indices = cursor.fetchall()
            new_indices = [x[0] for x in new_indices]

            new_index_pairs = list(zip(new_items_inserting_indices, new_indices))

            same_items_index_pair += new_index_pairs
            
            connection.commit()

        extras.execute_values(cursor, update_vacancy_employer_sql, same_items_index_pair)

def update_city_table(connection, cursor):
        # request limit
        N = 10000

        # update table indices
        compare_city_indices_sql = """
        SELECT new_city.city_id, city.city_id, new_city.name
        FROM new_city
        LEFT JOIN city ON (lower(city.name) = lower(new_city.name));
        """

        compare_city_indices_sql_analyze = """
        explain analyze 
        SELECT new_city.city_id, city.city_id, new_city.name
        FROM new_city
        LEFT JOIN city ON (lower(city.name) = lower(new_city.name));
        """
        
        insert_new_city_indices_sql = """
        INSERT INTO city (name)
        SELECT field
        FROM unnest(%s) s(field)
        RETURNING city_id
        """

        update_vacancy_city_sql = update_table_field_sql('new_vacancy', 'city_id')

        update_resume_city_sql = update_table_field_sql('new_resume', 'city_id')

        update_experience_city_sql = update_table_field_sql('new_experience', 'city_id')

        cursor.execute(compare_city_indices_sql_analyze)
        analyze_fetched = cursor.fetchall()
        print('ANALYZE:')
        print(analyze_fetched)
        print('ANALYZE END')

        cursor.execute(compare_city_indices_sql)
        old_new_indices = cursor.fetchall()
        
        same_cities = [x for x in old_new_indices if x[1] != None]
        same_cities_index_pair = [[x[0], x[1]] for x in same_cities]
        
        new_cities = [x for x in old_new_indices if x[1] == None]
        new_cities_data = [(x[2], ) for x in new_cities]
        new_cities_indices = [x[0] for x in new_cities]

        while len(new_cities_data) > 0:
            cities_to_insert = new_cities_data[0 : N]
            new_cities_inserting_indices = new_cities_indices[0 : N]

            new_cities_data = new_cities_data[N : ]
            new_cities_indices = new_cities_indices[N : ]

            cursor.execute(insert_new_city_indices_sql, (cities_to_insert, ))

            new_indices = cursor.fetchall()
            new_indices = [x[0] for x in new_indices]

            new_index_pairs = list(zip(new_cities_inserting_indices, new_indices))

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

        #add indices
        connection.autocommit = True
        cursor.execute('CREATE INDEX CONCURRENTLY city_name ON city(lower(name));')
        cursor.execute('CREATE INDEX CONCURRENTLY employer_name ON employer(lower(name));')
        cursor.execute('CREATE INDEX CONCURRENTLY occupation_name ON occupation(lower(name));')
        connection.autocommit = False


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

        #delete indices
        connection.autocommit = True
        cursor.execute('DROP INDEX CONCURRENTLY city_name;')
        cursor.execute('DROP INDEX CONCURRENTLY employer_name;')
        cursor.execute('DROP INDEX CONCURRENTLY occupation_name;')
        connection.autocommit = False

        cursor.close() 
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if connection is not None:
            connection.close()    
  
if __name__ == '__main__':
    add_db()
