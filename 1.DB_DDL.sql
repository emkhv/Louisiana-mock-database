				/*
				 **Did you know that the naming of the museum has nothing to do with the American state name, 
				 **	it is actually called Louisiana museum because the owner had 3 wives named Louisiana:), 
				 **Check their website (https://louisiana.dk/)
				 **I created triggers, indexes, checks, functions for insert, read-only role for manager, etc. 
				 **Hope you enjoy!
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


DROP TABLE IF EXISTS ls_museum.artwork CASCADE;
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



CREATE TABLE ls_museum.artwork (
    artwork_id integer GENERATED ALWAYS AS IDENTITY,
    name varchar(50) NOT NULL,
    artist varchar(50) NOT NULL,
    creation_year date NOT NULL,
    event_id integer NOT NULL,
    supplier_id integer NOT NULL,
    PRIMARY KEY (artwork_id)
);

CREATE INDEX ON ls_museum.artwork
    (event_id);
CREATE INDEX ON ls_museum.artwork
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


/*1.2
 * Use ALTER TABLE to add constraints (except NOT NULL, UNIQUE and keys). 
 * */

ALTER TABLE ls_museum.payment ADD CONSTRAINT FK_payment__purchase_id FOREIGN KEY (purchase_id) REFERENCES ls_museum.purchase(purchase_id);

ALTER TABLE ls_museum.artwork ADD CONSTRAINT FK_artwork__event_id FOREIGN KEY (event_id) REFERENCES ls_museum.event(event_id);
ALTER TABLE ls_museum.artwork ADD CONSTRAINT FK_artwork__supplier_id FOREIGN KEY (supplier_id) REFERENCES ls_museum.supplier(supplier_id);

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

