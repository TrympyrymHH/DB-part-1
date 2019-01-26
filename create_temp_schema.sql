CREATE SCHEMA temp_data;

-- для уарощения вызова "копируй ещё" запизиваю параметры в спец. таблицу
CREATE TABLE temp_data.config
(
  param VARCHAR NOT NULL PRIMARY KEY ,
  param_type VARCHAR,
  value_text VARCHAR,
  value_int INTEGER
);

INSERT INTO temp_data.config
(param, param_type, value_text, value_int)
VALUES
('numer_of_records_by_iteration','int','',10000),
('source_scheme','text','new_big',null),
('target_scheme','text','headhunter',null),
('temp_scheme','text','temp_data',null);

-- служебная таблица, к которую буду складывать разницу в айдишниках
CREATE TABLE temp_data.table_serial_offset
(
  table_name VARCHAR,
  serial_column_name VARCHAR,
  serial_value_offset BIGINT,
  delta_id BIGINT,
  min_id BIGINT,
  schema VARCHAR,
  CONSTRAINT table_serial_offset_table_name_serial_column_name_schema_key UNIQUE (table_name, serial_column_name, schema);
)

-- если мы будем копировать таблицы в неправильном порядке, можеим попасть на ограничения внешних ключей в целевой базе
CREATE TABLE temp_data.table_sync_order
(
  table_name VARCHAR ,
  order_id INTEGER PRIMARY KEY
);

INSERT INTO temp_data.table_sync_order
(order_id, table_name)
VALUES
(1, 'account'),
(2, 'company'),
(3, 'resume'),
(4, 'resume_experience'),
(5, 'skill'),
(6, 'vacancy'),
(7, 'account_to_company_relation'),
(8, 'account_to_company_permission'),
(9, 'message');


