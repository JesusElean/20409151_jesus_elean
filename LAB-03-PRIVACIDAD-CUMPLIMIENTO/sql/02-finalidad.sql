postgres=# -- Diseña una consulta que proporcione información agregada
postgres=# SELECT    ciudad,    COUNT(*) AS cantidad_clientes FROM clientes GROUP BY ciudad ORDER BY cantidad_clientes DESC;
   ciudad   | cantidad_clientes 
------------+-------------------
 Culiacán   |                 3
 Los Mochis |                 1
 Mazatlán   |                 1
(3 rows)

postgres=# -- Ahora crea rangos de edad:
postgres=# SELECT    CASE        WHEN edad < 18 THEN 'Menor de 18'        WHEN edad BETWEEN 18 AND 29 THEN '18-29'        WHEN edad BETWEEN 30 AND 44 THEN '30-44'        WHEN edad BETWEEN 45 AND 59 THEN '45-59'        ELSE '60 o más'    END AS rango_edad,    COUNT(*) AS cantidad FROM clientes GROUP BY    CASE        WHEN edad < 18 THEN 'Menor de 18'        WHEN edad BETWEEN 18 AND 29 THEN '18-29'        WHEN edad BETWEEN 30 AND 44 THEN '30-44'        WHEN edad BETWEEN 45 AND 59 THEN '45-59'        ELSE '60 o más'    END ORDER BY rango_edad;
 rango_edad | cantidad 
------------+----------
 30-44      |        4
 45-59      |        1
(2 rows)
