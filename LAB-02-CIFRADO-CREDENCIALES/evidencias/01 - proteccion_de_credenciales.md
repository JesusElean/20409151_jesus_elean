# Actividad 1 — Protección de credenciales
## El problema
Supongamos que una aplicación necesita almacenar información de usuarios.

### Pregunta
**¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?**
Si una persona obtiene acceso de lectura a esa tabla, podrá ver las contraseñas en texto plano como en este caso 'Password123'.
Esto puede causar riesgos severos como que si el usuario usa la misma contraseña en otros servicios o plataformas, las cuentas en esos sitios tambien pueden verse comprometidas y al no haber ningún cifrado o encriptación cualquiera con acceso puede obtener las contraseñas reales de manera rapida.

## Identificar el problema

La consulta anterior permite observar directamente la contraseña.

Esto representa una mala práctica porque una persona con acceso a la tabla puede obtener inmediatamente la credencial.

Además, almacenar contraseñas como texto claro provoca que una filtración de la base de datos pueda convertirse directamente en una filtración de credenciales.

### Preguntas
1. **¿Son iguales?**

No, ambas salidas de la ejecuciones son diferentes, a pesar de haber ejecutado la misma instrucción y la misma contraseña.

2. **Si no son iguales, ¿por qué?**

Esto sucede porque gen_salt() genera un valor aleatorio único cada vez que se ejecuta la instrucción. crypt() incluye tanto la contraseña hasheada como salt aleatorio utilizado, el hash final cambia por completo cada vez que se realiza la instrucción.

3. **¿Qué función cumple gen_salt()?**

Genera una cadena aleatoria criptografica utilizando un algoritmo especifico, en los resultados obtenidos 'bf'.

4. **¿Qué función cumple crypt()?**

Hashea una cadena de texto como en este caso una contraseña, al combinarse con el salt utilizando un algoritmo de cifrado unidireccional. Ademas tiene otro uso como para verificar credenciales comparando la contraseña ingresada por el usuario con el hash almacenado.

5. **¿Esto es cifrado reversible?**

No, no es reversible, se trata de un hash criptografico unidireccional, no existe una función inversa que permita recuperar el texto plano a partir del has generado. Para validar un login, el sistema vuelve a calcular el hash de la contraseña ingresada y compara si coincide con el almacenado.

## Crear una tabla para credenciales protegidas
## Verificar una contraseña
### Preguntas

1. **¿Qué resultado obtuviste con la contraseña correcta?**

Se obtuvo 't'.
2. **¿Qué resultado obtuviste con la contraseña incorrecta?**

Se obtuvo 'f'.
3. **¿Por qué no es necesario recuperar la contraseña original?**

Porque el proposito del sistema de autenticación es verificar la identidad, no de recordar la contraseña. Cuando se inicia sesión, el sistema no necesita saber cuál es la contraseña de texto plano, solo debe de comprobar si la contraseña que el usuario escribe al momento de ser pasada por crypt(), produciendo el mismo hash que ya está guardado.
4. **¿Por qué un hash no debe confundirse con cifrado?**

Porque es hash es irreversible al ser una función matematíca que convierte una entrada de cualquier tamaño en una cadena de longitud fija, mientras que el cifrado si puede ser reversible ya que transforma los datos.

## Consideración para aplicaciones reales

El mecanismo anterior se utiliza aquí para demostrar el concepto dentro de PostgreSQL.

En una aplicación real, la selección del algoritmo para proteger contraseñas debe realizarse considerando las recomendaciones actuales de seguridad y las capacidades del framework utilizado.

No debes implementar tu propio algoritmo de hash.

Tampoco debes:
```
guardar contraseñas en texto claro
```
ni:
```
cifrar contraseñas con una clave fija y almacenarlas como si fueran datos recuperables
```
