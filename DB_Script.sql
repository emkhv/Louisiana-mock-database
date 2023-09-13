/* TASK
 * Create physical database design (DDL scripts for tables).
 *  Make sure your database is in 3NF and has meaningful keys and constraints.*/


				/*
				 **Did you know that the naming of the museum has nothing to do with the American state name, 
				 **	it is actually called Louisiana museum because the owner had 3 wives named Louisiana:), 
				 **Check their website (https://louisiana.dk/)
				 **I created triggers, indexes, checks, functions for insert, read-only role for manager, etc. 
				 **See for youself, hope you enjoy!
				 */


SET ROLE TO postgres;
DROP DATABASE IF EXISTS louisiana_museum;
-- Database: louisiana_museum_db
-- Author: Emma Khachatryan
CREATE DATABASE louisiana_museum
    WITH OWNER = postgres
        ENCODING = 'UTF8'
        TABLESPACE = pg_default
        CONNECTION LIMIT = -1;
--\c louisiana_museum
DROP SCHEMA IF EXISTS ls_museum CASCADE; 
CREATE SCHEMA IF NOT EXISTS ls_museum;
SET search_path TO ls_museum;


DROP TABLE IF EXISTS ls_museum.art_work CASCADE;
DROP TABLE IF EXISTS ls_museum.event CASCADE;
DROP TABLE IF EXISTS ls_museum.ticket CASCADE;
DROP TABLE IF EXISTS ls_museum.membership_card CASCADE;
DROP TABLE IF EXISTS ls_museum.membership_type CASCADE;
DROP TABLE IF EXISTS ls_museum.person CASCADE;
DROP TABLE IF EXISTS ls_museum.purchase CASCADE;
DROP TABLE IF EXISTS ls_museum.address CASCADE;
DROP TABLE IF EXISTS ls_museum.city CASCADE;
DROP TABLE IF EXISTS ls_museum.country CASCADE;
DROP TABLE IF EXISTS ls_museum.event_type CASCADE;
DROP TABLE IF EXISTS ls_museum.staff_employee CASCADE;
DROP TABLE IF EXISTS ls_museum.supplier CASCADE;
DROP TABLE IF EXISTS ls_museum.hall CASCADE;
DROP TABLE IF EXISTS ls_museum.payment CASCADE;
DROP TABLE IF EXISTS ls_museum.order_list CASCADE;



CREATE TABLE ls_museum.art_work (
    art_work_id integer GENERATED ALWAYS AS IDENTITY,
    name varchar(50) NOT NULL,
    artist varchar(50) NOT NULL,
    creation_year date NOT NULL,
    event_id integer NOT NULL,
    supplier_id integer NOT NULL,
    PRIMARY KEY (art_work_id)
);

CREATE INDEX ON ls_museum.art_work
    (event_id);
CREATE INDEX ON ls_museum.art_work
    (supplier_id);



CREATE TABLE ls_museum.event (
    event_id integer GENERATED ALWAYS AS IDENTITY,
    event_name varchar(50) NOT NULL,
    event_type_id integer NOT NULL,
    ticket_cost NUMERIC DEFAULT 145,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    event_hall_id integer NOT NULL,
    event_director_id integer NOT NULL,
    description text NOT NULL,
    PRIMARY KEY (event_id)
);

CREATE INDEX ON ls_museum.event
    (event_type_id);
CREATE INDEX ON ls_museum.event
    (event_hall_id);
CREATE INDEX ON ls_museum.event
    (event_director_id);


CREATE TABLE ls_museum.ticket (
    ticket_id integer GENERATED ALWAYS AS IDENTITY,
    event_id integer NOT NULL,
    creation_date timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (ticket_id)
);

CREATE INDEX ON ls_museum.ticket
    (event_id);


CREATE TABLE ls_museum.membership_card (
    membership_card_id integer GENERATED ALWAYS AS IDENTITY,
    member_id integer NOT NULL,
    membership_type_id integer NOT NULL,
    card_creation_date timestamp without time zone NOT NULL DEFAULT now(),
    active bool NOT NULL DEFAULT TRUE, 
    PRIMARY KEY (membership_card_id)
);

CREATE INDEX ON ls_museum.membership_card
    (member_id);
CREATE INDEX ON ls_museum.membership_card
    (membership_type_id);


CREATE TABLE ls_museum.membership_type (
    membership_type_id integer GENERATED ALWAYS AS IDENTITY,
    name varchar(50) NOT NULL,
    description text NOT NULL,
    montly_cost numeric NOT NULL,
    discount_per_age NUMERIC DEFAULT 100,
    PRIMARY KEY (membership_type_id)
);

--creating a domain for email
DROP DOMAIN IF EXISTS ls_museum.email;
CREATE DOMAIN ls_museum.email AS TEXT CHECK (VALUE ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');					

--creating a domain for phone number
DROP DOMAIN IF EXISTS ls_museum.pnumber;
CREATE DOMAIN ls_museum.pnumber AS TEXT CHECK (VALUE not like '%[^0-9]%');												


CREATE TABLE ls_museum.person (
    person_id integer GENERATED ALWAYS AS IDENTITY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    address_id integer NOT NULL,
    phone_number pnumber NOT NULL,
    email email NOT NULL,																								 
    dob date NOT NULL,
    PRIMARY KEY (person_id)
);

CREATE INDEX ON ls_museum.person
    (address_id);


CREATE TABLE ls_museum.purchase (
    purchase_id integer GENERATED ALWAYS AS IDENTITY,
    order_id integer NOT NULL,
    staff_id integer NOT NULL,
    membership_card_id integer,
    total numeric,
    purchase_date timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (purchase_id)
);

CREATE INDEX ON ls_museum.purchase
    (order_id);
CREATE INDEX ON ls_museum.purchase
    (staff_id);
CREATE INDEX ON ls_museum.purchase
    (membership_card_id);


CREATE TABLE ls_museum.address (
    address_id integer GENERATED ALWAYS AS IDENTITY,
    address_line_1 varchar(50) NOT NULL,
    address_line_2 varchar(50) DEFAULT NULL,
    city_id integer NOT NULL,
    postal_code varchar(10) NOT NULL,
    PRIMARY KEY (address_id)
);

CREATE INDEX ON ls_museum.address
    (city_id);


CREATE TABLE ls_museum.city (
    city_id integer GENERATED ALWAYS AS IDENTITY,
    city_name varchar(50) NOT NULL,
    country_id integer NOT NULL,
    PRIMARY KEY (city_id)
);

CREATE INDEX ON ls_museum.city
    (country_id);


CREATE TABLE ls_museum.country (
    country_id integer GENERATED ALWAYS AS IDENTITY,
    country_name varchar(50) NOT NULL,
    PRIMARY KEY (country_id)
);


CREATE TABLE ls_museum.event_type (
    event_type_id integer GENERATED ALWAYS AS IDENTITY,
    type_name TEXT[] NOT NULL CHECK(type_name <@ ARRAY['EXHIBITION', 'CONFERENCE', 'CONCERT', 'LECTURE','WORKSHOP']),
    PRIMARY KEY (event_type_id)
);


CREATE TABLE ls_museum.staff_employee (
    employee_id integer GENERATED ALWAYS AS IDENTITY,
    person_id integer NOT NULL,
    job_title varchar(50) NOT NULL,
    salary numeric NOT NULL,
    work_start_date timestamp without time zone NOT NULL,
    active BOOL NOT NULL DEFAULT TRUE,
    PRIMARY KEY (employee_id)
);

CREATE INDEX ON ls_museum.staff_employee
    (person_id);


CREATE TABLE ls_museum.supplier (
    supplier_id integer GENERATED ALWAYS AS IDENTITY,
    name varchar(50) NOT NULL,
    email email NOT NULL,
    contact_number pnumber NOT NULL,
    description text NOT NULL,
    PRIMARY KEY (supplier_id)
);


CREATE TABLE ls_museum.hall (
    hall_id integer GENERATED ALWAYS AS IDENTITY,
    hall_name varchar(50) NOT NULL,
    description text NOT NULL,
    PRIMARY KEY (hall_id)
);


CREATE TABLE ls_museum.payment (
    payment_id integer GENERATED ALWAYS AS IDENTITY,
    amount numeric NOT NULL,
    status text NOT NULL,
    purchase_id int NOT NULL,
    payment_date timestamp without time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (payment_id)
);


CREATE TABLE ls_museum.order_list (
    order_id integer GENERATED ALWAYS AS IDENTITY,
    item_id integer NOT NULL,
    quantity integer NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE INDEX ON ls_museum.order_list
    (item_id);


/*2.2
 * Use ALTER TABLE to add constraints (except NOT NULL, UNIQUE and keys). 
 * Give meaningful names to your CHECK constraints. Use DEFAULT and STORED AS where appropriate.*/

ALTER TABLE ls_museum.payment ADD CONSTRAINT FK_payment__purchase_id FOREIGN KEY (purchase_id) REFERENCES ls_museum.purchase(purchase_id);

ALTER TABLE ls_museum.art_work ADD CONSTRAINT FK_art_work__event_id FOREIGN KEY (event_id) REFERENCES ls_museum.event(event_id);
ALTER TABLE ls_museum.art_work ADD CONSTRAINT FK_art_work__supplier_id FOREIGN KEY (supplier_id) REFERENCES ls_museum.supplier(supplier_id);

ALTER TABLE ls_museum.event ADD CONSTRAINT FK_event__event_type_id FOREIGN KEY (event_type_id) REFERENCES ls_museum.event_type(event_type_id);
ALTER TABLE ls_museum.event ADD CONSTRAINT FK_event__event_hall_id FOREIGN KEY (event_hall_id) REFERENCES ls_museum.hall(hall_id);
ALTER TABLE ls_museum.event ADD CONSTRAINT FK_event__event_director_id FOREIGN KEY (event_director_id) REFERENCES ls_museum.staff_employee(employee_id);
ALTER TABLE ls_museum.event ADD CONSTRAINT eventdate_chk 
	CHECK (end_date > start_date);

ALTER TABLE ls_museum.ticket ADD CONSTRAINT FK_ticket__event_id FOREIGN KEY (event_id) REFERENCES ls_museum.event(event_id);

ALTER TABLE ls_museum.membership_card ADD CONSTRAINT FK_membership_card__member_id FOREIGN KEY (member_id) REFERENCES ls_museum.person(person_id);
ALTER TABLE ls_museum.membership_card ADD CONSTRAINT FK_membership_card__membership_type_id FOREIGN KEY (membership_type_id) REFERENCES ls_museum.membership_type(membership_type_id);

ALTER TABLE ls_museum.person ADD CONSTRAINT FK_person__address_id FOREIGN KEY (address_id) REFERENCES ls_museum.address(address_id);
ALTER TABLE ls_museum.person ADD CONSTRAINT dob_check 
	CHECK (DOB >= '1920-01-01' AND DOB <= now());

ALTER TABLE ls_museum.purchase ADD CONSTRAINT FK_purchase__order_id FOREIGN KEY (order_id) REFERENCES ls_museum.order_list(order_id);
ALTER TABLE ls_museum.purchase ADD CONSTRAINT FK_purchase__staff_id FOREIGN KEY (staff_id) REFERENCES ls_museum.staff_employee(employee_id);
ALTER TABLE ls_museum.purchase ADD CONSTRAINT FK_purchase__membership_card_id FOREIGN KEY (membership_card_id) REFERENCES ls_museum.membership_card(membership_card_id);

ALTER TABLE ls_museum.address ADD CONSTRAINT FK_address__city_id FOREIGN KEY (city_id) REFERENCES ls_museum.city(city_id);

ALTER TABLE ls_museum.city ADD CONSTRAINT FK_city__country_id FOREIGN KEY (country_id) REFERENCES ls_museum.country(country_id);

ALTER TABLE ls_museum.staff_employee ADD CONSTRAINT FK_staff_employee__person_id FOREIGN KEY (person_id) REFERENCES ls_museum.person(person_id);

ALTER TABLE ls_museum.order_list ADD CONSTRAINT FK_order_list__item_id FOREIGN KEY (item_id) REFERENCES ls_museum.ticket(ticket_id);


--adds last_update to all the tables

do $$
declare
    selectrow record;
begin
for selectrow in
    select 
      'ALTER TABLE '|| t.mytable || ' ADD COLUMN last_update TIMESTAMP default now()' as script 
   from 
      ( 
        select tablename as mytable from  pg_tables where schemaname  ='ls_museum' 
      ) t
loop
execute selectrow.script;
end loop;
end;
$$;

--creates triggers for all tables on last_update

CREATE OR REPLACE FUNCTION  last_updated() RETURNS trigger
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
        select tablename as mytable from  pg_tables where schemaname  ='ls_museum'
      ) t
loop
execute selectrow.script;
end loop;
end;
$$;



	
/*Add fictional data to your database (5+ rows per table, 50+ rows total across all tables). 
 * Save your data as DML scripts. Make sure your surrogate keys' values are not included in DML scripts 
 * (they should be created runtime by the database, as well as DEFAULT values where appropriate). 
 * DML scripts must successfully pass all previously created constraints.*/	
	
INSERT INTO ls_museum.country(country_name) VALUES 								
('Denmark'),																	 
('Germany'),
('Norway'),
('Sweden'),
('Germany');

INSERT INTO ls_museum.city (city_name, country_id)
SELECT 'Humlebaek', country_id 
FROM ls_museum.country cnt
WHERE lower(cnt.country_name) = lower('Denmark')
UNION 
SELECT 'Espergaerde', country_id 
FROM ls_museum.country cnt
WHERE lower(cnt.country_name) = lower('Denmark')
UNION
SELECT 'Niva', country_id 
FROM ls_museum.country cnt
WHERE lower(cnt.country_name) = lower('Denmark')
UNION 
SELECT 'Helsingor', country_id 
FROM ls_museum.country cnt
WHERE lower(cnt.country_name) = lower('Denmark')
UNION 
SELECT 'Copenhagen', country_id 
FROM ls_museum.country cnt
WHERE lower(cnt.country_name) = lower('Denmark')
UNION 
SELECT 'Helsingborg', country_id 
FROM ls_museum.country cnt
WHERE lower(cnt.country_name) = lower('Sweden')
UNION 
SELECT 'Oslo', country_id 
FROM ls_museum.country cnt
WHERE lower(cnt.country_name) = lower('Norway');



/*
 * The insert_into_addres function takes input of address line 1, address line 2, name of the city, country name and postal code, 
 * and inserts it into the address entity, returning created address id.
 * You can put any infromation, it will insert it if it doesn't already exist, and it will avoid duplications.
 * So you can add person's full address information in one line, doesn't matter where they are from. 
 */

DROP FUNCTION IF EXISTS insert_into_address(text,text,text,text,text);

CREATE OR REPLACE FUNCTION insert_into_address(	address_line_1 	TEXT, 
												address_line_2 	TEXT, 
												city_name 		TEXT, 
												country_name 	TEXT, 
												postal_code 	TEXT)
RETURNS integer

AS $$

	DECLARE i_address_id integer;
			i_country_id integer;
			i_city_id 	integer;
		
	BEGIN
		
	INSERT INTO ls_museum.country (country_name) 															--inserting country
	SELECT insert_into_address.country_name
		WHERE NOT EXISTS (																					--checking if it already exists
	        SELECT c.country_name 
	        FROM ls_museum.country c 
	        WHERE lower(insert_into_address.country_name) = lower(c.country_name)
	    ); 																									
   
	SELECT c.country_id INTO i_country_id																	--selecting necessary country id into i_country_id veriable 
	FROM country c
	WHERE lower(c.country_name) = lower(insert_into_address.country_name);									



    
    INSERT INTO ls_museum.city(city_name, country_id) 														--inserting city				
	SELECT insert_into_address.city_name, i_country_id 
	WHERE 
		NOT EXISTS (																						--checking if it already exists
	        SELECT ct.city_name 
	        FROM ls_museum.city ct 
	        WHERE lower(insert_into_address.city_name) = lower(ct.city_name)
	    );																									
	
    SELECT ct.city_id INTO i_city_id																		--selecting necessary city id into i_city_id veriable 
	FROM city ct
	WHERE lower(ct.city_name) = lower(insert_into_address.city_name);



    
    INSERT INTO ls_museum.address( 	address_line_1, 														--inserting all into address table
    								address_line_2, 
    								city_id, 
    								postal_code)
	SELECT 	address_line_1, 
			address_line_2, 
			i_city_id, 
			postal_code 
	FROM ls_museum.city c
	WHERE lower(insert_into_address.city_name)= lower(c.city_name)
	RETURNING ls_museum.address.address_id INTO i_address_id ;												--returning address_id into i_adress_id

RETURN i_address_id;

END;

$$  LANGUAGE plpgsql;

--here I insert 5 rows into 4 tables at once

INSERT INTO person (first_name, last_name, address_id, phone_number, email, dob)  
SELECT 'Renee', 
		'Lindholm', 
		(SELECT * FROM insert_into_address('Havqnevej 3c', 'Region Dagelokke', 'Humlebaek', 'Denmark', '3050') AS address_id),
		'842982555',
		'Renee.Lindholm@gmail.com',
		'2002-08-20' :: date 
UNION 
SELECT 'Hakan', 
		'Isaksson', 
		(SELECT * FROM insert_into_address('Algade 58', 'Region Syddanmark', 'Gudme', 'Denmark', '5884') AS address_id),
		'081066888',
		'Hakan.Isaksson@yahoo.com',
		'1975-06-29':: date 
UNION 
SELECT 'Theodor',
		'Lundqvist',
		(SELECT * FROM insert_into_address('Brogade 60', 'Region Syddanmark', 'Esbjerg', 'Denmark', '6701') AS address_id),
		'045662177',
		'Theodor.Lundqvist@gmail.com',
		'1988-08-22':: date 
UNION
SELECT 'Karolina', 
		'Kaminska',
		(SELECT * FROM insert_into_address('11, Fossilveien', 'Skauen', 'Oslo', 'Norway', '0198') AS address_id),
		'226542162',
		'Karolina.Kaminska@gmail.com',
		'1997-02-16':: date 
UNION
SELECT 'Emma',
		'Khachatryan',
		(SELECT * FROM insert_into_address('Amiryan 15', 'Kentron', 'Yerevan', 'Armenia', '002') AS address_id),
		'043004944',
		'v.em.khachatryan@gmail.com',
		'1998-10-15':: date 
UNION
SELECT 'Poul Erik',
		'Tojner',
		(SELECT * FROM insert_into_address('Hovbanken 68', 'Region Sjaelland', 'Kobenhavn', 'Denmark', '1553') AS address_id),
		'51989749',
		'rbf@louisiana.dk',
		'1959-02-25' :: date
UNION 
SELECT 'Risti Bjerring',
		'Fremming',
		(SELECT * FROM insert_into_address('Hyrdevej 31', 'Capital Region', 'Copenhagen', 'Denmark', '1553') AS address_id),
		'51989749',
		'rbf@louisiana.dk',
		'1959-02-25' :: date
UNION 
SELECT 'Eva',
		'Lund',
		(SELECT * FROM insert_into_address('Hyrdevej 31', 'Capital Region', 'Copenhagen', 'Denmark', '1553') AS address_id),
		'51993099',
		'el@louisiana.dk',
		'1984-02-25' :: date;

	
INSERT INTO membership_type(name, description,montly_cost) VALUES
('MEMBERSHIP 1+1', 'MEMBERSHIP 1+1, 1 PERSON + 1 GUEST DKK 595, senior (65+) DKK 495', '595'),
('MEMBERSHIP 1', 'MEMBERSHIP 1, 1 PERSON DKK 490, senior (65+) DKK 390', '490');

INSERT INTO membership_type(name, description,montly_cost,discount_per_age) VALUES
('MEMBERSHIP U29','1 PERSON 18-29 YEARS DKK 165,(does not include Louisiana Revy or Louisiana Magasin)','165','0');


--One person can have one membership card,but different types, so we check if they are registered before adding


INSERT INTO membership_card (member_id,membership_type_id) 
	SELECT p.person_id, membership_type_id 
	FROM person p, membership_type mt
	WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Emma Khachatryan')
	AND upper(mt."name") = upper('MEMBERSHIP 1+1') 
	AND NOT EXISTS (																						
		        SELECT member_id, membership_type_id 
		        FROM membership_card 
		        WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Emma Khachatryan')
		        AND upper(mt."name") = upper('MEMBERSHIP 1+1') 
		    )
UNION 
	SELECT p.person_id, membership_type_id 
	FROM person p, membership_type mt
	WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Karolina Kaminska')
	AND upper(mt."name") = upper('MEMBERSHIP 1') 
	AND NOT EXISTS (																						
		        SELECT member_id, membership_type_id 
		        FROM membership_card 
		        WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Karolina Kaminska')
				AND upper(mt."name") = upper('MEMBERSHIP 1') 
		    )
UNION 
	SELECT p.person_id, membership_type_id 
	FROM person p, membership_type mt
	WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Renee Lindholm')
	AND upper(mt."name") = upper('MEMBERSHIP U29')
	AND NOT EXISTS (																						
		        SELECT member_id, membership_type_id 
		        FROM membership_card 
		        WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Renee Lindholm')
				AND upper(mt."name") = upper('MEMBERSHIP U29') 
		    )
UNION 
	SELECT p.person_id, membership_type_id 
	FROM person p, membership_type mt
	WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Theodor Lundqvist')
	AND upper(mt."name") = upper('MEMBERSHIP 1+1')
	AND NOT EXISTS (																						
		        SELECT member_id, membership_type_id 
		        FROM membership_card 
		        WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Theodor Lundqvist')
				AND upper(mt."name") = upper('MEMBERSHIP 1+1') 
		    )
UNION 
	SELECT p.person_id, membership_type_id 
	FROM person p, membership_type mt
	WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Hakan Isaksson')
	AND upper(mt."name") = upper('MEMBERSHIP 1')
	AND NOT EXISTS (																						
		        SELECT member_id, membership_type_id 
		        FROM membership_card 
		        WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Hakan Isaksson')
				AND upper(mt."name") = upper('MEMBERSHIP 1') 
		    );

		   
		   
INSERT INTO staff_employee (person_id, job_title, salary, work_start_date)
SELECT p.person_id, 'Director', 100000, '2000-01-01' :: date 
		FROM person p 
		WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Poul Erik Tojner')
UNION 
SELECT p.person_id, 'Museum Secretary', 80000, '2008-01-01' :: date 
		FROM person p 
		WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Risti Bjerring Fremming')
UNION
SELECT p.person_id, 'DB Administrator', 60000, '2023-02-18' :: date
		FROM person p 
		WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Emma Khachatryan')
UNION 
SELECT p.person_id, 'Curator', 60000, '2020-02-08' :: date
		FROM person p 
		WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Karolina Kaminska')
UNION 
SELECT p.person_id, 'Registrar', 50000, '2020-10-05' :: date
		FROM person p 
		WHERE concat(upper(p.first_name)|| ' ' || upper(p.last_name)) = upper('Eva Lund');	
		
	
	
	
INSERT INTO event_type (type_name) 
SELECT '{"EXHIBITION"}'::TEXT[]--optional
UNION 
SELECT '{"CONFERENCE"}'
UNION 
SELECT '{"CONCERT"}'
UNION 
SELECT '{"LECTURE"}'
UNION 
SELECT '{"WORKSHOP"}';																						--sometimes INSERT is fun




INSERT INTO hall(hall_name,description) VALUES
('West Wing','1976, West Wing, The Concert Hall came across in 1976 making the West Wing a place where Louisiana has invited the public to debates, lectures and acoustic concerts .
'),
('South Wing', '1982, South Wing, Includes an exhibition room with a higher celling and more cpace than in previously existing bulidings.'
),
('East Wing', '1992, East Wing, The underground east wing is also refered to as the Graphics Wing because it gives the opportunity to exhibit drawings that must not be exposed to daylight.'
),
('North Wing', '1958, North wing, consists of several glass corridors and the three pavilions that connected the old villa to the cafeteria with the view of Sweden). Includes the Giacometti Hall and the Jorn Hall.'
);

--this insert looks a bit messy, but in actuality it's pretty simple and self-explainatory
--I added all names and timestamps manually, the id's were selected from other tables

INSERT INTO event (event_name, event_type_id, ticket_cost, start_date, end_date, event_hall_id, event_director_id, description)
		SELECT 'DIANE ARBUS PHOTOGRAPHS, 1956-1971', 
				event_type_id, 
				145, 
				'2022-03-24':: timestamp , 
				'2022-07-31' :: timestamp , 
				h.hall_id, st.employee_id, 
				'‘Diane Arbus: Photographs, 1956–1971’  was organized in collaboration with AGO – Art Gallery of Ontario. Louisiana presented the first large-scale retrospective in Scandinavia of legendary American photographer Diane Arbus.'
		FROM event_type et, 
			 hall h, 
			 staff_employee st, 
			 person p 
		WHERE  et.type_name = '{"EXHIBITION"}' 
			AND p.person_id = st.person_id  
			AND h.hall_name = 'South Wing' 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Poul Erik Tojner')
UNION 
		SELECT 'ALEX DA CORTE MR. REMEMBER', 
				event_type_id, 
				145, 
				'2022-07-14':: timestamp , 
				'2023-01-08' :: timestamp , 
				h.hall_id, 
				st.employee_id, 
				'An overwhelming, visual experience, this exhibition is the largest to date in Europe with international art-star Alex Da Corte. He works with painting, sculpture, installation and video, often appearing in disguise in his films, taking on iconic figures such as Popeye or the Statue of Liberty.'
		FROM event_type et, 
			 hall h, 
			 staff_employee st, 
			 person p 
		WHERE  et.type_name = '{"EXHIBITION"}' 
			AND p.person_id = st.person_id  
			AND h.hall_name = 'South Wing' 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Poul Erik Tojner')
UNION 
		SELECT 'THE COLD GAZE - GERMANY IN THE 1920S', 
				event_type_id, 
				145, 
				'2022-10-14':: timestamp , 
				'2023-02-19' :: timestamp , 
				h.hall_id, 
				st.employee_id, 
				'The exhibition is organized in collaboration with Centre Pompidou, Paris and is supported by C. L. David Foundation and Collection.'
		FROM event_type et, 
			 hall h, 
			 staff_employee st, 
			 person p  
		WHERE  et.type_name = '{"EXHIBITION"}' 
			AND p.person_id = st.person_id  
			AND h.hall_name = 'South Wing' 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Poul Erik Tojner')
UNION 
		SELECT 'MIKE STERN, MINO CINELU & FRANCOIS MOUTIN', event_type_id, 375 , '2022-04-29 15:00:00':: timestamp , '2022-04-29 17:00:00' :: timestamp , h.hall_id, st.employee_id, 'Three of the world"s greatest artists – Mike Stern, Mino Cinelu and François Moutin – on their respective instruments unite for an exclusive one time-only concert in the Concert Hall.' 
		FROM event_type et, 
			 hall h, 
			 staff_employee st, 
			 person p 
		WHERE  et.type_name = '{"CONCERT"}' 
			AND p.person_id = st.person_id  
			AND h.hall_name = 'West Wing' 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Karolina Kaminska')
UNION 
		SELECT 'RICHARD PRINCE', event_type_id, 145, '2022-11-17':: timestamp , '2023-04-10' :: timestamp , h.hall_id, st.employee_id, 'Shown in the series Louisiana on Paper, supported by the C. L. David Foundation and Collection.'
		FROM event_type et, 
			 hall h, 
			 staff_employee st, 
			 person p 
		WHERE  et.type_name = '{"EXHIBITION"}' 
			AND p.person_id = st.person_id  
			AND h.hall_name = 'East Wing' 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Karolina Kaminska')
UNION 
		SELECT 'NAN GOLDIN: MEMORY LOST', event_type_id, 145, '2023-05-11':: timestamp , '2023-10-22' :: timestamp , h.hall_id, st.employee_id, 'Experience an important new acquisition in the South Wing: The magnum opus "Memory Lost" by photographer and activist Nan Goldin – one of the most revered and significant artists of our time.'
		FROM event_type et, 
			 hall h, 
			 staff_employee st, 
			 person p 
		WHERE  et.type_name = '{"EXHIBITION"}' 
			AND p.person_id = st.person_id  
			AND h.hall_name = 'South Wing' 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Karolina Kaminska')

			;


INSERT INTO supplier("name", email, contact_number, description) VALUES 
('C.L. David Foundation.', 'c.l.david.foundation@gmail.com', 201823192, 'somesuplierdescription'),
('Moderna Museet, Stockholm', 'press@modernamuseet.se', 46852023500, 'Moderna Museet, Stockholm, Sweden, is a state museum for modern and contemporary art located on the island of Skeppsholmen in central Stockholm, opened in 1958.'),
('somesuplier3', 'somesuplier3@gmail.com', 72364235673, 'somesuplierdescription'),
('somesuplier4', 'somesuplier4@gmail.com', 911911911, 'somesuplierdescription'),
('somesuplier5', 'somesuplier5@gmail.com', 8394298364, 'somesuplierdescription');





DROP FUNCTION IF EXISTS insert_into_art_work(  "name" 	TEXT, 
												  artist 	TEXT, 
												  creation_year TEXT, 
												  event_name 	TEXT, 
												  supplier_name	TEXT);

CREATE OR REPLACE FUNCTION insert_into_art_work(  "name" 	TEXT, 
												  artist 	TEXT, 
												  creation_year TEXT, 
												  event_name 	TEXT, 
												  supplier_name	TEXT)
RETURNS integer

AS $$

	DECLARE i_event_id integer;
			i_supplier_id integer;
			i_art_work_id integer;
		
	BEGIN
		
	SELECT e.event_id INTO i_event_id																	--selecting necessary event id into i_event_id veriable 
	FROM ls_museum.event e
	WHERE lower(e.event_name) = lower(insert_into_art_work.event_name :: text);									



    
    SELECT s.supplier_id INTO i_supplier_id																		--selecting necessary supplier id into i_supplier_id veriable 
	FROM  ls_museum.supplier s
	WHERE lower(s.name) = lower(insert_into_art_work.supplier_name:: text);



    
    INSERT INTO ls_museum.art_work("name", 
    								artist, 
    								creation_year, 
    								event_id, 
    								supplier_id)
	SELECT 	"name", 
			artist, 
			to_date(creation_year, 'YYYY'),
			i_event_id,
			i_supplier_id
	RETURNING ls_museum.art_work.art_work_id  INTO i_art_work_id ;												--returning art_work_id into i_art_work_id TO CHECK IF the INSERT was successful 

RETURN i_art_work_id;

END;

$$  LANGUAGE plpgsql;



SELECT * FROM insert_into_art_work('Memory Lost', 'Nan Goldin', '2020', 'NAN GOLDIN: MEMORY LOST', 'Moderna Museet, Stockholm' );


INSERT INTO art_work(artist, "name", creation_year, event_id, supplier_id)
		SELECT 'August Sander', 'Sekretær ved Vesttysk Radio i Köln', '1931-01-01':: date, e.event_id , s.supplier_id
		FROM ls_museum."event" e , ls_museum.supplier s 
		WHERE upper(e.event_name) = upper('THE COLD GAZE - GERMANY IN THE 1920S') 
		AND upper(s."name")= upper('C.L. David Foundation.')  
		AND NOT EXISTS (																						
		        SELECT *
		FROM ls_museum."event" e , ls_museum.supplier s, art_work aw
		WHERE upper(e.event_name) = upper('THE COLD GAZE - GERMANY IN THE 1920S') 
		AND upper(s."name")= upper('C.L. David Foundation.')
		AND aw.artist = ('August Sander') AND aw."name" = ('Sekretær ved Vesttysk Radio i Köln') AND aw.creation_year = ('1931-01-01':: date)
		    )
UNION 
		SELECT 'Richard Prince', 'Untitled (Nurse)', '2017-01-01':: date, e.event_id , s.supplier_id
		FROM ls_museum."event" e , ls_museum.supplier s 
		WHERE upper(e.event_name) = upper('RICHARD PRINCE') 
		AND upper(s."name")= upper('C.L. David Foundation.') 
UNION 
		SELECT 'artist_1', 'name_1', '2001-01-01':: date, e.event_id , s.supplier_id
		FROM ls_museum."event" e , ls_museum.supplier s 
		WHERE upper(e.event_name) = upper('RICHARD PRINCE') 
		AND upper(s."name")= upper('C.L. David Foundation.')
UNION 
		SELECT 'artist_1', 'name_1', '2001-01-01':: date, e.event_id , s.supplier_id
		FROM ls_museum."event" e , ls_museum.supplier s 
		WHERE upper(e.event_name) = upper('RICHARD PRINCE') 
		AND upper(s."name")= upper('C.L. David Foundation.');
	



INSERT INTO ticket (event_id, creation_date)
     	SELECT e.event_id, now()
     	FROM "event" e 
     	WHERE upper(e.event_name) = upper('THE COLD GAZE - GERMANY IN THE 1920S')
UNION 
     	SELECT e.event_id, now()
     	FROM "event" e 
     	WHERE upper(e.event_name) = upper('RICHARD PRINCE')
     
UNION 
     	SELECT e.event_id, now()
     	FROM "event" e 
     	WHERE upper(e.event_name) = upper('MIKE STERN, MINO CINELU & FRANCOIS MOUTIN')
     
UNION 
     	SELECT e.event_id, now()
     	FROM "event" e 
     	WHERE upper(e.event_name) = upper('ALEX DA CORTE MR. REMEMBER')
     
UNION 
     	SELECT e.event_id, now()
     	FROM "event" e 
     	WHERE upper(e.event_name) = upper('DIANE ARBUS PHOTOGRAPHS, 1956-1971');
     
     
     
INSERT INTO order_list(item_id, quantity)
	SELECT t.ticket_id, 1
	FROM ticket t, "event" e 
	WHERE t.event_id =e.event_id  AND upper(e.event_name) = upper('DIANE ARBUS PHOTOGRAPHS, 1956-1971')
UNION 
	SELECT t.ticket_id, 1
	FROM ticket t, "event" e 
	WHERE t.event_id =e.event_id  AND upper(e.event_name) = upper('ALEX DA CORTE MR. REMEMBER')
UNION 
	SELECT t.ticket_id, 1
	FROM ticket t, "event" e 
	WHERE t.event_id =e.event_id  AND upper(e.event_name) = upper('MIKE STERN, MINO CINELU & FRANCOIS MOUTIN')
UNION 
	SELECT t.ticket_id, 1
	FROM ticket t, "event" e 
	WHERE t.event_id =e.event_id  AND upper(e.event_name) = upper('THE COLD GAZE - GERMANY IN THE 1920S')
UNION 
	SELECT t.ticket_id, 1
	FROM ticket t, "event" e 
	WHERE t.event_id =e.event_id  AND upper(e.event_name) = upper('RICHARD PRINCE');

/*The aim of this function and trigger is the following
 * 	-see if the membership_card_id is not empty
 * 	-if empty, then pass
 * 	-if not empty, then total must be 0
 *  -in the previous function everything works seamlessly, but this one is not responding
 * */
CREATE OR REPLACE FUNCTION  count_total()
RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM  membership_card_id FROM purchase;
	
	IF NOT FOUND THEN    RAISE NOTICE ' id not found';
 	ELSE NEW.total = 0.00; 
    RETURN NEW;
     END IF;
    
  
END $$;

CREATE OR REPLACE TRIGGER puchase_insert
    AFTER INSERT ON purchase
    FOR EACH STATEMENT
    EXECUTE PROCEDURE count_total();
   
--As there are many input parameters in this table, it is a bit messy, but the filtering parameters are pretty clear
--CTE memid is to find the membership_card_id of needed customer, in this example me
--The name filter is for the registrar, we have only one, Eva, so chose is obvious
--ticket price is taken from the event ticket cost column
   
WITH memid AS (SELECT membership_card_id AS id											
							FROM person p , membership_card mc 
							WHERE mc.member_id = p.person_id 
							AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Emma Khachatryan'))	
INSERT INTO purchase (order_id, staff_id, membership_card_id, total,purchase_date ) 
	SELECT 	order_id, 
		st.employee_id , 
		memid.id,
		e.ticket_cost,
		now()
	FROM 	order_list ol, 
			ticket t, 
			"event" e, 
			staff_employee st, 
			person p 
			,memid
	WHERE ol.item_id = t.ticket_id 
		AND t.event_id = e.event_id 
		AND p.person_id = st.person_id 
		AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Eva Lund')
		AND upper(e.event_name) = upper('DIANE ARBUS PHOTOGRAPHS, 1956-1971')
UNION 
	SELECT 	order_id, 
		st.employee_id , --Eva
		memid.id,
		e.ticket_cost,
		now()
	FROM 	order_list ol, 
			ticket t, 
			"event" e, 
			staff_employee st, 
			person p 
			,memid
	WHERE ol.item_id = t.ticket_id 
		AND t.event_id = e.event_id 
		AND p.person_id = st.person_id 
		AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Eva Lund')
		AND upper(e.event_name) = upper('THE COLD GAZE - GERMANY IN THE 1920S');

	
INSERT INTO purchase (order_id, staff_id, total,purchase_date ) 
	SELECT 	order_id, 
			st.employee_id ,
			e.ticket_cost,
			now()
		FROM 	order_list ol, 
				ticket t, 
				"event" e, 
				staff_employee st, 
				person p 
		WHERE ol.item_id = t.ticket_id 
			AND t.event_id = e.event_id 
			AND p.person_id = st.person_id 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Eva Lund')
			AND upper(e.event_name) = upper('MIKE STERN, MINO CINELU & FRANCOIS MOUTIN')
UNION 
		SELECT 	order_id, 
			st.employee_id ,
			e.ticket_cost,
			now()
		FROM 	order_list ol, 
				ticket t, 
				"event" e, 
				staff_employee st, 
				person p 
		WHERE ol.item_id = t.ticket_id 
			AND t.event_id = e.event_id 
			AND p.person_id = st.person_id 
			AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Eva Lund')
			AND upper(e.event_name) = upper('RICHARD PRINCE');
		
		

INSERT INTO payment (amount,status,purchase_id,payment_date)
VALUES (145, 'Success', 1,now()),
(375, 'Success', 2,now()),
(145, 'Success', 3,now());


REVOKE CREATE ON SCHEMA ls_museum FROM PUBLIC;						
REVOKE ALL ON DATABASE louisiana_museum FROM PUBLIC;	


DROP ROLE IF EXISTS manager_ls;
CREATE ROLE manager_ls INHERIT ;									
GRANT CONNECT 													 
		ON DATABASE louisiana_museum 
		TO manager_ls;
GRANT USAGE 
		ON SCHEMA ls_museum 
		TO manager_ls;
GRANT SELECT 
		ON ALL TABLES 
		IN SCHEMA ls_museum 
		TO manager_ls;	
ALTER DEFAULT PRIVILEGES 										
		IN SCHEMA ls_museum 
		GRANT SELECT 
		ON TABLES 
		TO manager_ls;

--CREATE ROLE Risti_Bjerring noinherit login PASSWORD 's3cr3t';
--GRANT manager_ls TO Risti_Bjerring;
set role manager_ls;

--Joining all together

SELECT e.event_name , e.description, h.hall_name, et.type_name , e.ticket_cost 
		,concat(p3.first_name || ' ' || p3.last_name) AS "Event director"
		,concat(a.address_line_1 ||' '|| a.address_line_2  ||' '|| c.city_name  ||' '|| c2.country_name ) AS director_address
		, e.start_date , e.end_date
		, aw."name" AS art_work, aw.artist AS artist_name, s."name"  AS supplier
		, t.ticket_id AS ticket_name, e.ticket_cost,  p.amount AS payment_amount, p.status AS payment_status
		,concat(p4.first_name || ' ' || p4.last_name) AS ticket_owner, mt.name AS membership_type
		,concat(a4.address_line_1 ||' '|| a4.address_line_2  ||' '|| c4.city_name  ||' '|| c41.country_name ) AS address
FROM payment p FULL OUTER JOIN 	purchase 		p2	ON p.purchase_id = p2.purchase_id 
				LEFT JOIN  		membership_card mc 	ON p2.membership_card_id = mc.membership_card_id 
				LEFT JOIN 		membership_type mt 	ON mc.membership_type_id = mt.membership_type_id
				LEFT JOIN 		person			p4	ON mc.member_id = p4.person_id 
				LEFT JOIN 		address			a4	ON p4.address_id = a4.address_id 
				LEFT JOIN 		city			c4	ON a4.city_id = c4.city_id 
				LEFT JOIN 		country			c41 ON c4.country_id = c41.country_id 
				FULL OUTER JOIN order_list		ol	ON p2.order_id = ol.order_id 
				FULL OUTER JOIN ticket			t	ON ol.item_id = t.ticket_id 
				FULL OUTER JOIN event 			e	ON t.event_id = e.event_id 
				LEFT JOIN 		staff_employee 	se 	ON e.event_director_id = se.employee_id 
				LEFT JOIN 		person 			p3	ON se.person_id = p3.person_id 
				LEFT JOIN 		address 		a	ON p3.address_id = a.address_id 
				LEFT JOIN 		city			c	ON a.city_id = c.city_id 
				LEFT JOIN 		country 		c2	ON c.country_id = c2.country_id 
				LEFT JOIN		hall			h	ON e.event_hall_id = h.hall_id 
				LEFT JOIN 		event_type		et	ON e.event_type_id = et.event_type_id 
				FULL OUTER JOIN art_work		aw	ON aw.event_id = e.event_id 
				LEFT JOIN 		supplier		s	ON aw.supplier_id = s.supplier_id 
WHERE p.last_update  >= date_trunc('month', current_date - interval '1' month)
  and p.last_update < now();
				
				
				
				


		


