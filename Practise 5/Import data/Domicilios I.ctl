LOAD DATA
INFILE 'Domicilios I.txt'
APPEND
INTO TABLE "Domicilios I"
FIELDS TERMINATED BY ';'
 (DNI, Calle, "Código Postal")
