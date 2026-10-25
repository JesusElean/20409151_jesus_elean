# Actividad 2 — Principio de minimización
Supongamos que el área de atención al cliente solicita crear una nueva tabla:
```sql
CREATE TABLE clientes_soporte (
    id BIGSERIAL,
    nombre VARCHAR(120),
    correo VARCHAR(150),
    telefono VARCHAR(20),
    rfc VARCHAR(13),
    edad INTEGER,
    ciudad VARCHAR(80),
    codigo_postal VARCHAR(10),
    fecha_alta DATE
);
```

Analiza la solicitud.

### Preguntas
1. **¿Todos los campos son necesarios para atención al cliente?**

No. La gran mayoría de los campos como el rfc, edad, ciudad, codigo_postal no son necesarios para la operación diaria de un departamento de soporte general. Solo se requieren los datos mínimos de identificación y contacto como el id, nombre, correo, telefono y los metadatos de control como la fecha_alta.

2. **¿Por qué soporte necesitaría conocer el RFC?**

Únicamente se justificaría si el área de soporte maneja un módulo especializado en facturación, aclaraciones fiscales o problemas con comprobantes de pago. Si es un soporte técnico o de atención general, el personal no debe tener acceso al RFC, ya que es un dato fiscal altamente sensible y exponerlo incrementa los riesgos de seguridad y robo de identidad.

3. **¿Necesita conocer la edad?**

No. La edad no aporta ningún valor para la resolución de incidencias, dudas o problemas técnicos de un cliente, por lo que almacenarla en esta tabla representa una recolección injustificada de datos personales.

4. **¿Necesita conocer el código postal?**

No por regla general. Solo sería necesario si el caso de soporte estuviera directamente vinculado a la logística de envíos físicos, cobertura de servicios locales o disponibilidad de técnicos en una zona específica. Para soporte digital, remoto o general, es un dato irrelevante.

5. **¿Qué principio de privacidad está relacionado con esta decisión?**

Está relacionado principalmente con el principio de minimización de datos y el principio de finalidad. Este principio dicta que los datos personales objeto de tratamiento deben ser adecuados, relevantes y limitados a lo necesario en relación con los fines para los cuales son procesados. En otras palabras: si no se necesita para resolver el problema del cliente, no se debe solicitar ni almacenar.

## Diseñar una estructura mínima
Crea una tabla que contenga únicamente los datos necesarios para la finalidad de soporte:
```sql
CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);
```

Carga información a partir de `clientes`:
```sql
INSERT INTO clientes_soporte (
    id,
    nombre,
    correo,
    telefono
)
SELECT
    id,
    nombre,
    correo,
    telefono
FROM clientes;
```

Consulta:
```sql
SELECT *
FROM clientes_soporte;
```
---
# Actividad 3 — Separación por finalidad
Ahora el área de analítica solicita información para obtener estadísticas.

Analítica necesita:

* ciudad
* rango de edad
* región del código postal

No necesita:

* nombre
* correo
* teléfono
* RFC

Diseña una consulta que proporcione información agregada:
```sql
SELECT
    ciudad,
    COUNT(*) AS cantidad_clientes
FROM clientes
GROUP BY ciudad
ORDER BY cantidad_clientes DESC;
```
Ahora crea rangos de edad:
```sql
SELECT
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad,
    COUNT(*) AS cantidad
FROM clientes
GROUP BY
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END
ORDER BY rango_edad;
```

### Pregunta

**¿Por qué esta información puede ser más apropiada para analítica que entregar directamente la tabla completa de clientes?**
Proporcionar datos agregados y anonimizados es más apropiado porque cumple con el principio de minimización y disociación de datos, garantizando que el área de analítica obtenga exactamente la información demográfica necesaria para la toma de decisiones sin exponer Datos de Identificación Personal (PII) como nombres, correos o teléfonos. Esto reduce drásticamente el riesgo ante posibles fugas de seguridad, protege la privacidad del cliente al evitar que un usuario individual sea identificable y optimiza el rendimiento del procesamiento de datos al trabajar directamente con métricas grupales en lugar de registros individuales innecesarios.
---
# Actividad 4 — Control de acceso relacionado con la finalidad

Crea un rol:
```sql
CREATE ROLE analista NOLOGIN;
```
Otorga únicamente acceso a la información preparada para analítica.

Por ejemplo, crea una vista:
```sql
CREATE VIEW v_analitica_clientes AS
SELECT
    ciudad,
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad
FROM clientes;
```
Otorga permisos:
```sql
GRANT USAGE ON SCHEMA public TO analista;

GRANT SELECT
ON v_analitica_clientes
TO analista;
```
No otorgues:
```sql
GRANT SELECT ON clientes TO analista;
```
## Verificación
Comprueba los privilegios:
```sql
SELECT
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analista';
```
### Preguntas

1. **¿Qué información puede consultar el rol?**

El rol analista puede consultar exclusivamente la información expuesta a través de la vista `v_analitica_clientes` los campos `ciudad` y `rango_edad` y, debido a un privilegio previo heredado que se observa en la verificación, también tiene acceso directo a toda la tabla `clientes`.

2. **¿Puede consultar directamente clientes?**

Sí, actualmente puede hacerlo debido a que el resultado de la consulta en `information_schema.role_table_grants` muestra un permiso de `SELECT` directamente sobre la tabla `clientes` para el grantee `analista`. 

3. **¿Puede obtener nombre, correo y RFC?**

Sí, de forma indirecta y completa. Aunque la vista oculta esos campos, al tener un permiso de SELECT activo directamente sobre la tabla clientes, el rol analista puede consultar la tabla entera y ver los nombres, correos, RFCs y teléfonos de los usuarios.

4. **¿Qué principio de privacidad estás aplicando?**

El principio de minimización y finalidad, el cual busca limitar el acceso a los datos estrictamente a lo necesario para cumplir con el propósito del rol en este caso, solo estadísticas demográficas sin identificar personas.

5. **¿Qué principio de seguridad estás aplicando?**

El principio de menor privilegio (Least Privilege), que establece que a un usuario, rol o proceso se le deben conceder únicamente los permisos indispensables y mínimos necesarios para realizar sus funciones asignadas, bloqueando todo lo demás por defecto.

---
# Actividad 5 — Analizar una finalidad secundaria

La empresa propone utilizar los datos de clientes para una nueva finalidad:

> “Enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra.”* 

Analiza la situación.

Responde:
1. **¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?**

No. Bajo las leyes de protección de datos personales como la LFPDPPP en México o el RGPD en Europa, rige el principio de finalidad. Esto significa que los datos recabados para un propósito específico por ejemplo, registro inicial o soporte no pueden utilizarse para una finalidad secundaria distinta o incompatible como marketing o prospección comercial a menos que se informe previamente al titular y se obtenga su consentimiento expreso generalmente mediante un mecanismo de opt-in.

2. **¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?**

¿Es compatible el nuevo propósito?, ¿El envío de promociones guarda una relación lógica y razonable con la finalidad original por la cual el usuario entregó sus datos?, ¿Se cuenta con el consentimiento del titular?, ¿El aviso de privacidad original contemplaba el tratamiento de datos para fines mercadotécnicos o se requiere recabar un nuevo consentimiento?, ¿Existe un mecanismo de oposición (opt-out)?, ¿Se le ofrece al cliente una forma fácil, gratuita y accesible para revocar su consentimiento para recibir publicidad sin afectar el servicio principal?, ¿Es proporcional?, ¿El beneficio comercial justifica el nivel de intrusión en la privacidad del usuario?

3. **¿Qué datos serían realmente necesarios?**

Para ejecutar campañas de marketing segmentadas no se requiere el expediente completo del cliente. Los datos estrictamente necesarios son:
* Ubicación general: ciudad o estado (para ofertas locales o regionales).
* Segmentación demográfica: rango de edad o categoría de cliente.
* Comportamiento de compra: Historial de categorías preferidas, frecuencia de compra o ticket promedio (preferiblemente de forma estadística o agregada).
* Datos de contacto (solo al momento del envío): El correo o teléfono, pero gestionados de forma automatizada por la plataforma de envío, sin que el equipo de marketing tenga que exponer o manipular la base de datos completa.

4. **¿Necesitaría el área de marketing acceso directo a clientes?**

No. Otorgar al área de marketing acceso directo a la tabla transaccional o a los datos de identificación personal (PII) vulnera el principio de menor privilegio. El equipo de marketing requiere métricas de segmentación y listas de envío procesadas, no consultar nombres, teléfonos o RFCs uno por uno. Su interacción debe darse a través de plataformas de CRM o vistas acotadas.

5. **¿Qué controles técnicos podrían limitar la información entregada?**

* Vistas dedicadas de marketing (VIEW): Crear consultas predefinidas que solo devuelvan segmentos demográficos y preferencias de consumo, excluyendo información sensible.
* Roles y Permisos restrictivos: Asignar un rol de base de datos específico para marketing con permisos únicamente sobre vistas o esquemas de analítica comercial, bloqueando el acceso a tablas transaccionales de clientes.
* Integración vía API o CRM: Conectar las herramientas de envío de correos (ej. Mailchimp, SendGrid) mediante APIs seguras que utilicen identificadores internos o tokens, manteniendo los datos resguardados en el backend principal.
* Enmascaramiento y seudonimización: Ocultar los datos de contacto directos en los reportes comerciales compartidos internamente.

Guarda tu análisis en:
```
evidencias/05-finalidad-secundaria.md
```
