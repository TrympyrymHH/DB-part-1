-- считаем исходную таблицу
select * from count_tables_params('headhunter');
-- сдвигаем последовательности назначения
select * from prepare_offsets_and_target_sequences( 'new_big',    'headhunter',    'temp_data');
-- смотрим, есть ли что покопироват
select * from temp_data.get_schema_count('new_big');
-- убираем внешние ключи с купленной базы
select * from temp_data.kill_all_fkeys('new_big');
-- КОПИРУЕМ
select * from public.copy_next_chunk();
-- проверяем, что при вставке в боевую зазу мы не натыкаемся на конфликты
INSERT INTO headhunter.account(login, password, time_register) VALUES ('onemoreuser', 	md5('querty'), now());


-- а потом ещё немного..
select * from public.copy_next_chunk();
-- и ещё немного
select * from public.copy_next_chunk();
--- .....
select * from public.copy_next_chunk();
-- пока увы, совсем ничего не осталось
-- функция вернёт 0 если нечего больше копировать.

