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

def update_applicant_table(connection, cursor):
        # request limit
        N = 10000

        # update city table indexes
        get_applicant_data_sql = """
        SELECT name, login, password, login_timestamp, logout_timestamp
        FROM new_applicant
        LIMIT 10;

        """

        get_applicant_indexes_sql = """
        SELECT applicant_id
        FROM new_applicant;

        """        

        insert_new_applicant_indexes_sql = """
        INSERT INTO applicant(name, login, password, login_timestamp, logout_timestamp)
        VALUES (%s, %s, %s, %s, %s) RETURNING applicant_id;
        """

        # update_vacancy_occupation_sql = update_table_field_sql('new_vacancy', 'occupation_id')

        # update_resume_occupation_sql = update_table_field_sql('new_resume', 'occupation_id')

        # update_experience_occupation_sql = update_table_field_sql('new_experience', 'occupation_id')


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
                # cursor.execute(insert_new_applicant_indexes_sql, (items_to_insert, ))
                print('item')
                print(i[0])
                print(i[1])
                print(i[2])
                print(i[3])
                print(i[4])
                cursor.execute(insert_new_applicant_indexes_sql, (i[0], i[1], i[2], i[3], i[4]))
                new_indexes += cursor.fetchone()
                print(cursor.fetchone()[0])

            for p in new_items_indexes:
                print(p)
            
            new_indexes = list(map(lambda x: x[0], new_indexes))

            new_index_pairs = list(zip(new_items_inserting_indexes, new_indexes))

            same_items_index_pair += new_index_pairs
            
            connection.commit()

        # extras.execute_values(cursor, update_vacancy_occupation_sql, same_items_index_pair)

def update_occupation_table(connection, cursor):
        # request limit
        N = 10000

        # update city table indexes
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

        # update city table indexes
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

        # update city table indexes
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

        # update_city_table(connection, cursor)
        # update_employer_table(connection, cursor)
        # update_occupation_table(connection, cursor)
        update_applicant_table(connection, cursor)

        cursor.close() 
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if connection is not None:
            connection.close()    
  
if __name__ == '__main__':
    add_db()
