##EXPLAIN  ANALYZE

### ИЗМЕНЕНИЕ ПОСЛЕДОВАТЕЛЬНОСТЕЙ

```sql
EXPLAIN  ANALYZE  
with next as (select (nextval('headhunter.company_company_id_seq'))),

corrected as (select setval('headhunter.company_company_id_seq',
(select nextval from next)+ 9 ))

select nextval
from next, corrected;
```

Даёт результат

``` 
"Nested Loop  (cost=0.05..0.10 rows=1 width=8) (actual time=0.519..0.519 rows=1 loops=1)"
"  CTE next"
"    ->  Result  (cost=0.00..0.01 rows=1 width=8) (actual time=0.496..0.497 rows=1 loops=1)"
"  CTE corrected"
"    ->  Result  (cost=0.02..0.04 rows=1 width=8) (actual time=0.012..0.012 rows=1 loops=1)"
"          InitPlan 2 (returns $1)"
"            ->  CTE Scan on next next_1  (cost=0.00..0.02 rows=1 width=8) (actual time=0.000..0.001 rows=1 loops=1)"
"  ->  CTE Scan on next  (cost=0.00..0.02 rows=1 width=8) (actual time=0.500..0.501 rows=1 loops=1)"
"  ->  CTE Scan on corrected  (cost=0.00..0.02 rows=1 width=0) (actual time=0.014..0.014 rows=1 loops=1)"
"Planning time: 0.116 ms"
"Execution time: 0.757 ms"
```
Вроде, ничего криминального, тут интересней другое.
---
Если я модифицирую запрос следующим образом:

```sql
with next as (select (nextval('headhunter.company_company_id_seq'))),
vd as (select * from pg_sleep(10)),
corrected as (select setval('headhunter.company_company_id_seq',
(select nextval from next)+ 9 ))

select nextval
from next, vd,  corrected;
``` 

И в момент выполнения запроса дёрну информацию по блокировкам, то увижу среди прочих 

|db|locktype|mode|grandted|
|---|---|---|---|
|hh | headhunter.company_company_id_seq|RowExclusiveLock|t|

Это означает, что исключена ситуация при которой во время моего запроса может быть изменено значение nextval на незапланированное. 

### КОПИРОВАНИЕ

Понятно, что запросы дёргаются функцией, но если их оттуда эксгумировать, то увидим следующую картину. 
Что интересно, один и тот же запрос ведёт себя по разному в зависимости от количества записей в исходной таблице. 
Работа с миллионами записей у меня на домашней машине занимает аццкое время поэтому таких экспериментов проводил мало.

##### При наличии 20К записей

```sql
INSERT INTO __temp__pkeys_in_work(pkey) select * from generate_series(10000,20000);

EXPLAIN  ANALYZE  
INSERT INTO headhunter.message 
	(message_id,vacancy_id,resume_id,article,description,time_create,message_type,unread)
	SELECT message_id+20200,vacancy_id+5,resume_id+5,article,description,time_create,message_type,unread
	FROM new_big.message
	WHERE message_id in (select pkey FROM __temp__pkeys_in_work);
```


```
"Insert on message  (cost=192.94..914.59 rows=10750 width=66) (actual time=260.146..260.146 rows=0 loops=1)"
"  ->  Hash Join  (cost=192.94..914.59 rows=10750 width=66) (actual time=6.744..14.194 rows=10001 loops=1)"
"        Hash Cond: (message_1.message_id = __temp__pkeys_in_work.pkey)"
"        ->  **Seq Scan** on message message_1  (cost=0.00..465.00 rows=21500 width=66) (actual time=0.011..2.357 rows=20200 loops=1)"
"        ->  Hash  (cost=190.44..190.44 rows=200 width=4) (actual time=5.310..5.310 rows=10001 loops=1)"
"              Buckets: 16384 (originally 1024)  Batches: 1 (originally 1)  Memory Usage: 480kB"
"              ->  HashAggregate  (cost=188.44..190.44 rows=200 width=4) (actual time=2.710..4.191 rows=10001 loops=1)"
"                    Group Key: __temp__pkeys_in_work.pkey"
"                    ->  Seq Scan on __temp__pkeys_in_work  (cost=0.00..159.75 rows=11475 width=4) (actual time=0.009..0.619 rows=10001 loops=1)"
"Planning time: 0.214 ms"
"Trigger for constraint message_vacancy_id_fkey: time=1121.265 calls=10001"
"Trigger for constraint message_resume_id_fkey: time=1125.921 calls=10001"
"Execution time: 2509.742 ms"
```

##### При наличии 100К записей

```sql
INSERT INTO __temp__pkeys_in_work(pkey) select * from generate_series(80000,90000);

EXPLAIN  ANALYZE  
INSERT INTO headhunter.message 
	(message_id,vacancy_id,resume_id,article,description,time_create,message_type,unread)
	SELECT message_id+20200,vacancy_id+5,resume_id+5,article,description,time_create,message_type,unread
	FROM new_big.message
	WHERE message_id in (select pkey FROM __temp__pkeys_in_work);
```

```
"Insert on message  (cost=188.73..1792.44 rows=55100 width=66) (actual time=407.265..407.265 rows=0 loops=1)"
"  ->  Nested Loop  (cost=188.73..1792.44 rows=55100 width=66) (actual time=5.285..44.931 rows=10001 loops=1)"
"        ->  HashAggregate  (cost=188.44..190.44 rows=200 width=4) (actual time=5.251..8.187 rows=10001 loops=1)"
"              Group Key: __temp__pkeys_in_work.pkey"
"              ->  Seq Scan on __temp__pkeys_in_work  (cost=0.00..159.75 rows=11475 width=4) (actual time=0.025..1.070 rows=10001 loops=1)"
"        ->  **Index Scan** using message_pkey on message message_1  (cost=0.29..7.07 rows=1 width=66) (actual time=0.002..0.002 rows=1 loops=10001)"
"              Index Cond: (message_id = __temp__pkeys_in_work.pkey)"
"Planning time: 2.940 ms"
"Trigger for constraint message_vacancy_id_fkey: time=1251.720 calls=10001"
"Trigger for constraint message_resume_id_fkey: time=1353.391 calls=10001"
"Execution time: 3014.929 ms"
```

##### При наличии 2М записей

```sql
INSERT INTO __temp__pkeys_in_work(pkey) select * from generate_series(1000000,1010000);

EXPLAIN  ANALYZE  
INSERT INTO headhunter.message 
	(message_id,vacancy_id,resume_id,article,description,time_create,message_type,unread)
	SELECT message_id+20200,vacancy_id+5,resume_id+5,article,description,time_create,message_type,unread
	FROM new_big.message
	WHERE message_id in (select pkey FROM __temp__pkeys_in_work);
```

```
"Insert on message  (cost=188.87..9607.16 rows=1067174 width=66) (actual time=309.858..309.858 rows=0 loops=1)"
"  ->  Nested Loop  (cost=188.87..9607.16 rows=1067174 width=66) (actual time=5.436..52.519 rows=10001 loops=1)"
"        ->  HashAggregate  (cost=188.44..190.44 rows=200 width=4) (actual time=5.282..8.353 rows=10001 loops=1)"
"              Group Key: __temp__pkeys_in_work.pkey"
"              ->  Seq Scan on __temp__pkeys_in_work  (cost=0.00..159.75 rows=11475 width=4) (actual time=0.025..1.125 rows=10001 loops=1)"
"        ->  Index Scan using message_pkey on message message_1  (cost=0.43..8.39 rows=1 width=66) (actual time=0.003..0.003 rows=1 loops=10001)"
"              Index Cond: (message_id = __temp__pkeys_in_work.pkey)"
"Planning time: 0.300 ms"
"Trigger for constraint message_vacancy_id_fkey: time=1124.365 calls=10001"
"Trigger for constraint message_resume_id_fkey: time=1131.608 calls=10001"
"Execution time: 2568.514 ms"
```