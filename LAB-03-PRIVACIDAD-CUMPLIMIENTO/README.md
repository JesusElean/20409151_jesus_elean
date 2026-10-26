# Informe final
## 1. Introducción
En el desarrollo y administración de sistemas de bases de datos, tradicionalmente se ha puesto un énfasis casi exclusivo en la disponibilidad, rendimiento y seguridad técnica contra accesos externos no autorizados. Sin embargo, la acumulación desmedida de información personal y la falta de un marco de gobernanza adecuado han puesto de manifiesto graves problemas de privacidad. 

El problema abordado en este proyecto radica en la gestión inadecuada de los Datos de Identificación Personal (PII) recopilados por las organizaciones. Se diagnosticaron prácticas de riesgo habituales, tales como la sobre-recolección de campos sensibles, el uso indiscriminado de datos para finalidades no autorizadas (como campañas de marketing sin consentimiento), la conservación indefinida de registros históricos y el acceso irrestricto de distintas áreas operativas a bases de datos transaccionales completas. Este informe documenta la transformación de una arquitectura vulnerable hacia un modelo basado en los principios de **Minimización**, **Privacidad por Diseño**, **Control de Acceso basado en Funciones (RBAC)** y **Gobierno de Datos**.

---

## 2. Inventario de Datos y Clasificación
A continuación se presenta la clasificación de los atributos identificados en la base de datos de clientes, evaluando su condición de dato personal y su nivel de confidencialidad:

| Campo | ¿Es Dato Personal? | Tipo / Naturaleza | Nivel de Confidencialidad |
| :--- | :---: | :--- | :--- |
| `id` | **No** | Identificador interno del sistema / Clave primaria. | Interno / Sistema |
| `nombre` | **Sí** | Dato de identificación personal (PII). | Restringido / Operativo |
| `correo` | **Sí** | Dato de contacto / Autenticación. | Restringido / Soporte |
| `telefono` | **Sí** | Dato de contacto personal. | Confidencial / Seguridad |
| `rfc` | **Sí** | Dato fiscal / Identificador legal único. | Altamente Confidencial |
| `edad` / `fecha_nacimiento` | **Sí** | Dato demográfico. | Restringido |
| `ciudad` | **Sí** | Dato de ubicación geográfica. | Público / General |
| `codigo_postal` | **Sí** | Dato de ubicación y logística. | Restringido / Logística |
| `fecha_alta` | **No** | Metadato de auditoría del sistema. | Interno / Sistema |

---

## 3. Finalidades del Tratamiento
Los datos personales únicamente deben ser tratados para los propósitos específicos, informados y autorizados por el titular:

* **Atención al Cliente y Soporte:** Utiliza `id`, `nombre`, `correo` y `telefono` para la gestión de solicitudes, autenticación de identidad y resolución de incidencias del servicio.
* **Facturación y Finanzas:** Requiere el `rfc`, `nombre` y `codigo_postal` exclusivamente para el cumplimiento de obligaciones tributarias y la emisión de comprobantes fiscales digitalizados (CFDI).
* **Analística de Negocio e Inteligencia Commercial:** Emplea datos disociados y agregados como `ciudad` y `rango_edad` para obtener estadísticas de mercado sin identificar individualmente a los usuarios.
* **Marketing y Promociones (Finalidad Secundaria):** Utiliza `correo` o `telefono` **únicamente** si se cuenta con el consentimiento explícito (*opt-in*) del titular y mecanismos activos de oposición (*opt-out*).

---

## 4. Minimización de Datos
El principio de minimización establece que se deben recolectar y almacenar únicamente los datos estrictamente necesarios para cumplir con la finalidad informada.

* **Datos a Eliminar o Limitar:**
  * **`edad` / `fecha_nacimiento`:** Se eliminó el campo de enteros `edad` por ser redundante y degradar la calidad con el tiempo. Para soporte no se requiere; para analítica se transforma en vistas agregadas (`rango_edad`); y para verificación de mayoría de edad solo debe almacenarse una bandera booleana o pedir la fecha de nacimiento en casos estrictamente regulados.
  * **`salario`, `ocupacion` y `estado_civil`:** Se eliminaron del esquema de registro general por ser sobre-recolecciones sin justificación operativa que incrementaban el riesgo de exposición de PII sensible.
* **Limitación por Esquema:** El área de soporte ya no accede a la tabla `clientes` completa, sino a `clientes_soporte`, reduciendo el impacto ante filtraciones.

---

## 5. Control de Acceso Relacionado con la Finalidad
El acceso a los datos se configuró aplicando el **Principio de Menor Privilegio (*Least Privilege*)**, garantizando que cada rol operativo únicamente pueda consultar los campos que requieren sus funciones:

* **Rol `soporte`:** Tiene acceso restringido a la tabla `clientes_soporte` (`id`, `nombre`, `correo`, `telefono`). No posee permisos sobre datos fiscales (`rfc`) ni geográficos.
* **Rol `analista`:** No tiene acceso de lectura directo a la tabla transaccional `clientes`. Únicamente se le concedieron permisos de consulta (`SELECT`) sobre la vista disociada `v_analitica_clientes` que presenta datos agregados (`ciudad` y `rango_edad`).
* **Rol `facturacion`:** Accede de forma aislada a las vistas o campos de identificación fiscal (`rfc`, `nombre`, `codigo_postal`).

---

## 6. Derechos ARCO e Implicaciones Técnicas
La atención a las solicitudes de Derechos ARCO (Acceso, Rectificación, Cancelación y Oposición) genera requisitos técnicos indispensables en la base de datos:

* **Acceso:** Implica diseñar funciones almacenadas que extraigan la totalidad de los datos e historiales asociados al titular en todas las tablas del ecosistema y los entreguen en formatos estructurados (JSON/CSV).
* **Rectificación:** Exige actualizar datos de manera transaccional y registrar la modificación en bitácoras de auditoría, indicando el usuario, la fecha y el origen del cambio para mantener la trazabilidad.
* **Cancelación:** Requiere un procedimiento integral que va más allá de un `DELETE` en la tabla activa. Involucra depurar réplicas, purgar o marcar con bloqueo (*LOCKED*) en respaldos históricos, cancelar en sistemas de analítica externos y registrar al usuario en una lista de exclusión (*Suppression List*).
* **Oposición:** No elimina el registro principal, pero requiere la implementación técnica de banderas de consentimiento (`acepta_marketing = FALSE`) y vistas filtradas para evitar el tratamiento no deseado.

---

## 7. Política de Retención
El periodo de conservación de los datos debe determinarse mediante la convergencia de criterios legales, fiscales y operativos, prohibiendo estrictamente el almacenamiento indefinido.

1. **Fase Activa:** Conservación de datos mientras la relación contractual o la cuenta del usuario permanezca vigente.
2. **Fase de Bloqueo / Archivo (`LOCKED`):** Al finalizar la relación, los datos fiscales (`rfc`, facturas) se trasladan a un esquema de solo lectura accesible únicamente por auditoría/contabilidad durante 5 años (conforme a los requerimientos del Código Fiscal).
3. **Depuración o Anonimización Definitiva:** Al concluir el plazo legal, se ejecutan tareas programadas (`pg_cron`) para eliminar de forma segura los PII o anonimizar los registros para conservar métricas estadísticas históricas disociadas.

---

## 8. Gobierno de Datos — Matriz de Responsabilidades

| Dato | Finalidad | Responsable de Negocio | Usuarios Autorizados | Mecanismo de Protección | Retención | Acción Final |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`nombre`** | Identificación y servicio | Atención al Cliente | Soporte, Facturación, DBA | Cifrado en reposo / ACL | Contrato + 5 años fiscal | Borrado seguro |
| **`correo`** | Autenticación y contacto | TI / Soporte | Soporte, DBA | Cifrado / Control RBAC | Cuenta activa + 1 año | Borrado seguro |
| **`telefono`** | Validación y 2FA | Seguridad de la Info | Soporte, DBA | Enmascaramiento parcial UI | Cuenta activa | Borrado inmediato |
| **`rfc`** | Facturación | Finanzas | Facturación, DBA | Cifrado a nivel columna / Audit Log | 5 años (Fiscal) | Borrado definitivo |
| **`edad`** | Segmentación estadística | Analítica | Analítica *(como rango)*, DBA | Disociación en Vistas | Cuenta activa | Anonimización |
| **`ciudad`** | Análisis de cobertura | Mercadotecnia | Analítica, Soporte, DBA | Vistas agregadas | Duración comercial | Anonimización |
| **`codigo_postal`**| Logística e impuestos | Operaciones | Facturación, Logística, DBA | Vistas restrictivas | Contrato o venta | Borrado / Agregación |

---

## 9. Evaluación Integral de Riesgos

| Problema Identificado | Principio Afectado | Riesgo Asociado | Control Propuesto |
| :--- | :--- | :--- | :--- |
| Acceso directo de analítica a la tabla `clientes`. | Menor Privilegio | Fuga de PII por consultas no restringidas. | Crear vistas agregadas (`v_analitica_clientes`) y revocar permisos sobre la tabla principal. |
| Entregas de copias con datos reales a desarrollo. | Confidencialidad / Seguridad | Exposición masiva de PII en entornos no productivos de bajo control. | Aplicar herramientas de anonimización y enmascaramiento dinámico (*Data Masking*). |
| Uso de correos para marketing sin consentimiento. | Finalidad / Consentimiento | Sanciones legales por envio de publicidad no solicitada (*spam*). | Implementar casillas de *opt-in* explícito y filtros por banderas de consentimiento. |
| Retención de datos por 12 años sin política. | Limitación del Plazo | Aumento del impacto ante hackeos y faltas administrativas legales. | Crear e implementar una Política de Retención y Depuración Programada. |
| Ausencia de registros de auditoría sobre lecturas PII. | Trazabilidad / Accountability | Incapacidad de rastrear exfiltraciones internas de información. | Habilitar el módulo `pgaudit` en PostgreSQL sobre consultas operativas a datos sensibles. |

---

## 10. Conclusiones
El desarrollo de esta actividad demostró que la seguridad de la información y la privacidad de datos no son sinónimos, sino conceptos complementarios e interdependientes. La seguridad proporciona las defensas técnicas (cifrado, firewalls, autenticación), pero la privacidad define los límites legales y éticos sobre el ciclo de vida del dato.

Como administradores de bases de datos, aprendimos que las decisiones de diseño tienen un impacto directo en el cumplimiento normativo. La aplicación de la **Privacidad por Diseño** permite traducir principios legales abstractos (minimización, finalidad, menor privilegio) en objetos técnicos concretos (vistas disociadas, esquemas separados, scripts de purga automatizados y roles RBAC). El DBA debe evolucionar de ser un ejecutor de consultas a ser un custodio técnico dentro de un marco formal de gobierno de datos.

---

## 27. Preguntas de Reflexión

### 1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?
**No.** Una base de datos puede estar fuertemente protegida contra ciberataques (con cifrado robusto y firewalls), pero violar la privacidad si recolecta datos innecesarios, los retiene indefinidamente o los utiliza para finalidades no autorizadas por el usuario. La seguridad protege el dato contra terceros; la privacidad garantiza el trato justo y legítimo al titular del dato.

### 2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?
Porque limita la exposición de los datos personales identificables (PII) únicamente a los usuarios y procesos que los necesitan para cumplir con una tarea específica. Al restringir los accesos directos, se reduce drásticamente el riesgo de filtraciones por error humano, curiosidad o mal uso interno.

### 3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?
Porque el DBA gestiona la infraestructura técnica, pero carece del contexto de negocio, legal y regulatorio para determinar la licitud de un tratamiento. Las finalidades deben ser definidas por el propietario del dato (*data owner*), el área jurídica y el oficial de privacidad (DPO), quienes conocen las obligaciones legales y los avisos de privacidad aceptados por los clientes.

### 4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?
Porque los entornos de desarrollo y pruebas suelen tener políticas de seguridad más laxas, accesos compartidos y están expuestos en redes internas con menor supervisión. Entregar datos reales expone la PII de miles de clientes de forma innecesaria a riesgos de filtración.

### 5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?
Porque contiene información real de personas físicas que puede ser extraída, copiada en equipos locales no cifrados o expuesta en repositorios de código. Ante la ley, una fuga de datos en un ambiente de desarrollo es tan grave como una brecha en el servidor de producción.

### 6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?
Porque la información no debe existir en los sistemas de forma perpetua. Definir fases de almacenamiento activo, archivo temporal/bloqueo y purga definitiva evita costos innecesarios, mantiene la calidad de la base de datos y limita las responsabilidades legales de la empresa en caso de un incidente de seguridad.

### 7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?
La relación es directa: implica estructurar el modelo entidad-relación, los roles, las vistas y los esquemas pensando en la protección del dato desde la primera línea de código SQL. En lugar de adaptar parches de privacidad posteriormente, el modelo de datos nace minimizado, con tipos de datos restrictivos y acceso acotado por defecto.

### 8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?
Implementaría Control de Acceso Basado en Roles (RBAC), enmascaramiento dinámico de datos (*Dynamic Data Masking*), cifrado a nivel de columna para datos sensibles, vistas agregadas/disociadas para analítica, el módulo `pgaudit` para trazabilidad de consultas y tareas programadas de purga de datos.

### 9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?
El DBA debe conocer la ubicación exacta de todos los datos del titular en la arquitectura (tablas principales, secundarias, vistas), las claves foráneas asociadas, los procedimientos de exportación estructurada (para Acceso) y los mecanismos de anonimización/borrado en cascada y depuración de respaldos (para Cancelación).

### 10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?
* **Propietario de los datos (*Data Owner*):** Define la necesidad de negocio y el propósito de la recolección.
* **Área Jurídica y Responsable de Privacidad (DPO):** Establece el marco de cumplimiento, redacta los avisos de privacidad, evalúa la licitud de tratamientos y autoriza solicitudes ARCO.
* **DBA:** Traduce e implementa técnicamente las políticas de privacidad en la base de datos mediante roles, permisos, vistas, scripts de cifrado y auditorías.