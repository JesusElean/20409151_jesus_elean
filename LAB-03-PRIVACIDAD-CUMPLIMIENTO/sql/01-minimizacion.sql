-- Crea una tabla que contenga únicamente los datos necesarios para la finalidad de soporte:

postgres=# CREATE TABLE clientes_soporte (    id BIGINT PRIMARY KEY,    nombre VARCHAR(120) NOT NULL,    correo VARCHAR(150) NOT NULL,    telefono VARCHAR(20));
CREATE TABLE

-- Carga información a partir de clientes:

postgres=# INSERT INTO clientes_soporte (    id,    nombre,    correo,    telefono) SELECT    id,    nombre,    correo,    telefono FROM clientes;
INSERT 0 5

-- Consulta:

postgres=# SELECT * FROM clientes_soporte;
 id |    nombre     |           correo           |  telefono  
----+---------------+----------------------------+------------
  1 | Ana López     | ana.lopez@example.test     | 6671234567
  2 | Carlos Pérez  | carlos.perez@example.test  | 6672345678
  3 | María García  | maria.garcia@example.test  | 6673456789
  4 | Luis Torres   | luis.torres@example.test   | 6674567890
  5 | Laura Sánchez | laura.sanchez@example.test | 6675678901
(5 rows)