postgres=# -- Generalizar la edad
postgres=# SELECT    CASE        WHEN edad BETWEEN 18 AND 30 THEN '18-30'        WHEN edad BETWEEN 31 AND 45 THEN '31-45'        ELSE '46+'    END AS rango_edad,    COUNT(*) AS total FROM clientes GROUP BY 1;
 rango_edad | total 
------------+-------
 31-45      |     4
 46+        |     1
(2 rows)

postgres=# -- Generalizar la region
postgres=# SELECT    LEFT(codigo_postal, 2) AS region,    COUNT(*) AS total FROM clientes GROUP BY 1;
 region | total 
--------+-------
 82     |     1
 80     |     3
 81     |     1
(3 rows)

postgres=# -- Combinar atributos
postgres=# SELECT    CASE        WHEN edad BETWEEN 18 AND 30 THEN '18-30'        WHEN edad BETWEEN 31 AND 45 THEN '31-45'        ELSE '46+'    END AS rango_edad,    LEFT(codigo_postal, 2) AS region,    COUNT(*) AS total FROM clientes GROUP BY 1, 2;
 rango_edad | region | total 
------------+--------+-------
 31-45      | 81     |     1
 46+        | 82     |     1
 31-45      | 80     |     3
(3 rows)

postgres=# -- Suprimir grupos pequeños
postgres=# SELECT    CASE        WHEN edad BETWEEN 18 AND 30 THEN '18-30'        WHEN edad BETWEEN 31 AND 45 THEN '31-45'        ELSE '46+'    END AS rango_edad,    LEFT(codigo_postal, 2) AS region,    COUNT(*) AS total FROM clientes GROUP BY 1, 2 HAVING COUNT(*) >= 5;
 rango_edad | region | total 
------------+--------+-------
(0 rows)

postgres=# SELECT     CASE         WHEN edad BETWEEN 18 AND 40 THEN '18-40 (Jóvenes/Adultos)'        ELSE '41+ (Adultos Mayores/Ancianos)'    END AS rango_edad_amplio,    LEFT(codigo_postal, 1) AS macro_region,     COUNT(*) AS total FROM clientes GROUP BY 1, 2 HAVING COUNT(*) >= 2;
       rango_edad_amplio        | macro_region | total 
--------------------------------+--------------+-------
 18-40 (Jóvenes/Adultos)        | 8            |     3
 41+ (Adultos Mayores/Ancianos) | 8            |     2
(2 rows)