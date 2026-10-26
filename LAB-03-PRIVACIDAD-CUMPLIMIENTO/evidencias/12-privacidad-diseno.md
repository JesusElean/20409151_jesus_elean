# Actividad 12 — Privacidad por diseño

Analiza el siguiente escenario:

Una nueva aplicación requiere registrar clientes.

El desarrollador propone:
```sql
CREATE TABLE clientes (
    id BIGSERIAL,
    nombre TEXT,
    correo TEXT,
    telefono TEXT,
    rfc TEXT,
    edad INTEGER,
    direccion TEXT,
    ciudad TEXT,
    codigo_postal TEXT,
    fecha_nacimiento DATE,
    ocupacion TEXT,
    salario NUMERIC,
    estado_civil TEXT,
    ...
);
```
La justificación es:

    > “Es mejor guardar todos los datos por si posteriormente necesitamos alguno.”

### Preguntas
1. **¿Qué problemas identificas?**

* Sobre-recolección de Datos Personales Sensibles y Financieros: Se están solicitando campos como salario, ocupacion, estado_civil y fecha_nacimiento sin un propósito operativo o de negocio claro desde el inicio.

* Redundancia de Información: Se solicita tanto edad como fecha_nacimiento. Mantener ambos campos crea inconsistencias de datos, ya que la edad cambia con el tiempo mientras que la fecha de nacimiento es estática.

* Exposición a Riesgos de Fuga de Información: Almacenar datos financieros (salario) y fiscales (rfc) innecesarios convierte la base de datos en un objetivo de alto valor para atacantes y aumenta la responsabilidad legal de la empresa.

* Falta de Tipos de Datos y Restricciones Adecuadas: El uso generalizado de TEXT sin restricciones de longitud ni restricciones de unicidad (UNIQUE en correo o RFC) degrada la calidad de los datos.

2. **¿Qué principio de privacidad se está ignorando?**

Se está ignorando completamente el Principio de Minimización de Datos y la metodología de Privacidad por Diseño y por Defecto, el cual dicta que solo se deben recolectar y tratar los datos estrictamente necesarios para cumplir con la finalidad específica del servicio prestado.

La justificación "es mejor guardar todos los datos por si posteriormente necesitamos alguno" es una práctica contraria a las normativas de privacidad (LFPDPPP, RGPD) y eleva el riesgo sin justificación.

3. **¿Qué preguntas realizarías antes de aprobar el diseño?**

* ¿Cuál es el modelo de negocio básico y el flujo principal de la aplicación? (¿Es un e-commerce, una red social, una plataforma de streaming o un servicio financiero?)

* ¿Para qué proceso específico se necesita el dato de salario, ocupacion y estado_civil? ¿Aportan valor al servicio primario solicitado por el usuario?

* ¿Cuál es el fundamento legal o contractual para solicitar el rfc en la etapa inicial de registro?

* ¿Realmente se requiere la fecha_nacimiento completa o solo verificar si el usuario es mayor de edad?

* ¿Existe un aviso de privacidad actualizado que informe de manera clara y explícita el tratamiento de cada uno de estos campos?

4. **¿Qué datos eliminarías?**

Para una aplicación general o estandarizada, eliminaría de la tabla principal de registro los siguientes campos:

* `salario`
* `estado_civil`
* `ocupacion`
* `edad` (se elimina por redundante; si se requiere verificar la edad, se conserva la fecha de nacimiento o un indicador booleano)

5. **¿Qué datos requerirían una justificación adicional?**

* `rfc:` Solo se debe solicitar si el cliente va a generar una factura o requiere comprobantes fiscales por transacciones.
* `direccion` completa: Solo necesaria si la aplicación involucra envío de productos físicos o servicios a domicilio. Si es un servicio 100% digital, con `ciudad` o `codigo_postal` (o ninguno de los dos) suele ser suficiente.
* `fecha_nacimiento`: Requiere justificación si el servicio está sujeto a restricciones de edad o regulación legal específica.

6. **¿Cómo aplicarías privacidad por defecto?**

* Formulario de Registro Mínimo: Configurar la interfaz y el modelo de datos para solicitar de entrada únicamente los campos estrictamente esenciales para crear la cuenta (nombre, correo y una credencial de autenticación segura).

* Campos Opcionales y Solicitud Gradual (Progressive Profiling): Solicitar datos adicionales (direccion, rfc) únicamente en el momento exacto en que el usuario requiera una función específica ej. al momento de procesar un envío o generar una factura.

* Separación de Esquemas: Mantener los datos financieros o sensibles en tablas o servicios independientes con acceso restringido y cifrado a nivel de columna.

* Desactivación de Casillas Preseleccionadas: Asegurar que cualquier finalidad secundaria como envío de promociones o boletines requiera una acción afirmativa del usuario (opt-in explícito), nunca marcado por defecto.

Guarda el análisis en:
```
evidencias/12-privacidad-diseno.md
```
