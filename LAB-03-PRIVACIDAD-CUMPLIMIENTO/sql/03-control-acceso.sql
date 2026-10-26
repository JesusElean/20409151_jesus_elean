postgres=# -- Actividad 4 - Control de acceso relacionado con la finalidad.
postgres=# -- Crea un rol:
postgres=# CREATE ROLE analista NOLOGIN;
ERROR:  role "analista" already exists
postgres=# \du
                               List of roles
  Role name   |                         Attributes                         
--------------+------------------------------------------------------------
 analista     | Cannot login
 komirateamdb | 
 postgres     | Superuser, Create role, Create DB, Replication, Bypass RLS
 soporte      | Cannot login

postgres=# -- Otorga únicamente acceso a la información preparada para analitica.
postgres=# -- Por ejemplo, crea una vista:
postgres=# CREATE VIEW v_analitica_clientes AS SELECT    ciudad,    CASE        WHEN edad < 18 THEN 'Menor de 18'        WHEN edad BETWEEN 18 AND 29 THEN '18-29'        WHEN edad BETWEEN 30 AND 44 THEN '30-44'        WHEN edad BETWEEN 45 AND 59 THEN '45-59'        ELSE '60 o más'    END AS rango_edad FROM clientes;
CREATE VIEW
postgres=# -- Otorga permiso:
postgres=# GRANT USAGE ON SCHEMA public TO analista;
GRANT
postgres=# GRANT SELECT ON v_analitica_clientes TO analista;
GRANT
postgres=# -- Verificacion
postgres=# -- Comprueba privilegios:
postgres=# SELECT    grantee,    table_name,    privilege_type FROM information_schema.role_table_grants WHERE grantee = 'analista';
 grantee  |      table_name      | privilege_type 
----------+----------------------+----------------
 analista | clientes             | SELECT
 analista | v_analitica_clientes | SELECT
(2 rows)