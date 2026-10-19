postgres=# SELECT * FROM clientes WHERE fecha_alta <      CURRENT_DATE - INTERVAL '5 years';
 id | nombre | correo | telefono | rfc | edad | ciudad | codigo_postal | fecha_alta 
----+--------+--------+----------+-----+------+--------+---------------+------------
(0 rows)

postgres=# -- Área de soporte
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
postgres=> RESET ROLE;
RESET
postgres=# -- Área de analítica
postgres=# SET ROLE analista;
SET
postgres=> SELECT * FROM analitica.clientes;
            cliente_token             | edad |   ciudad   | codigo_postal | fecha_alta 
--------------------------------------+------+------------+---------------+------------
 2ec65957-7957-40c9-a375-97a4a41d32c6 |   41 | Culiacán   | 80000         | 2026-10-18
 cc63bb90-977a-401b-8457-a60449fb8e6d |   35 | Culiacán   | 80100         | 2026-10-18
 ac78a30a-1237-4861-b66e-c4eff539aadd |   47 | Mazatlán   | 82000         | 2026-10-18
 483d84f4-6f65-41db-af1e-2c5a137c0470 |   34 | Los Mochis | 81200         | 2026-10-18
 878101c0-bda5-4da1-a1ff-b16cfa9b9494 |   38 | Culiacán   | 80200         | 2026-10-18
(5 rows)

postgres=> SELECT * FROM pii.mapa_cliente;
ERROR:  permission denied for schema pii
LINE 1: SELECT * FROM pii.mapa_cliente;
                      ^
postgres=> SELECT * FROM public.clientes;
ERROR:  permission denied for table clientes
postgres=> 