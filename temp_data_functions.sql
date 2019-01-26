-- собственно, подкапотная магия

-- первое, что нужно вызвать -------------------------------------------------------------------------------------------
-- эта функция посчитает размеры таблиц купленной базы, положит посчитанные значения в спец. таблицу
-- один раз дёрнули перед работой И БОЛЬШЕ НЕ ДЁРГАЕМ

CREATE OR REPLACE FUNCTION public.count_tables_params(schema_name character varying)
  RETURNS integer AS
$BODY$
DECLARE step record;
BEGIN
 FOR step IN(SELECT * from temp_data.tables_info where nspname= $1)
 LOOP
	BEGIN
	EXECUTE FORMAT ('INSERT INTO temp_data.table_serial_offset
		(schema, table_name, serial_column_name, delta_id, min_id)
		VALUES (''%s'',''%s'',''%s'',
			(SELECT (max(%s) - min(%s)) from %s),
			(SELECT min(%s) from %s))
		ON CONFLICT (schema, table_name, serial_column_name) DO UPDATE
			SET
			delta_id = excluded.delta_id,
			min_id = excluded.min_id;
		', step.nspname, step.related_table, step.related_column,
		step.related_column, step.related_column, step.nspname||'.'||step.related_table,
		step.related_column, step.nspname||'.'||step.related_table);
	EXCEPTION   WHEN OTHERS   THEN RETURN 0;
	END;

END LOOP;
RETURN 1;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

-- вторая функция ------------------------------------------------------------------------------------------------------
-- эта уже лезет в боевые базы и двигает последовательности, соглачно рачсетам из count_tables_params
-- дописывает дополнителдьные данные ы спец. таблицу
-- НЕ БУДЕТ выполняться, если в таковой уже есть значения.
-- эта фича, сделанная для предотвращения повторнрго сдвига последовательностей боевой базы

CREATE OR REPLACE FUNCTION public.prepare_offsets_and_target_sequences(
    source_schema_name character varying,
    target_schema_name character varying,
    temp_schema_name character varying)
  RETURNS integer AS
$BODY$
DECLARE step record;
DECLARE next_value integer;

BEGIN

FOR step IN(SELECT * from get_table_lens(source_schema_name))
LOOP

begin

CONTINUE WHEN
	(SELECT (serial_value_offset is not null)
	FROM temp_data.table_serial_offset
	WHERE table_name = step.table_name AND serial_column_name = step.serial_column_name AND schema = target_schema_name);

-- промониторил блокировки, устанавливаемые следующим запросом.
-- на момент получения значения для nextval установлена ROW EXCLUSIVE блокировка на изменяесой последовательности,
-- значит, не может быть ситуации, при которой между получением и установкой нового значения его кто-то менят.


EXECUTE FORMAT
('(with next as (select (nextval(''%s''))),
corrected as (select setval(''%s'',(select nextval from next)+ %s ))

select nextval
from next, corrected)',
target_schema_name||'.'||step.related_sequence_name,
target_schema_name||'.'||step.related_sequence_name,
(step.delta_id)) INTO next_value;

-- пишем результаты в базу
EXECUTE FORMAT
('insert into %s.table_serial_offset
	(table_name,
	serial_value_offset,
	serial_column_name,
	schema)
VALUES (''%s'', %s, ''%s'', ''%s'')
ON CONFLICT (schema, table_name, serial_column_name)
DO UPDATE SET serial_value_offset = EXCLUDED.serial_value_offset;',
$3, -- into %s.table_serial_offset
step.table_name, -- VALUES (''%s'',
next_value,
step.serial_column_name,
target_schema_name);
--EXCEPTION   WHEN OTHERS   THEN RETURN 0; -- не хочу тут получать исключения, лучше уж кодом когда-нибудь обработаю
end;

END LOOP;

RETURN 1;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

-- отдельно вывел простую функцию, которая дёргает состояние копируемых таблиц -----------------------------------------
-- всё просто, если хотим промониторить состояния копирования таблиц, дёграем и видим, что ещё недокопировано
CREATE OR REPLACE FUNCTION temp_data.get_schema_count(IN schema_name character varying)
  RETURNS TABLE(table_name character varying, count integer) AS
$BODY$
DECLARE step record;

BEGIN
 FOR step IN(select tables.table_name -- выбираю все таблицы для заданной схемы
		from information_schema.tables
		left join temp_data.table_sync_order USING (table_name)
		where table_schema =  $1
		ORDER BY order_id)

 LOOP
	EXECUTE FORMAT ('SELECT COUNT(*) FROM %s.%s', schema_name , step.table_name) INTO count;
	table_name := step.table_name;
	RETURN NEXT;

END LOOP;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;


-- немаловажно избавиться от внешних ключей на копируемой базе, иначе вообще весь фокус не удастся ---------------------

CREATE OR REPLACE FUNCTION temp_data.kill_all_fkeys(schema_name character varying)
  RETURNS integer AS
$BODY$
DECLARE step record;
BEGIN
 FOR step IN (SELECT table_schema, constraint_name, table_name
		FROM information_schema.table_constraints
		WHERE constraint_type = 'FOREIGN KEY' AND table_schema = $1)
 LOOP

	EXECUTE FORMAT('ALTER TABLE %s.%s DROP CONSTRAINT %s;',$1, step.table_name, step.constraint_name );

END LOOP;
RETURN 1;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

-- корректируем значения изменившихся айдишников и связанных с ними полей
-- если коротко, то смотрим в спец. таблице на наличие смещения рассматриваемого айдишника
-- и на связи этого айдишника по внешним ключам,
-- если его нигде не значится, то возвращаем как есть,
-- если есть, то в виде "account+35647"

CREATE OR REPLACE FUNCTION temp_data.correct_value(
    table_name character varying,
    column_name character varying)
  RETURNS character varying AS
$BODY$
DECLARE min INTEGER;
DECLARE value_offset INTEGER;

BEGIN
	value_offset:=0;
	min:=0;

	SELECT  min_id , serial_value_offset
	FROM temp_data.table_serial_offset
	left join temp_data.fkeys on
		((fkeys.foreign_table = table_serial_offset.schema||'.'||table_serial_offset.table_name)
			AND
		(fkeys.foreign_column = table_serial_offset.serial_column_name))
	WHERE
		(table_serial_offset.table_name = $1 AND table_serial_offset.serial_column_name = $2)
			OR
		(fkeys.table = schema||'.'||$1 AND fkeys.column = $2) INTO min, value_offset;

IF min <> 0 THEN
	RETURN $2||'+'||(value_offset - min)::text;
END IF;
	RETURN $2;

END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION temp_data.correct_value(character varying, character varying)
  OWNER TO postgres;


------------------------------------------------------------------------------------------------------------------------
------------------------------ КОПИРОВАНИЕ -----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.copy_next_chunk()
  RETURNS integer AS
$BODY$
DECLARE step record;
DECLARE result INTEGER;

DECLARE source_scheme VARCHAR;
DECLARE target_scheme VARCHAR;
DECLARE numer_of_records_by_iteration INTEGER;

DECLARE current_table VARCHAR;
DECLARE current_table_pkey VARCHAR;
DECLARE current_table_columns VARCHAR;
DECLARE current_table_columns_corr VARCHAR;

BEGIN
  result:= 0;

-- получим из конфига необходимые параметры
  SELECT value_text FROM temp_data.config WHERE param = 'source_scheme' INTO source_scheme;
  SELECT value_text FROM temp_data.config WHERE param = 'target_scheme' INTO target_scheme;
  SELECT value_int FROM temp_data.config WHERE param = 'numer_of_records_by_iteration' INTO numer_of_records_by_iteration;

-- ищем таблицу, в которой записей больше 0
 FOR step IN(SELECT * from temp_data.get_schema_count(source_scheme))
 LOOP
	IF step.count > 0 THEN
		current_table := step.table_name;
		result := 1;
		EXIT;
	END IF;
END LOOP;
-- погнали!
-- если копировать больше нечего, выходим
	IF result = 0 THEN RETURN 0; END IF;

	-- получим набор колонок данной таблицы
	SELECT string_agg(column_name,',')
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE table_name = current_table AND table_schema = target_scheme INTO current_table_columns;

	-- колонки, которые ссылаются на последовательности должны быть модифицированы так, чтобы они
	-- соответствовали новой базе и не конфликтовали, здесь строка с полями будет выглядеть примерно так:
	-- account_id+302395,login,password,time_register,time_last_login
	SELECT string_agg(temp_data.correct_value(current_table,column_name),',')
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE table_name = current_table AND table_schema = target_scheme INTO current_table_columns_corr;

	-- получим первичный ключ  обрабатываемой базы
	current_table_pkey := temp_data.get_table_pkey(target_scheme,current_table);

	--вытащим список ключей с которыми будем работать
	CREATE TEMP TABLE __temp__pkeys_in_work(pkey INT);
	EXECUTE FORMAT ('INSERT INTO __temp__pkeys_in_work (pkey) select %s from %s limit %s', current_table_pkey, source_scheme||'.'||current_table, numer_of_records_by_iteration);

BEGIN 	-- эту вещь сделаем отдельной транзакцией
	-- КОПИРУЕМ
	EXECUTE FORMAT ('INSERT INTO %s
			(%s)
			SELECT %s
			FROM %s
			WHERE %s IN (SELECT pkey FROM __temp__pkeys_in_work )',
			target_scheme||'.'||current_table,
			current_table_columns,
			current_table_columns_corr,
			source_scheme||'.'||current_table,
			current_table_pkey);

	-- если всё норм, удаляем кусок
	 EXECUTE FORMAT ('DELETE FROM %s WHERE %s IN (SELECT pkey FROM __temp__pkeys_in_work )', source_scheme||'.'||current_table, current_table_pkey);
--EXCEPTION   WHEN OTHERS   THEN RETURN 0; -- не буду обрабатывать ексепшн тут, пусть летит в код
END;
	DROP TABLE __temp__pkeys_in_work;
RETURN 1;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

