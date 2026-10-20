postgres@jesuselean:~> psql -U postgres
psql (18.6)
Type "help" for help.

postgres=# SELECT    ssl,    version,    cipher FROM pg_stat_ssl WHERE pid = pg_backend_pid();
 ssl | version | cipher 
-----+---------+--------
 f   |         | 
(1 row)