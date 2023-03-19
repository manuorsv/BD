-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ   ~ frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR               ~ manuor01@ucm.es
--
-- Doble grado Ingeniería informática - Matemáticas
--	Universidad Complutense de Madrid.

/*
    This method checks wether "Código postal" attribute in "Códigos postales I"
    table is a primary key or not.
*/
CREATE OR REPLACE PROCEDURE comprobar_PK IS
    
    /* We define a cursor to point the tuples with some value NULL */
    CURSOR postCode_numApariciones IS 
    
        SELECT "Código postal",count(*)
        FROM "Códigos postales I"
        GROUP BY "Código postal";
               
    /* Variables needed for doing FETCH */
    postCode "Códigos postales I"."Código postal"%TYPE;
    numApariciones integer;
    
    /* Exception to be thrown */
    tuplesWithNull exception;
    duplicatedPrimKey exception;
    
BEGIN
    
    OPEN postCode_numApariciones;
    
    FETCH postCode_numApariciones INTO  postCode,numApariciones;
    
    WHILE postCode_numApariciones%FOUND LOOP
        
        IF postCode IS NULL THEN
            RAISE tuplesWithNull;  
        ELSIF numApariciones>1 THEN
            RAISE duplicatedPrimKey;
        END IF;
        
        FETCH postCode_numApariciones INTO  postCode,numApariciones;
    END LOOP;
    
    CLOSE postCode_numApariciones;

EXCEPTION

    WHEN tuplesWithNull THEN
        DBMS_OUTPUT.put_line('Se ha encontrado una tupla con clave primaria nula');
    WHEN duplicatedPrimKey THEN
        DBMS_OUTPUT.put_line('Se ha encontrado una clave primaria repetida');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Oh,Oh; this is unexpected!');
END;

/*
EXECUTE COMPROBAR_PK;

Se ha encontrado una tupla con clave primaria nula
Procedimiento PL/SQL terminado correctamente.

UPDATE "Códigos postales I" SET "Código postal"=14900 WHERE "Código postal" IS NULL;
1 fila actualizadas.

EXECUTE COMPROBAR_PK;

Se ha encontrado uba clave primaria repetida
Procedimiento PL/SQL terminado correctamente.
*/

