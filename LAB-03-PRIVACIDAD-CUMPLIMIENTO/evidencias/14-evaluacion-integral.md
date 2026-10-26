# Actividad 13 — Diferenciar controles técnicos y administrativos
Clasifica las siguientes medidas:

|Medida|Técnico|Administrativo|
|------|-------|--------------|
|Crear roles de PostgreSQL|X||
|Política de retención||X|
|Cifrado de datos|X||
|Procedimiento para solicitudes ARCO||X|
|Vista con información limitada|X||
|Clasificación de información|X|X|
|Registro de auditoría|X|X|
|Política de control de acceso||X|

Algunas medidas pueden involucrar ambos tipos de control.
Cuando ocurra esto, justifica tu respuesta.

**Clasificación de información:** Es Administrativo porque requiere una política que defina los niveles (Público, Confidencial, etc.) y Técnico porque se aplica mediante etiquetas, metadatos y controles de acceso en la base de datos.

**Registro de auditoria:** Es Técnico por la configuración de módulos de registro/logs en el SGBD y Administrativo por la política que exige su revisión periódica y custodia legal.

---

# Actividad 14 — Escenario integral

Considera la siguiente situación:

    > La empresa tiene una base de datos con información de 50,000 clientes. 
    > Todos los empleados del área de analítica pueden consultar directamente la tabla clientes.
    > La tabla contiene nombre, correo, teléfono, RFC, edad, ciudad y código postal.
    > El área de analítica únicamente genera estadísticas mensuales.
    > Los datos se conservan desde hace 12 años.
    > No existe una política documentada de retención.
    > Los desarrolladores reciben copias completas de la base de datos para realizar pruebas.
    > Las copias de desarrollo contienen información real.
    > El área de marketing utiliza los correos electrónicos para campañas promocionales.
    > No existe documentación clara sobre qué finalidad corresponde a cada dato.

Identifica al menos **10 problemas o riesgos**.

Para cada uno indica:


| Problema | Principio afectado | Riesgo | Control propuesto |
| :--- | :--- | :--- | :--- |
| **Acceso directo de analítica a la tabla `clientes`** | Menor Privilegio / Minimización | Exposición innecesaria de PII a personal no autorizado para ver datos de contacto o identificación. | Restringir el acceso a la tabla original y crear vistas agregadas o anónimas específicas para analítica. |
| **Consultas de PII (nombre, RFC, teléfono) para reportes mensuales** | Minimización de Datos / Disociación | Fuga o mal uso de información personal identificable cuando solo se requieren agregaciones estadísticas. | Implementar la técnica de agregación y disociación mediante vistas SQL que solo muestren métricas demográficas (`COUNT`, rangos). |
| **Conservación de datos por 12 años sin justificación** | Limitación del Plazo de Conservación / Retención | Infracción legal por almacenamiento indefinido, aumento del impacto en una eventual filtración y costos de infraestructura. | Definir e implementar una política de retención de datos con fases de archivo, bloqueo y depuración periódica. |
| **Ausencia de una política de retención documentada** | Responsabilidad Proactiva (*Accountability*) / Legalidad | Incapacidad de demostrar cumplimiento normativo ante auditorías y falta de criterios claros para la purga de datos. | Redactar, documentar y formalizar la Política de Retención y Depuración de Datos Personales aprobada por la dirección/legal. |
| **Copias completas de la BD con datos reales entregadas a desarrolladores** | Seguridad de los Datos (Confidencialidad) | Exposición masiva de datos en entornos de desarrollo/pruebas, típicamente con menores controles de seguridad que producción. | Implementar procesos de anonimizacion, seudonimización o enmascaramiento de datos (*Data Masking*) para entornos no productivos. |
| **Uso de correos para campañas promocionales sin consentimiento documentado** | Finalidad y Consentimiento | Sanciones administrativas por enviar marketing no solicitado (*spam*) y violar las finalidades informadas al usuario. | Implementar mecanismos de *opt-in* explícito, banderas de consentimiento en la base de datos y un registro de oposición/exclusión. |
| **Falta de documentación sobre la finalidad de cada dato** | Transparencia / Principio de Finalidad | Imposibilidad de justificar la legitimidad de la recolección ante los titulares y las autoridades reguladoras. | Elaborar un Inventario/Registro de Actividades de Tratamiento (RAT) y la Matriz de Gobierno de Datos. |
| **Falta de enmascaramiento de datos fiscales (`RFC`) en consultas generales** | Confidencialidad / Privacidad por Defecto | Visualización de datos fiscales sensibles por roles que no tienen tareas contables o de facturación. | Implementar reglas de enmascaramiento dinámico de datos (*Dynamic Data Masking*) y permisos limitados solo al rol de facturación. |
| **Ausencia de controles de acceso basados en roles (RBAC)** | Menor Privilegio / Seguridad | Modificación o extracción no autorizada de datos debido a sobreasignación de privilegios directos a usuarios individuales. | Diseñar e implementar roles bien definidos (`analista`, `soporte`, `facturacion`) con permisos concedidos exclusivamente sobre objetos específicos. |
| **Falta de trazabilidad y registros de auditoría sobre consultas a datos sensibles** | Responsabilidad Proactiva / Trazabilidad | Incapacidad de detectar exfiltraciones internas de información o saber qué usuario accedió a un expediente específico. | Activar logs de auditoría en la base de datos (p. ej. `pgaudit` en PostgreSQL) para registrar accesos y operaciones `SELECT` en tablas sensibles. |

Guarda la matriz en:
```
evidencias/14-evaluacion-integral.md
```
