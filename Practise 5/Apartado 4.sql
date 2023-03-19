-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ  ~ frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~ manuor01@ucm.es
--
-- Doble grado Ingeniería informática - Matemáticas
--	Universidad Complutense de Madrid.

/*
    This procedure checks wether "Códigos postales I" table has attributes
    with NULL values or not.
*/

CREATE OR REPLACE PROCEDURE comprobar_NULL IS
    
    /* We define a cursor to point the tuples with some value NULL */
    CURSOR tuplasConNuloEnCP IS 
    
        SELECT *
        FROM "Códigos postales I"
        WHERE "Código postal" is NULL or
               Población      is NULL or
               Provincia      is NULL;
               
    /* Variables needed for doing FETCH */
    postCode "Códigos postales I"."Código postal"%TYPE;
    homeTown "Códigos postales I".Población%TYPE;
    province "Códigos postales I".Provincia%TYPE;
    
    /* Counter variable */
    counter integer := 0;
    
    /* Exception to be thrown */
    tuplesWithNull exception;
    
BEGIN
    
    OPEN tuplasConNuloEnCp;
    
    FETCH tuplasConNuloEnCP INTO  postCode,homeTown,province;
    
    WHILE tuplasConNuloEnCp%FOUND LOOP
        DBMS_OUTPUT.put_line('Valor nulo en la tupla: ' || postCode || ' ' || homeTown || ' ' || province);
        counter := counter+1;
        
        FETCH tuplasConNuloEnCP INTO  postCode,homeTown,province;
    END LOOP;
    
    CLOSE tuplasConNuloEnCp;
    
    IF counter!=0 THEN
        RAISE tuplesWithNull;
    END IF;

EXCEPTION

    WHEN tuplesWithNull THEN
        DBMS_OUTPUT.put_line('Se han encontrado ' || counter || ' tuplas con algún atributo nulos');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Oh,Oh; this is unexpected!');
END;

/*
SET SERVEROUTPUT ON SIZE 100000;

Procedure COMPROBAR_NULL compilado

Valor nulo en la tupla:  Arganda                                            Sevilla                                           
Se han encontrado 1 tuplas con algún atributo nulos

Procedimiento PL/SQL terminado correctamente.
*/

