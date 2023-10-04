--Creating a function that shows all artworks with mentioned artist
SET search_path TO ls_museum;
CREATE OR REPLACE FUNCTION get_artworks_by_artist(artist_name_param text)
RETURNS TABLE (
    artwork_id INT,
    name TEXT,
    creation_year INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        artwork_id,
        name,
        creation_year
    FROM
        artwork
    WHERE
        artist = artist_name_param;
END;
$$ LANGUAGE plpgsql;