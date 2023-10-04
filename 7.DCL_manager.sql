SET search_path TO ls_museum;
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