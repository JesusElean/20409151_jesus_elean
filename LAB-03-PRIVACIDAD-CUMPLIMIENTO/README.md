# Actividad 1 — Inventario y finalidad de los datos.

## Completa la siguiente matriz.

| Campo | ¿Es dato personal | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
| ----- | ----------------- | --------- | -------------- | --------------- | --------- |
| id    | No es un identificador del sistema| Es un identificador único del registro de usuarios en la base de datos|Sí|Interno/Sistema|Mientras la cuenta esté activa o indefinido para logs.|
| nombre| Sí | Identifica al titular para la prestación del servicio, personalización e identificación legal|Sí|Restringido|Durante la relación contractual más tiempo legal obligatorio.|
| correo| Sí |Es la autenticación el envió de notificaciones del servicio para la recuperación de cuenta|Sí|Restringido|Durante la vida de la cuenta más periodo de bloqueo legal.|
|telefono| Sí |Para la autenticación de doble factor(2FA), validación de identidad y contacto de emergencia|Depende según el caso de uso|Confidencial|Durante la vida de la cuenta o hasta que el usuario lo elimine.|
| rfc   | Sí |Facturación, cumplimiento de obligaciones fiscales y contables ante las autoridades|Depende solamente si requiere factura|Altamente confidencial|5 años posteriores al ejercicio fiscal, conforme a legislación fiscal.|
| edad  | Sí |Verifica si tiene la mayoria de edad, elegibilidad legal para poder usar la plataforma|No, es mejor solicitar la fecha de nacimiento si se requiere verificar|Restringído|Durante la vida de la cuenta.|
| ciudad| Sí |Personaliza el contenido regional, logistica de enviós o análisis estadísticos general| Opcional|Público|Mientras la cuenta permanezca activa.|
|codigo_postal| Sí |Determina la zona de cobertura,, cálculo de impuestos, enviós y ubicación física.| Opcional, solo necesario en e-commerce|Restringido|Durante la relación comercial más periodo contable.|
|fecha_alta| No, es un dato de control |Registro de auditoría, antiguedad de la cuenta y seguimiento del ciclo de vida del usuario.|Sí|Interno|Indefinido o asociado al tiempo de retención del registro principal.|
