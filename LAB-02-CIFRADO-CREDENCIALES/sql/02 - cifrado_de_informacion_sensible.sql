postgres=# -- Actividad 2: Cifrado de informacion sensible
postgres=# -- Crear una tabla de demostracion
postgres=# CREATE TABLE clientes_protegidos (    id BIGSERIAL PRIMARY KEY,    nombre VARCHAR(120) NOT NULL,    rfc_cifrado BYTEA NOT NULL);
CREATE TABLE
postgres=# -- Insertar un registro utilizando cifrado simetrico
postgres=# INSERT INTO clientes_protegidos (    nombre,    rfc_cifrado) VALUES (    'Ana López',    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA'));
INSERT 0 1
postgres=# -- Consulta
postgres=# SELECT * FROM clientes_protegidos;
 id |  nombre   |                                                                           rfc_cifrado                                                                            
----+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------
  1 | Ana López | \xc30d04070302e0addeaf0ea810436bd23e01b41216266051f7582f35cda4d6a02f922205b09d5e9022348930cedc8605761deaf419ebdb08128a6e6be7ce89ab1d9ebd212b4bf812bf9d431ff896e2
(1 row)

postgres=# -- Recuperar el dato
postgres=# SELECT    id,    nombre,    pgp_sym_decrypt(        rfc_cifrado,        'CLAVE-DE-PRUEBA'    ) AS rfc FROM clientes_protegidos;
 id |  nombre   |      rfc      
----+-----------+---------------
  1 | Ana López | LOPA900101ABC
(1 row)