postgres=# -- Crear el rol
                                                              ^
postgres=# CREATE VIEW v_clientes_soporte AS
postgres-# SELECT
postgres-#     id,
postgres-#     nombre,
postgres-# 
postgres-#     CONCAT(
postgres(#         LEFT(correo, 2),
postgres(#         '*****',
postgres(#         SUBSTRING(correo FROM POSITION('@' IN correo))
postgres(#     ) AS correo,
postgres-# 
postgres-#     CONCAT(
postgres(#         '******',
postgres(#         RIGHT(telefono, 4)
postgres(#     ) AS telefono,
postgres-# 
postgres-#     CONCAT(
postgres(#         '*********',
postgres(#         RIGHT(rfc, 4)
postgres(#     ) AS rfc
postgres-# 
postgres-# FROM clientes;
CREATE VIEW
postgres=# SELECT *FROM v_clientes_soporte;
 id |    nombre     |        correo        |  telefono  |      rfc      
----+---------------+----------------------+------------+---------------
  1 | Ana López     | an*****@example.test | ******4567 | *********5ABC
  2 | Carlos Pérez  | ca*****@example.test | ******5678 | *********0DEF
  3 | María García  | ma*****@example.test | ******6789 | *********2GHI
  4 | Luis Torres   | lu*****@example.test | ******7890 | *********1JKL
  5 | Laura Sánchez | la*****@example.test | ******8901 | *********5MNO
(5 rows)

postgres=# CREATE ROLE soporte NOLOGIN;
CREATE ROLE


postgres=# -- Conceder acceso a la vista
postgres=# GRANT USAGE ON SCHEMA public TO soporte;
GRANT
postgres=# GRANT SELECT ON v_clientes_soporte TO soporte;
GRANT
postgres=# -- Verificar el resultado
postgres=# SELECT * FROM v_clientes_soporte;
 id |    nombre     |        correo        |  telefono  |      rfc      
----+---------------+----------------------+------------+---------------
  1 | Ana López     | an*****@example.test | ******4567 | *********5ABC
  2 | Carlos Pérez  | ca*****@example.test | ******5678 | *********0DEF
  3 | María García  | ma*****@example.test | ******6789 | *********2GHI
  4 | Luis Torres   | lu*****@example.test | ******7890 | *********1JKL
  5 | Laura Sánchez | la*****@example.test | ******8901 | *********5MNO
(5 rows)

postgres=# SELECT * FROM clientes;
 id |    nombre     |           correo           |  telefono  |      rfc      | edad |   ciudad   | codigo_postal | fecha_alta 
----+---------------+----------------------------+------------+---------------+------+------------+---------------+------------
  1 | Ana López     | ana.lopez@example.test     | 6671234567 | LOAA850315ABC |   41 | Culiacán   | 80000         | 2026-10-18
  2 | Carlos Pérez  | carlos.perez@example.test  | 6672345678 | PECA900720DEF |   35 | Culiacán   | 80100         | 2026-10-18
  3 | María García  | maria.garcia@example.test  | 6673456789 | GAMA780912GHI |   47 | Mazatlán   | 82000         | 2026-10-18
  4 | Luis Torres   | luis.torres@example.test   | 6674567890 | TOLU920201JKL |   34 | Los Mochis | 81200         | 2026-10-18
  5 | Laura Sánchez | laura.sanchez@example.test | 6675678901 | SALA880525MNO |   38 | Culiacán   | 80200         | 2026-10-18
(5 rows)

postgres=# REVOKE ALL ON clientes FROM soporte;
REVOKE

postgres=# SET ROLE soporte;
SET
postgres=> SELECT * FROM v_clientes_soporte;
 id |    nombre     |        correo        |  telefono  |      rfc      
----+---------------+----------------------+------------+---------------
  1 | Ana López     | an*****@example.test | ******4567 | *********5ABC
  2 | Carlos Pérez  | ca*****@example.test | ******5678 | *********0DEF
  3 | María García  | ma*****@example.test | ******6789 | *********2GHI
  4 | Luis Torres   | lu*****@example.test | ******7890 | *********1JKL
  5 | Laura Sánchez | la*****@example.test | ******8901 | *********5MNO
(5 rows)

postgres=> SELECT * FROM clientes;
ERROR:  permission denied for table clientes

