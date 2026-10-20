postgres=# -- Actividad 3 - El problema de la gestión de claves
postgres=# -- Identificar una mala práctica
postgres=# SELECT pgp_sym_decrypt(    rfc_cifrado,    'CLAVE-DE-PRUEBA') FROM clientes_protegidos;
 pgp_sym_decrypt 
-----------------
 LOPA900101ABC
(1 row)