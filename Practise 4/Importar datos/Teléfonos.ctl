LOAD DATA 
INFILE 'Teléfonos.txt'
APPEND
INTO TABLE Teléfonos
FIELDS TERMINATED BY ';'
(DNI, Teléfono)

