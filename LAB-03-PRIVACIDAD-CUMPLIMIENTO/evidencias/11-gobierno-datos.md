# Actividad 11 — Diseñar una matriz de gobierno de datos
Construye una matriz para los principales campos de la tabla.

| Dato | Finalidad | Responsable | Usuarios autorizados | Protección | Retención | Acción al finalizar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`nombre`** | Identificación del cliente para la prestación del servicio y gestión de cuenta. | Líder de Atención al Cliente | Atención al cliente, Facturación, DBA | Cifrado en tránsito (TLS) y reposo (AES-256), Restricción por ACL | Duración del contrato + 5 años (bloqueo legal/fiscal) | Depuración / Borrado seguro |
| **`correo`** | Autenticación, envío de notificaciones del servicio y contacto operativo. | Líder de TI / Soporte | Atención al cliente, DBA | Cifrado en tránsito/reposo, Control de acceso basado en roles (RBAC) | Vida activa de la cuenta + periodo de bloqueo | Depuración / Borrado seguro |
| **`telefono`** | Validación de identidad, seguridad (2FA) y contacto de soporte urgente. | Líder de Seguridad de la Información | Atención al cliente, DBA | Cifrado en reposo, Enmascaramiento parcial en UI (ej. `******1234`) | Mientras el canal esté activo o a solicitud del cliente | Borrado / Cancelación inmediata |
| **`rfc`** | Cumplimiento de obligaciones fiscales y emisión de comprobantes (CFDI). | Director de Finanzas | Facturación, DBA | Cifrado a nivel de columna, Registro estricto de auditoría (Audit Log) | 5 años posteriores al ejercicio fiscal correspondiente | Depuración / Borrado definitivo |
| **`edad`** | Validación de elegibilidad legal y segmentación estadística (disociada). | Analista Principal de Datos | Analítica *(como rango/agregado)*, DBA | Disociación / Agrupación en rangos de edad, No expuesto en PII | Mientras se mantenga la cuenta activa | Anonimización irreversible |
| **`ciudad`** | Análisis de cobertura geográfica y personalización de contenido regional. | Gerente de Mercadotecnia | Analítica, Atención al cliente, DBA | Acceso mediante vistas agregadas para analítica | Duración de la relación comercial | Anonimización / Conservación estadística |
| **`codigo_postal`** | Determinación de zona de servicio, logística de envíos y cálculo de impuestos. | Líder de Operaciones / Logística | Facturación, Atención al cliente, Analítica *(agregado)*, DBA | Vistas restrictivas para analítica comercial | Duración del contrato o transacción comercial | Depuración / Anonimización |

Los roles pueden ser, por ejemplo:
* Atención al cliente
* Facturación
* Analítica
* DBA
* Dirección

No es necesario asignar todos los roles a todos los datos.

El objetivo es demostrar que **el acceso debe relacionarse con una necesidad funcional**.

Guarda la matriz en:
```
evidencias/11-gobierno-datos.md
```
