-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ  ~  frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR              ~  manuor01@ucm.es
--
--   Doble grado Ingeniería informática - Matemáticas
--	 Universidad Complutense de Madrid.

--Para eliminar las tablas creadas con el mismo nombre:
--DROP TABLE Empleados;
--DROP TABLE Domicilios;
--DROP TABLE Teléfonos;
--DROP TABLE "Códigos postales";

Create table Empleados
(
    Nombre Char(50) not null, 
    DNI Char(9), 
    Sueldo Number(6,2), 
    primary key (DNI),
    check(Sueldo between 735.9 and 5000)
);
Create table "Códigos postales"
(
    "Código postal" Char(5),
    Población Char(50),
    Provincia Char(50),
    primary key("Código postal")
);
Create table Domicilios
(
    DNI Char(9), 
    Calle Char(50), 
    "Código postal" Char(5),
    primary key (DNI, Calle, "Código postal"),
    foreign key (DNI) references Empleados(DNI) on delete cascade,
    foreign key ("Código postal") references "Códigos postales"("Código postal")
);
Create table Teléfonos
(
    DNI Char(9), 
    Teléfono Char(9),
    primary key (DNI, Teléfono),
    foreign key (DNI) references Empleados(DNI) on delete cascade
);

-- Respuesta del servidor:
/*
Table EMPLEADOS creado.
Table "Códigos postales" creado.
Table DOMICILIOS creado.
Table TELÉFONOS creado.
*/
