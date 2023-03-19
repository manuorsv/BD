-- FRANCISCO JAVIER BLÁZQUEZ MARTÍNEZ ~ frblazqu@ucm.es
-- MANUEL ORTEGA SALVADOR ~ manuor01@ucm.es
--
-- Doble grado Ingeniería informática - Matemáticas
--	Universidad Complutense de Madrid.
--
-- Comentarios:
-- Todo el código de creación de tablas y de inserción de datos es únicamente
-- para probar las consultas en el entorno DES (http://des.sourceforge.net/)
-- y obviamente no es parte de las consultas que se deben entregar en la práctica.


-- 0.- Eliminación de tablas anteriores y configuración para SQL:
-- 0.1.- Eliminar las relaciones que tuviera la bd
/abolish
-- 0.2.- Para procesar solo instrucciones SQL
/sql
-- 0.3.- Para permitir la inserción multilinea de instrucciones
/multiline on


-- 1. - Creación de tablas
Create table Empleados 
(
	Nombre char(50), 
  	DNI Char(9), 
  	Sueldo Number(6,2),
  	primary key(DNI),
  	check (Sueldo between 735.9 and 5000.0)
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
  	foreign key (DNI) references Empleados (DNI),
  	foreign key ("Código postal") references "Códigos postales" ("Código postal")
);  	
Create table Teléfonos
(
    DNI Char(9), 
    Teléfono Char(9),
    primary key (DNI, Teléfono),
    foreign key (DNI) references Empleados(DNI) 
);

-- 2. Inserción
insert into Empleados(Nombre,DNI,Sueldo) values ('Antonio Arjona', '12345678A', 5000.0);
insert into Empleados(Nombre,DNI,Sueldo) values ('Carlota Cerezo', '12345678C', 1000.0);
insert into Empleados(Nombre,DNI,Sueldo) values ('Laura López', '12345678L', 1500.0);
insert into Empleados(Nombre,DNI,Sueldo) values ('Pedro Pérez' ,'12345678P' ,2000.0);

insert into Teléfonos(DNI, Teléfono) values ('12345678C', '611111111');
insert into Teléfonos(DNI, Teléfono) values ('12345678C', '931111111');
insert into Teléfonos(DNI, Teléfono) values ('12345678L', '913333333');
insert into Teléfonos(DNI, Teléfono) values ('12345678P', '913333333');
insert into Teléfonos(DNI, Teléfono) values ('12345678P', '644444444');

insert into "Códigos postales"("Código postal", Población, Provincia) values ('08050', 'Parets', 'Barcelona');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('14200', 'Peñarroya', 'Córdoba');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('14900', 'Lucena', 'Córdoba');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('28040', 'Madrid', 'Madrid');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('50008', 'Zaragoza', 'Zaragoza');
insert into "Códigos postales"("Código postal", Población, Provincia) values ('28004', 'Arganda', 'Madrid');

insert into Domicilios(DNI,Calle,"Código postal") values ('12345678A', 'Avda. Complutense', '28040');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678A', 'Cántaro', '28004');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678P', 'Diamante', '14200');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678P', 'Carbón', '14900');
insert into Domicilios(DNI,Calle,"Código postal") values ('12345678L', 'Diamante', '14200');


-- 3. -Consultas
-- 3.1.- Listado de los empleados con domicilio ordenados por Código postal y Nombre
create view vista1 as 
  select Nombre, Calle, "Código postal"
  from Empleados natural inner join Domicilios
  order by "Código postal", Nombre;

-- 3.2.- Empleados que tengan teléfono ordenados por nombre:
create view vista2 as

select Nombre,Domicilios.DNI,Calle,"Código postal",Teléfono
from (Empleados natural join Teléfonos) natural left outer join Domicilios 
order by Nombre;

-- 3.3.- Listado de todos los empleados ordenados por nombre, tanto los empleados que tengan teléfono
--       como los que no
create view vista3 as
	select Nombre, DNI, Calle, "Código postal", Teléfono
	from (Empleados natural left outer join Teléfonos) natural left outer join Domicilios 
	order by Nombre;

-- 3.4.- Listado de todos los empleados ordenados por nombre (Esquema de valores nulos fijo):
create view vista4 as

select Nombre,DNI,Calle,Población,Provincia,"Código postal"
from (Empleados natural left outer join Domicilios) natural left outer join "Códigos postales"
order by Nombre;

-- 3.5.- Listado de todos los empleados ordenados por nombre
create view vista5 as
	select Nombre, DNI, Calle, Población, Provincia, "Código postal", Teléfono
	from (Empleados natural left outer join Teléfonos) natural left outer join Domicilios natural left outer 		  join "Códigos postales"
	order by Nombre;

-- 3.6.- Incrementa los salarios de todos los empleados un 10% (acotado por 1900):
update Empleados set Sueldo=1.1*Sueldo where 1.1*Sueldo<=1900.0;

create view vista6 as select * from Empleados;

-- 3.7.- Deshaz la operación anterior con otra instrucción UPDATE
update Empleados set Sueldo = Sueldo/1.1
where Sueldo <= 1900.0;

-- 3.8.- Probar los apartados 6 y 7 con una acotación de 1600, ¿Qué sucede?:

-- update Empleados set Sueldo=1.1*Sueldo where 1.1*Sueldo<=1600.0;
-- update Empleados set Sueldo=Sueldo/(1.1) where Sueldo<=1600.0;
-- 
-- create view vista8 as select * from Empleados;

-- Lo que sucede es que mientras que Carlota está algo triste por volver a su salario
-- original antes de que la subida y Antonio y Pedro están indiferentes por completo
-- con el mismo salario de siempre, Laura está¡ rabiando porque no solo nunca vió una
-- subida sino que vió una bajada (ahora cobra unos 140eur menos).
--
-- El problema viene causado porque una operación no es inversa a la anterior, esto es,
-- hay rangos que no experimentan subida pero que sí que experimentan bajada de salarios.

-- 3.9.- Listado que muestre número total de empleados, el sueldo mínimo, el máximo y el medio
create view vista9 as	
	select count(*) as Empleados, min(Sueldo) as "Sueldo mínimo", max(Sueldo) as "Sueldo máximo", 			 	   avg(Sueldo) as "Sueldo medio"
	from Empleados;

-- 3.10.- Listado que muestre sueldo medio por población y número de empleados, ordenado por
--		  población
create view vista10 as
    
select count(*),avg(Sueldo),Población 
from (Empleados natural left outer join Domicilios) 
                natural left outer join "Códigos postales"
group by Población
order by Población;

-- 3.11.- Obtener los empleados que tengan más de un teléfono, indicando Nombre, DNI y Teléfono,
--		  ordenados por su nombre
create view vista11a as

select distinct Nombre,Empleados.DNI,t1.Teléfono
from Empleados, Teléfonos t1, Teléfonos t2
where Empleados.DNI=t1.DNI and Empleados.DNI=t2.DNI and t1.Teléfono != t2.Teléfono
order by Nombre;

create view vista11b as
	with Cantidad_teléfonos_emp(DNI, numTeléfonos) as
		select DNI, count(*) numTeléfonos
		from Empleados natural inner join Teléfonos
		group by DNI
	select Nombre, DNI, Teléfono
	from (Empleados natural inner join Cantidad_teléfonos_emp) natural inner join Teléfonos
	where numTeléfonos > 1
	order by Nombre;


/multiline off
/datalog
