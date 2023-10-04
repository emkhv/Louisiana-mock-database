/* The insert_address function takes input of address line 1, address line 2, name of the city, country name and postal code, 
 * and inserts it into the address entity, returning created address id.
 * You can put any infromation, it will insert it if it doesn't already exist, and it will avoid duplications.
 * So you can add person's full address information in one line, doesn't matter where they are from. 
 */
SET search_path TO ls_museum;
DROP FUNCTION IF EXISTS insert_address(text,text,text,text,text);

CREATE OR REPLACE FUNCTION insert_address( address_line_1  TEXT, 
                                                address_line_2  TEXT, 
                                                city_name       TEXT, 
                                                country_name    TEXT, 
                                                postal_code     TEXT)
RETURNS integer

AS $$

    DECLARE i_address_id integer;
            i_country_id integer;
            i_city_id   integer;
        
    BEGIN
        
    INSERT INTO ls_museum.country (country_name)                                                            --inserting country
    SELECT insert_address.country_name
        WHERE NOT EXISTS (                                                                                  --checking if it already exists
            SELECT c.country_name 
            FROM ls_museum.country c 
            WHERE lower(insert_address.country_name) = lower(c.country_name)
        );                                                                                                  
   
    SELECT c.country_id INTO i_country_id                                                                   --selecting necessary country id into i_country_id veriable 
    FROM country c
    WHERE lower(c.country_name) = lower(insert_address.country_name);                                  



    
    INSERT INTO ls_museum.city(city_name, country_id)                                                       --inserting city                
    SELECT insert_address.city_name, i_country_id 
    WHERE NOT EXISTS (                                                                                        --checking if it already exists
            SELECT ct.city_name 
            FROM ls_museum.city ct 
            WHERE lower(insert_address.city_name) = lower(ct.city_name)
        );                                                                                                  
    
    SELECT ct.city_id INTO i_city_id                                                                        --selecting necessary city id into i_city_id veriable 
    FROM city ct
    WHERE lower(ct.city_name) = lower(insert_address.city_name);



    
    INSERT INTO ls_museum.address(  address_line_1,                                                         --inserting all into address table
                                    address_line_2, 
                                    city_id, 
                                    postal_code)
    SELECT  address_line_1, 
            address_line_2, 
            i_city_id, 
            postal_code 
    FROM ls_museum.city c
    WHERE lower(insert_address.city_name)= lower(c.city_name)
    LIMIT 1
    RETURNING ls_museum.address.address_id INTO i_address_id ;                                              --returning address_id into i_address_id

RETURN i_address_id;

END;

$$  LANGUAGE plpgsql;