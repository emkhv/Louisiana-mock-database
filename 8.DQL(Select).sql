-- Execute this SQL query to monitor recent updates in the museum database
-- Adjust the query as needed for specific analysis and reporting.

SET search_path TO ls_museum;

SELECT e.event_name , e.description, h.hall_name, et.type_name , e.ticket_cost 
        ,concat(p3.first_name || ' ' || p3.last_name) AS "Event director"
        ,concat(a.address_line_1 ||' '|| a.address_line_2  ||' '|| c.city_name  ||' '|| c2.country_name ) AS director_address
        , e.start_date , e.end_date
        , aw."name" AS artwork, aw.artist AS artist_name, s."name"  AS supplier
        , t.ticket_id AS ticket_name, e.ticket_cost,  p.amount AS payment_amount, p.status AS payment_status
        ,concat(p4.first_name || ' ' || p4.last_name) AS ticket_owner, mt.name AS membership_type
        ,concat(a4.address_line_1 ||' '|| a4.address_line_2  ||' '|| c4.city_name  ||' '|| c41.country_name ) AS address
FROM payment p FULL OUTER JOIN  purchase        p2  ON p.purchase_id = p2.purchase_id 
                LEFT JOIN       membership_card mc  ON p2.membership_card_id = mc.membership_card_id 
                LEFT JOIN       membership_type mt  ON mc.membership_type_id = mt.membership_type_id
                LEFT JOIN       person          p4  ON mc.member_id = p4.person_id 
                LEFT JOIN       address         a4  ON p4.address_id = a4.address_id 
                LEFT JOIN       city            c4  ON a4.city_id = c4.city_id 
                LEFT JOIN       country         c41 ON c4.country_id = c41.country_id 
                FULL OUTER JOIN order_list      ol  ON p2.order_id = ol.order_id 
                FULL OUTER JOIN ticket          t   ON ol.item_id = t.ticket_id 
                FULL OUTER JOIN event           e   ON t.event_id = e.event_id 
                LEFT JOIN       staff_employee  se  ON e.event_director_id = se.employee_id 
                LEFT JOIN       person          p3  ON se.person_id = p3.person_id 
                LEFT JOIN       address         a   ON p3.address_id = a.address_id 
                LEFT JOIN       city            c   ON a.city_id = c.city_id 
                LEFT JOIN       country         c2  ON c.country_id = c2.country_id 
                LEFT JOIN       hall            h   ON e.event_hall_id = h.hall_id 
                LEFT JOIN       event_type      et  ON e.event_type_id = et.event_type_id 
                FULL OUTER JOIN artwork         aw  ON aw.event_id = e.event_id 
                LEFT JOIN       supplier        s   ON aw.supplier_id = s.supplier_id 
WHERE p.last_update  >= date_trunc('month', current_date - interval '1' month)
  and p.last_update < now();
                
                
            