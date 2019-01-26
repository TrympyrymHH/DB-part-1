-- для облегчения кода накопипастил из гугла удобных запросов и обернул во фьхи

-- информация по внешним ключам

CREATE OR REPLACE VIEW temp_data.fkeys AS
 SELECT ss3."table",
    ss3."column",
    ss3.foreign_table,
    ss3.foreign_column
   FROM ( SELECT ss2.conrelid::regclass::text AS "table",
            a.attname AS "column",
            ss2.confrelid::regclass::text AS foreign_table,
            af.attname AS foreign_column
           FROM pg_attribute af,
            pg_attribute a,
            ( SELECT ss.conrelid,
                    ss.confrelid,
                    ss.conkey[ss.i] AS conkey,
                    ss.confkey[ss.i] AS confkey
                   FROM ( SELECT pg_constraint.conrelid,
                            pg_constraint.confrelid,
                            pg_constraint.conkey,
                            pg_constraint.confkey,
                            generate_series(1, array_upper(pg_constraint.conkey, 1)) AS i
                           FROM pg_constraint
                          WHERE pg_constraint.contype = 'f'::"char") ss) ss2
          WHERE af.attnum = ss2.confkey AND af.attrelid = ss2.confrelid AND a.attnum = ss2.conkey AND a.attrelid = ss2.conrelid) ss3;

-- информация по таблицам

CREATE OR REPLACE VIEW temp_data.tables_info AS
 SELECT n.nspname,
    t.relname AS related_table,
    a.attname AS related_column,
    s.relname AS sequence_name
   FROM pg_class s
     JOIN pg_depend d ON d.objid = s.oid
     JOIN pg_class t ON d.objid = s.oid AND d.refobjid = t.oid
     JOIN pg_attribute a ON d.refobjid = a.attrelid AND d.refobjsubid = a.attnum
     JOIN pg_namespace n ON n.oid = s.relnamespace
  WHERE s.relkind = 'S'::"char";
