postgres=# -- Verificar el estado de TSL en postgresSQL
postgres=# SHOW ssl;
 ssl 
-----
 off
(1 row)

postgres=# SHOW ssl_min_protocol_version;
 ssl_min_protocol_version 
--------------------------
 TLSv1.2
(1 row)

postgres=# SHOW port;
 port 
------
 5432
(1 row)

postgres=# SHOW listen_addresses;
 listen_addresses 
------------------
 localhost
(1 row)

postgres=# -- Verificar la conexion actual
postgres=# SELECT    inet_client_addr(),    inet_client_port();
 inet_client_addr | inet_client_port 
------------------+------------------
                  |                 
(1 row)

postgres=# -- Verificar si la sesion actual utiliza TLS:
postgres=# SELECT    ssl,    version,    cipher FROM pg_stat_ssl WHERE pid = pg_backend_pid();
 ssl | version | cipher 
-----+---------+--------
 f   |         | 
(1 row)