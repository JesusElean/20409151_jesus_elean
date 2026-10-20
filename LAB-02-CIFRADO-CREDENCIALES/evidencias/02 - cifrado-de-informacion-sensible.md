# Actividad 2 — Cifrado de información sensible

En LAB-01 se identificaron datos que pueden requerir protección adicional.

Para esta actividad utilizaremos el campo RFC como ejemplo.

1. **¿Qué diferencia existe entre crypt() y pgp_sym_encrypt()?**

Que pgp_sym_encrypt() es una funcion de cifrado simétrico basado en el estándar OpenPGP. Próposito es cifrar información sensible como los RFC o números de tarjetas de manera que si pueda ser descifrada posteriormente, mientras que como lo vimos previamente con crypt() se trata de una función de hash unidireccional con salt que esta diseñada específicamente para proteger contraseñas y no se puede revertir.

2. **¿Cuál de los dos mecanismos permite recuperar el dato original?**

pgp_sym_encrypt permite recuperar los datos posteriormente.

3. **¿Qué ocurre si se utiliza una clave incorrecta?**

La función fallara y arrojará un error de descrifrado protegiendo la información para que no sea revelada.

4. **¿Qué problema de seguridad representa colocar la clave directamente en una consulta?**

Representa un grave riesgo ya que la clave queda expuesta en texto plano, o en el historial de comandos de la consola, registros de consultas de la base de datos como los query logs o código fuente de la aplicación y cualquier persona con los acceso a estos registros pueden ver la clave y descifrar toda la información protegida.