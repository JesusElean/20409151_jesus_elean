postgres=# -- Crear la tabla de clientes.
postgres=# CREATE TABLE clientes (    id BIGSERIAL PRIMARY KEY,    nombre VARCHAR(120) NOT NULL,    correo VARCHAR(150) NOT NULL,    telefono VARCHAR(20),    rfc VARCHAR(13),    edad INTEGER,    ciudad VARCHAR(80),    codigo_postal VARCHAR(10),    fecha_alta DATE DEFAULT CURRENT_DATE);
CREATE TABLE
postgres=# \d
               List of relations
 Schema |      Name       |   Type   |  Owner   
--------+-----------------+----------+----------
 public | clientes        | table    | postgres
 public | clientes_id_seq | sequence | postgres
(2 rows)

postgres=# INSERT INTO clientes(nombre, correo, telefono, rfc, edad, ciudad, codigo_postal)VALUES('Ana López', 'ana.lopez@example.test', '6671234567', 'LOAA850315ABC', 41, 'Culiacán', '80000'),('Carlos Pérez', 'carlos.perez@example.test', '6672345678', 'PECA900720DEF', 35, 'Culiacán', '80100'),('María García', 'maria.garcia@example.test', '6673456789', 'GAMA780912GHI', 47, 'Mazatlán', '82000'),('Luis Torres', 'luis.torres@example.test', '6674567890', 'TOLU920201JKL', 34, 'Los Mochis', '81200'),('Laura Sánchez', 'laura.sanchez@example.test', '6675678901', 'SALA880525MNO', 38, 'Culiacán', '80200');
INSERT 0 5
postgres=# SELECT *FROM clientes;
 id |    nombre     |           correo           |  telefono  |      rfc      | edad |   ciudad   | codigo_postal | fecha_alta 
----+---------------+----------------------------+------------+---------------+------+------------+---------------+------------
  1 | Ana López     | ana.lopez@example.test     | 6671234567 | LOAA850315ABC |   41 | Culiacán   | 80000         | 2026-10-18
  2 | Carlos Pérez  | carlos.perez@example.test  | 6672345678 | PECA900720DEF |   35 | Culiacán   | 80100         | 2026-10-18
  3 | María García  | maria.garcia@example.test  | 6673456789 | GAMA780912GHI |   47 | Mazatlán   | 82000         | 2026-10-18
  4 | Luis Torres   | luis.torres@example.test   | 6674567890 | TOLU920201JKL |   34 | Los Mochis | 81200         | 2026-10-18
  5 | Laura Sánchez | laura.sanchez@example.test | 6675678901 | SALA880525MNO |   38 | Culiacán   | 80200         | 2026-10-18
(5 rows)

