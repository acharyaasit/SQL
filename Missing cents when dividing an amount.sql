### Adding cents to the first four lines
with inputs(amount, entries) as (select 100, 42 from dual)
select level as id,
trunc(amount/entries, 2)
+ case when level <= mod(100*amount, entries) then 0.01 else 0 end as split
from inputs
connect by level <= entries
order by id
;


### Adding cents to the random distribution
with inputs(amount, entries) as (select 100, 42 from dual)
select level as id,
trunc(amount/entries, 2)
+ case when row_number() over (order by dbms_random.value) <= mod(100*amount, entries)
then 0.01 else 0 end as split
from inputs
connect by level <= entries
order by id
;

### Adding cents to the uniform distribution

with inputs(amount, entries) as (select 100, 42 from dual)
select level as id,
trunc(amount/entries, 2)
+ case when mod(100*amount, entries) = 0 then 0
when mod(level, trunc(entries/mod(100*amount, entries))) = 0 then 0.01 else 0 end as split
from inputs
connect by level <= entries
order by id
;
