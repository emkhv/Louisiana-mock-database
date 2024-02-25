-- Inserting data into all tables, using some functions along the way

SET search_path TO ls_museum;
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

--here I insert 5 rows into 4 tables at once

INSERT INTO person (first_name, last_name, address_id, phone_number, email, dob)  
SELECT 'Renee', 
        'Lindholm', 
        (SELECT * FROM insert_address('Havqnevej 3c', 'Region Dagelokke', 'Humlebaek', 'Denmark', '3050') AS address_id),
        '842982555',
        'Renee.Lindholm@gmail.com',
        '2002-08-20' :: date 
UNION 
SELECT 'Hakan', 
        'Isaksson', 
        (SELECT * FROM insert_address('Algade 58', 'Region Syddanmark', 'Gudme', 'Denmark', '5884') AS address_id),
        '081066888',
        'Hakan.Isaksson@yahoo.com',
        '1975-06-29':: date 
UNION 
SELECT 'Theodor',
        'Lundqvist',
        (SELECT * FROM insert_address('Brogade 60', 'Region Syddanmark', 'Esbjerg', 'Denmark', '6701') AS address_id),
        '045662177',
        'Theodor.Lundqvist@gmail.com',
        '1988-08-22':: date 
UNION
SELECT 'Karolina', 
        'Kaminska',
        (SELECT * FROM insert_address('11, Fossilveien', 'Skauen', 'Oslo', 'Norway', '0198') AS address_id),
        '226542162',
        'Karolina.Kaminska@gmail.com',
        '1997-02-16':: date 
UNION
SELECT 'Emma',
        'Khachatryan',
        (SELECT * FROM insert_address('Margaryan st, 2nd lane, 14 b., 26 ap.', 'Ajapnyak', 'Yerevan', 'Armenia', '078') AS address_id),
        '043004944',
        'v.em.khachatryan@gmail.com',
        '1998-10-15':: date 
UNION
SELECT 'Poul Erik',
        'Tojner',
        (SELECT * FROM insert_address('Hovbanken 68', 'Region Sjaelland', 'Kobenhavn', 'Denmark', '1553') AS address_id),
        '51989749',
        'rbf@louisiana.dk',
        '1959-02-25' :: date
UNION 
SELECT 'Risti Bjerring',
        'Fremming',
        (SELECT * FROM insert_address('Hyrdevej 31', 'Capital Region', 'Copenhagen', 'Denmark', '1553') AS address_id),
        '51989749',
        'rbf@louisiana.dk',
        '1959-02-25' :: date
UNION 
SELECT 'Eva',
        'Lund',
        (SELECT * FROM insert_address('Hyrdevej 31', 'Capital Region', 'Copenhagen', 'Denmark', '1553') AS address_id),
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
SELECT '{"WORKSHOP"}';                                                                                      --sometimes INSERT is fun




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



SELECT * FROM insert_artwork('Memory Lost', 'Nan Goldin', '2020', 'NAN GOLDIN: MEMORY LOST', 'Moderna Museet, Stockholm' );


INSERT INTO artwork(artist, "name", creation_year, event_id, supplier_id)
        SELECT 'August Sander', 'Sekretær ved Vesttysk Radio i Köln', '1931-01-01':: date, e.event_id , s.supplier_id
        FROM ls_museum."event" e , ls_museum.supplier s 
        WHERE upper(e.event_name) = upper('THE COLD GAZE - GERMANY IN THE 1920S') 
        AND upper(s."name")= upper('C.L. David Foundation.')  
        AND NOT EXISTS (                                                                                        
                SELECT *
        FROM ls_museum."event" e , ls_museum.supplier s, artwork aw
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


--As there are many input parameters in this table, it is a bit messy, but the filtering parameters are pretty clear
--CTE memid is to find the membership_card_id of needed customer, in this example me
--The name filter is for the registrar, we have only one, Eva, so chose is obvious
--ticket price is taken from the event ticket cost column
   
WITH memid AS (SELECT membership_card_id AS id                                          
                            FROM person p , membership_card mc 
                            WHERE mc.member_id = p.person_id 
                            AND concat(upper(p.first_name) || ' ' || upper(p.last_name)) = upper('Emma Khachatryan'))   
INSERT INTO purchase (order_id, staff_id, membership_card_id, total,purchase_date ) 
    SELECT  order_id, 
        st.employee_id , 
        memid.id,
        e.ticket_cost,
        now()
    FROM    order_list ol, 
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
    SELECT  order_id, 
        st.employee_id , --Eva
        memid.id,
        e.ticket_cost,
        now()
    FROM    order_list ol, 
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
    SELECT  order_id, 
            st.employee_id ,
            e.ticket_cost,
            now()
        FROM    order_list ol, 
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
        SELECT  order_id, 
            st.employee_id ,
            e.ticket_cost,
            now()
        FROM    order_list ol, 
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

-- Insert statements for the 'purchase' table
INSERT INTO ls_museum.purchase (order_id, staff_id, total, purchase_date) 
SELECT p.order_id, p.staff_id, p.total, p.purchase_date
FROM (
    VALUES 
        (1, 1, 145, '2024-02-26 10:00:00'::timestamp),
        (2, 2, 375, '2024-02-25 14:30:00'::timestamp),
        (3, 3, 145, '2024-02-24 11:45:00'::timestamp),
        (4, 4, 200, '2024-02-24 15:20:00'::timestamp),
        (5, 5, 320, '2024-02-25 09:10:00'::timestamp)
) AS p(order_id, staff_id, total, purchase_date)
LEFT JOIN ls_museum.purchase pu ON p.order_id = pu.order_id
WHERE pu.order_id IS NULL;

-- Insert statements for the 'payment' table
INSERT INTO ls_museum.payment (amount, status, purchase_id, payment_date)
SELECT py.amount, py.status, py.purchase_id, py.payment_date
FROM (
    VALUES 
        (145, 'Success', 1, '2024-02-26 10:15:00'::timestamp),
        (375, 'Success', 2, '2024-02-25 15:00:00'::timestamp),
        (145, 'Success', 3, '2024-02-24 12:00:00'::timestamp),
        (200, 'Success', 4, '2024-02-24 15:30:00'::timestamp),
        (320, 'Success', 5, '2024-02-25 09:30:00'::timestamp)
) AS py(amount, status, purchase_id, payment_date)
LEFT JOIN ls_museum.payment pm ON py.purchase_id = pm.purchase_id
WHERE pm.purchase_id IS NULL;

-- Insert statements for the 'event' table
INSERT INTO ls_museum.event (
    event_name, event_type_id, ticket_cost, start_date, end_date, event_hall_id, event_director_id, description
)
SELECT ev.event_name, ev.event_type_id, ev.ticket_cost, ev.start_date, ev.end_date, ev.event_hall_id, ev.event_director_id, ev.description
FROM (
    VALUES 
        ('Event 1', 1, 100, '2024-03-01 09:00:00'::timestamp, '2024-03-01 18:00:00'::timestamp, 1, 1, 'Description for Event 1'),
        ('Event 2', 2, 150, '2024-03-05 10:00:00'::timestamp, '2024-03-05 20:00:00'::timestamp, 2, 2, 'Description for Event 2'),
        ('Event 3', 3, 200, '2024-03-10 11:00:00'::timestamp, '2024-03-10 22:00:00'::timestamp, 3, 3, 'Description for Event 3'),
        ('Event 4', 1, 120, '2024-03-15 09:30:00'::timestamp, '2024-03-15 17:30:00'::timestamp, 1, 4, 'Description for Event 4'),
        ('Event 5', 2, 180, '2024-03-20 10:30:00'::timestamp, '2024-03-20 19:30:00'::timestamp, 2, 5, 'Description for Event 5')
) AS ev(event_name, event_type_id, ticket_cost, start_date, end_date, event_hall_id, event_director_id, description)
LEFT JOIN ls_museum.event evt ON ev.event_name = evt.event_name
WHERE evt.event_name IS NULL;

-- Insert statements for the 'artwork' table
INSERT INTO ls_museum.artwork (
    name, artist, creation_year, event_id, supplier_id
)
SELECT aw.name, aw.artist, aw.creation_year, aw.event_id, aw.supplier_id
FROM (
    VALUES 
        ('Artwork 1', 'Artist 1', '2000-01-01', 1, 1),
        ('Artwork 2', 'Artist 2', '2010-01-01', 2, 2),
        ('Artwork 3', 'Artist 3', '2020-01-01', 3, 3),
        ('Artwork 4', 'Artist 4', '2005-01-01', 4, 4),
        ('Artwork 5', 'Artist 5', '2015-01-01', 5, 5)
) AS aw(name, artist, creation_year, event_id, supplier_id)
LEFT JOIN ls_museum.artwork art ON aw.name = art.name
WHERE art.name IS NULL;

