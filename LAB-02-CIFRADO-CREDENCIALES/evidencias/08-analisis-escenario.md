# Actividad 8 — Analizar un escenario de seguridad

**Pregunta 1. ¿Cuáles son los principales riesgos?**

Los principales riesgos son la exposición de contraseñas y datos personales, como el RFC, que podrían utilizarse para acceder a otras cuentas o facilitar el robo de identidad. Además, las conexiones sin validación adecuada del servidor pueden permitir ataques de intermediario (Man-in-the-Middle), las claves criptográficas en archivos SQL pueden quedar expuestas y los respaldos sin protección pueden permitir que personas no autorizadas accedan a toda la información almacenada.

**Pregunta 2. ¿Qué mecanismo utilizarías para cada elemento?**

Para proteger los nombres y correos electrónicos utilizaría controles de acceso y permisos por roles; para las contraseñas, un hash criptográfico con sal, como Argon2id o bcrypt; para el RFC y la información financiera, cifrado simétrico como AES-256; para las claves criptográficas, un gestor de secretos como HashiCorp Vault; para las conexiones, TLS con sslmode=verify-full; y para los respaldos, cifrado de archivos y permisos de acceso restringidos.

**Pregunta 3. ¿Cuál de los problemas consideras más crítico y por qué?**

Considero que almacenar las contraseñas en texto claro es uno de los problemas más críticos, porque cualquier persona que consiga acceso a la base de datos podría conocerlas directamente y utilizarlas para acceder a otras cuentas si los usuarios las reutilizan. Por eso, es importante almacenarlas mediante un algoritmo de hash seguro con sal, en lugar de guardar las contraseñas originales.

**Pregunta 4. ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos? Justifica tu respuesta.**

No, tener correctamente configurados los usuarios y permisos no elimina todos los riesgos, ya que estos controles solamente limitan quién puede acceder a la información, pero no protegen por sí solos los datos almacenados en texto claro, las conexiones inseguras, las claves expuestas ni los respaldos sin cifrar. Por ello, es necesario complementar los permisos con mecanismos como el hash de contraseñas, el cifrado de datos, TLS, la gestión segura de claves y la protección de los respaldos.