LOAD DATA 
INFILE 'Empleados.txt'
APPEND
INTO TABLE Empleados
FIELDS TERMINATED BY ';'
(Nombre, DNI, Sueldo)

