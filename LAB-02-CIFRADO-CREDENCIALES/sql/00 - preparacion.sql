postgres=# -- Preparación 
postgres=# -- Verifica la estructura
postgres=# \d clientes
                                       Table "public.clientes"
    Column     |          Type          | Collation | Nullable |               Default                
---------------+------------------------+-----------+----------+--------------------------------------
 id            | bigint                 |           | not null | nextval('clientes_id_seq'::regclass)
 nombre        | character varying(120) |           | not null | 
 correo        | character varying(150) |           | not null | 
 telefono      | character varying(20)  |           |          | 
 rfc           | character varying(13)  |           |          | 
 edad          | integer                |           |          | 
 ciudad        | character varying(80)  |           |          | 
 codigo_postal | character varying(10)  |           |          | 
 fecha_alta    | date                   |           |          | CURRENT_DATE
Indexes:
    "clientes_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "pii.mapa_cliente" CONSTRAINT "mapa_cliente_cliente_id_fkey" FOREIGN KEY (cliente_id) REFERENCES clientes(id)

postgres=# SELECT * FROM clientes;
 id |    nombre     |           correo           |  telefono  |      rfc      | edad |   ciudad   | codigo_postal | fecha_alta 
----+---------------+----------------------------+------------+---------------+------+------------+---------------+------------
  1 | Ana López     | ana.lopez@example.test     | 6671234567 | LOAA850315ABC |   41 | Culiacán   | 80000         | 2026-10-18
  2 | Carlos Pérez  | carlos.perez@example.test  | 6672345678 | PECA900720DEF |   35 | Culiacán   | 80100         | 2026-10-18
  3 | María García  | maria.garcia@example.test  | 6673456789 | GAMA780912GHI |   47 | Mazatlán   | 82000         | 2026-10-18
  4 | Luis Torres   | luis.torres@example.test   | 6674567890 | TOLU920201JKL |   34 | Los Mochis | 81200         | 2026-10-18
  5 | Laura Sánchez | laura.sanchez@example.test | 6675678901 | SALA880525MNO |   38 | Culiacán   | 80200         | 2026-10-18
(5 rows)

postgres=# CREATE EXTENSION IF NOT EXISTS pgcrypto;
NOTICE:  extension "pgcrypto" already exists, skipping
CREATE EXTENSION
postgres=# SELECT extname FROM pg_extension WHERE extname = 'pgcrypto';
 extname  
----------
 pgcrypto
(1 row)