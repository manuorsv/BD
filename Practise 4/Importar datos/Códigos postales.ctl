LOAD DATA 
INFILE 'Códigos postales.txt'
APPEND
INTO TABLE "Códigos postales"
FIELDS TERMINATED BY ';'
("Código postal", Población, Provincia)

