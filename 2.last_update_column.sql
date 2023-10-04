/* Creating functions using PL/pgSQL that will add a 'last_update' column in all tables, 
 * creating a trigger function that will return the current time,
 * attaching a trigger to all the tables.
 * 
 */ 

--adds last_update to all the tables
SET search_path TO ls_museum;
do $$
declare
    selectrow record;
begin
for selectrow in
    select 
      'ALTER TABLE '|| t.mytable || ' ADD COLUMN last_update TIMESTAMP default now()' as script 
   from 
      ( 
        select tablename as mytable from pg_tables where schemaname ='ls_museum' 
      ) t
loop
execute selectrow.script;
end loop;
end;
$$;

--creates triggers for all tables on last_update

CREATE OR REPLACE FUNCTION last_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END $$;

--puts trigger on all tables to update the last_update column before updating any data on any row

do $$
declare
    selectrow record;
begin
for selectrow in
    select 
      'CREATE TRIGGER last_updated BEFORE UPDATE ON '|| t.mytable || ' FOR EACH ROW EXECUTE PROCEDURE last_updated()' as script 
   from 
      ( 
        select tablename as mytable from pg_tables where schemaname  ='ls_museum'
      ) t
loop
execute selectrow.script;
end loop;
end;
$$;

