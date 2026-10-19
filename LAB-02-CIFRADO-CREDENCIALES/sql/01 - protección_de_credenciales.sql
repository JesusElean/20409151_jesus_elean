postgres=# -- Proteccion de Datos
postgres=# -- Implementacion incorrecta
postgres=# CREATE TABLE usuarios_insegura (    id BIGSERIAL PRIMARY KEY,    usuario VARCHAR(50) NOT NULL,    password VARCHAR(100) NOT NULL);
CREATE TABLE
postgres=# -- Insertar usuario de prueba
postgres=# INSERT INTO usuarios_insegura (usuario, password) VALUES ('juan', 'Password123');
INSERT 0 1
postgres=# SELECT * FROM usuarios_insegura;
 id | usuario |  password   
----+---------+-------------
  1 | juan    | Password123
(1 row)

postgres=# -- Identificar el problema
postgres=# -- Generar una representacion no reversible
postgres=# -- Usar pgcrypto
postgres=# SELECT crypt(    'Password123',    gen_salt('bf'));
                            crypt                             
--------------------------------------------------------------
 $2a$06$Nuke.t7xmvPlkRuzP15eOevZI9H5JjVjB4503Jm5ylT8vAXNsfaZ.
(1 row)

postgres=# -- Ejecutar nuevamente
postgres=# SELECT crypt(    'Password123',    gen_salt('bf'));
                            crypt                             
--------------------------------------------------------------
 $2a$06$cTl.fOqKfYbPckOAjXcA/.GYl2G5SCNFCSPqNnINw7JwXKE2LYpS.
(1 row)


postgres=# -- Crear una tabla para credenciales protegidas
postgres=# CREATE TABLE usuarios_segura (    id BIGSERIAL PRIMARY KEY,    usuario VARCHAR(50) UNIQUE NOT NULL,    password_hash TEXT NOT NULL);
CREATE TABLE
postgres=# -- Insertar un usuario
postgres=# INSERT INTO usuarios_segura (usuario, password_hash) VALUES (    'juan',    crypt('Password123', gen_salt('bf')));
INSERT 0 1
postgres=# -- Consulta
postgres=# SELECT * FROM usuarios_segura;
 id | usuario |                        password_hash                         
----+---------+--------------------------------------------------------------
  1 | juan    | $2a$06$52/TipM4qgmfv7p28Tr2WevuxmTIGd3vD8OOOOg.JQJxrgdJAaXcO
(1 row)

postgres=# -- Verificar una contraseña
postgres=# SELECT    usuario,    password_hash = crypt('Password123', password_hash)        AS contraseña_correcta FROM usuarios_segura WHERE usuario = 'juan';
 usuario | contraseña_correcta 
---------+---------------------
 juan    | t
(1 row)

postgres=# -- Probar con una contraseña incorrecta
postgres=# SELECT    usuario,    password_hash = crypt('OtraPassword', password_hash)        AS contraseña_correcta FROM usuarios_segura WHERE usuario = 'juan';
 usuario | contraseña_correcta 
---------+---------------------
 juan    | f
(1 row)