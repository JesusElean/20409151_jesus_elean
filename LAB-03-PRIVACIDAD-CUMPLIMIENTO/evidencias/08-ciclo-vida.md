# Actividad 6 — Derechos ARCO y la base de datos

Los derechos ARCO son:
```
A → Acceso
R → Rectificación
C → Cancelación
O → Oposición
```
El DBA debe comprender que una solicitud de derechos ARCO puede tener implicaciones técnicas en la base de datos, aunque la respuesta jurídica y administrativa corresponda a las áreas responsables de privacidad y cumplimiento.
## Derecho de acceso
Supongamos que un titular solicita conocer los datos personales que la organización tiene registrados.

Identifica qué consulta permitiría localizar su información.

Ejemplo:
```sql
SELECT
    id,
    nombre,
    correo,
    telefono,
    rfc,
    edad,
    ciudad,
    codigo_postal,
    fecha_alta
FROM clientes
WHERE correo = 'ana@example.com';
```
### Pregunta

**¿Qué información adicional debería proporcionar la organización además del resultado de esta consulta?**

Desde una perspectiva técnica y operativa, la organización no solo debe entregar los datos planos devueltos por la consulta SQL, sino también contexto y metadatos técnicos que garanticen la transparencia del tratamiento:
* Origen y fuentes de los datos: De dónde se obtuvieron los datos registrados (si fueron proporcionados directamente por el titular, recolectados mediante formularios web o integrados de terceros).

* Finalidades del tratamiento: Para qué se están utilizando específicamente esos datos dentro de los sistemas de la empresa.

* Destinatarios o transferencias: Con qué áreas internas, proveedores o sistemas externos se han compartido o sincronizado esos registros (por ejemplo, pasarelas de pago, herramientas de soporte o plataformas de envío).

* Tiempo de conservación: El plazo previsto de retención de los datos o los criterios utilizados para determinarlo.

No necesitas resolver jurídicamente la solicitud.

Identifica las implicaciones técnicas.

---

# Actividad 7 — Derecho de rectificación

Supongamos que un cliente informa:

    > “Mi correo electrónico registrado es incorrecto.”

Actualiza únicamente el dato correspondiente:
```sql
UPDATE clientes
SET correo = 'nuevo-correo@example.com'
WHERE id = 1;
```
Verifica:
```sql
SELECT
    id,
    nombre,
    correo
FROM clientes
WHERE id = 1;
```
### Preguntas

**¿Cómo podría comprobarse que el cambio fue autorizado?**

Mediante mecanismos de autenticación y validación de identidad previos por ejemplo, confirmación por el canal oficial de origen con token temporal, verificación de identidad mediante credenciales activas o un ticket de solicitud firmado/verificado en la plataforma de soporte. El sistema de base de datos por sí solo no valida la autenticidad del cambio, por lo que se requiere un registro de auditoría externo o una bitácora de validación.

**¿Debería registrarse quién realizó el cambio?**

Sí. Es fundamental para la trazabilidad operativa y de seguridad saber si la modificación la realizó el propio usuario a través de un portal de autogestión, un operador de soporte tras una solicitud validada, o un administrador de base de datos ejecutando una tarea correctiva.

**¿Por qué la trazabilidad será importante?**

Porque permite responder ante auditorías de cumplimiento, investigar posibles modificaciones no autorizadas como un ataque o un error humano malintencionado y demostrar legalmente que la organización actuó conforme a las instrucciones del titular de los datos.


Esta última pregunta será retomada en la Unidad III.

# Actividad 8 — Derecho de cancelación y ciclo de vida

Supongamos que una solicitud de cancelación ha sido autorizada por el área responsable.

No realices todavía un `DELETE` sobre la tabla principal.

Primero analiza:

* **¿Existen otras tablas relacionadas?**

* **¿Existen respaldos?**

* **¿Existen réplicas?**

* **¿Existen registros de auditoría?**

* **¿Existen copias utilizadas para analítica?**

* **¿Existen archivos exportados?**

* **¿Existen sistemas externos?**

Construye un pequeño mapa:
```sql
clientes
   │
   ├── respaldos
   ├── réplicas
   ├── reportes
   ├── exportaciones
   └── sistemas externos
```
### Pregunta

**¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?**

Eliminar un registro mediante una sentencia `DELETE` en la tabla transaccional o principal como la tabla `clientes` borra la fila activa de ese entorno específico, pero los datos personales suelen persistir en múltiples capas del ecosistema tecnológico de la organización:

1. **Copias de Respaldo (Backups):** Los respaldos programados (diarios, semanales o mensuales) almacenan una instantánea de la base de datos en un momento determinado. El registro seguirá existiendo en esos archivos históricos hasta que se complete el ciclo de rotación y depuración de los respaldos.
2. **Réplicas de Bases de Datos:** En arquitecturas de alta disponibilidad (lectura/escritura), la operación de eliminación se propaga rápidamente, pero las réplicas asíncronas o de aislamiento temporal pueden mantener el dato hasta que se sincronice el clúster.
3. **Tablas Relacionadas y Dependencias:** Si existen restricciones de integridad referencial sin borrado en cascada `ON DELETE CASCADE`, o tablas históricas de auditoría, logs de transacciones `WAL` / *Write-Ahead Logs*, y registros de actividad, el rastro del usuario continuará almacenado en esos componentes.
4. **Sistemas Externos y Caché:** Copias de los datos pueden haber sido exportadas a plataformas de terceros, herramientas de analítica *Business Intelligence*, sistemas de CRM, o cacheadas en servidores intermedios y archivos temporales `.csv`, reportes en PDF.

Por esta razón, la "cancelación" o el derecho al olvido técnico requiere un procedimiento.

Guarda tu respuesta en:
```
evidencias/08-ciclo-vida.md
```
