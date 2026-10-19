postgres=# -- Crear los esquemas
postgres=# CREATE SCHEMA pii;
CREATE SCHEMA
postgres=# CREATE SCHEMA analitica;
CREATE SCHEMA
postgres=# -- Crear la tabla de correspondencia
postgres=# CREATE TABLE pii.mapa_cliente (    token UUID PRIMARY KEY,    cliente_id BIGINT UNIQUE        REFERENCES public.clientes(id));
CREATE TABLE
postgres=# -- Generar los tokens
postgres=# CREATE EXTENSION IF NOT EXISTS pgcrypto;
ERROR:  extension "pgcrypto" is not available
HINT:  The extension must first be installed on the system where PostgreSQL is running.
postgres=# CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION
postgres=# INSERT INTO pii.mapa_cliente(token, cliente_id) SELECT    gen_random_uuid(),    idFROM clientes;
ERROR:  column "idfrom" does not exist
LINE 1: ...oken, cliente_id) SELECT    gen_random_uuid(),    idFROM cli...
                                                             ^
postgres=# INSERT INTO pii.mapa_cliente(token, cliente_id) SELECT    gen_random_uuid(),    id FROM clientes;
INSERT 0 5
postgres=# -- Verificar
postgres=# SELECT * FROM pii.mapa_cliente;
                token                 | cliente_id 
--------------------------------------+------------
 2ec65957-7957-40c9-a375-97a4a41d32c6 |          1
 cc63bb90-977a-401b-8457-a60449fb8e6d |          2
 ac78a30a-1237-4861-b66e-c4eff539aadd |          3
 483d84f4-6f65-41db-af1e-2c5a137c0470 |          4
 878101c0-bda5-4da1-a1ff-b16cfa9b9494 |          5
(5 rows)


postgres=# -- Crear el conjunto de datos para analítica
postgres=# CREATE TABLE analitica.clientes AS SELECT    m.token AS cliente_token,    c.edad,    c.ciudad,    c.codigo_postal,    c.fecha_alta FROM pii.mapa_cliente m JOIN clientes c    ON c.id = m.cliente_id;
SELECT 5
postgres=# -- Verificar
postgres=# SELECT * FROM analitica.clientes;
            cliente_token             | edad |   ciudad   | codigo_postal | fecha_alta 
--------------------------------------+------+------------+---------------+------------
 2ec65957-7957-40c9-a375-97a4a41d32c6 |   41 | Culiacán   | 80000         | 2026-10-18
 cc63bb90-977a-401b-8457-a60449fb8e6d |   35 | Culiacán   | 80100         | 2026-10-18
 ac78a30a-1237-4861-b66e-c4eff539aadd |   47 | Mazatlán   | 82000         | 2026-10-18
 483d84f4-6f65-41db-af1e-2c5a137c0470 |   34 | Los Mochis | 81200         | 2026-10-18
 878101c0-bda5-4da1-a1ff-b16cfa9b9494 |   38 | Culiacán   | 80200         | 2026-10-18
(5 rows)


postgres=# -- Crear el rol
postgres=# CREATE ROLE analista NOLOGIN;
CREATE ROLE
postgres=# -- Conceder acceso al conjunto de datos analítico
postgres=# GRANT USAGE ON SCHEMA analitica TO analista; 
GRANT
postgres=# GRANT SELECT ON analitica.clientes TO analista;
GRANT
postgres=# pii.mapa_cliente
postgres-# public.clientes
postgres-# -- Verificar los permisos
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