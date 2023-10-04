/*insert_artwork function enables you to enter 
 *                        the name of the art work, 
 *                         the artist, 
 *                          the creation year, 
 *                          event name and 
 *                          supplier's name 
 * all at once. As Always the function returns the inserted row id.
 * There is only one example in the DML, so I'm gonna show you here as well.
 * Here is an example of DML using this function.
 * SELECT * FROM insert_artwork('Memory Lost', 'Nan Goldin', '2020', 'NAN GOLDIN: MEMORY LOST', 'Moderna Museet, Stockholm' );
 */
SET search_path TO ls_museum;
DROP FUNCTION IF EXISTS insert_artwork(  "name"   TEXT, 
                                                  artist    TEXT, 
                                                  creation_year TEXT, 
                                                  event_name    TEXT, 
                                                  supplier_name TEXT);

CREATE OR REPLACE FUNCTION insert_artwork(  "name"    TEXT, 
                                                  artist    TEXT, 
                                                  creation_year TEXT, 
                                                  event_name    TEXT, 
                                                  supplier_name TEXT)
RETURNS integer

AS $$

    DECLARE i_event_id integer;
            i_supplier_id integer;
            i_artwork_id integer;
        
    BEGIN
        
    SELECT e.event_id INTO i_event_id                                                                   --selecting necessary event id into i_event_id veriable 
    FROM ls_museum.event e
    WHERE lower(e.event_name) = lower(insert_artwork.event_name :: text);                                 



    
    SELECT s.supplier_id INTO i_supplier_id                                                                     --selecting necessary supplier id into i_supplier_id veriable 
    FROM  ls_museum.supplier s
    WHERE lower(s.name) = lower(insert_artwork.supplier_name:: text);



    
    INSERT INTO ls_museum.artwork("name", 
                                    artist, 
                                    creation_year, 
                                    event_id, 
                                    supplier_id)
    SELECT  "name", 
            artist, 
            to_date(creation_year, 'YYYY'),
            i_event_id,
            i_supplier_id
    RETURNING ls_museum.artwork.artwork_id  INTO i_artwork_id ;                                              --returning artwork_id into i_artwork_id TO CHECK IF the INSERT was successful 

RETURN i_artwork_id LIMIT 1;

END;

$$  LANGUAGE plpgsql;

