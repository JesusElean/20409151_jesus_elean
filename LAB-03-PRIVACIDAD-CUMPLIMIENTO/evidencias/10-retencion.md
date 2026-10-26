# Actividad 9 — Derecho de oposición
Supongamos que un cliente solicita que sus datos no sean utilizados para una determinada finalidad secundaria.
Analiza:

    > ¿Es necesario eliminar inmediatamente todos sus datos de la base?

No. El derecho de oposición no implica necesariamente la destrucción física de la información, sino la suspensión o bloqueo del tratamiento de los datos para la finalidad específica que el titular ha rechazado por ejemplo, mercadotecnia o perfilamiento comercial, manteniendo los datos activos para la finalidad primaria si la relación contractual o legal continúa.

Explica:
1. qué información podría necesitar mantenerse

* Datos de identificación y contacto operativos: Necesarios para continuar brindando el servicio principal o cumplir con el contrato vigente por ejemplo, datos para soporte técnico o acceso a la plataforma.

* Datos de facturación y transacción rfc, historial de cobros: Requeridos para cumplir con obligaciones legales, contables y fiscales que exigen la conservación de comprobantes por periodos legalmente determinados.

* Registro de la solicitud de oposición: Se debe mantener una lista de exclusión (suppression list) para recordar técnicamente que ese cliente ejercitó su derecho de oposición y evitar recontactarlo por error en futuras campañas.

2. qué información podría dejar de utilizarse para determinada finalidad

* Datos demográficos y de comportamiento: Edad, ubicación geográfica o preferencias de consumo dejan de procesarse en algoritmos de recomendación, segmentación de mercado o envío de promociones.

* Canales de contacto directo para marketing: Correo electrónico o número telefónico no deberán sincronizarse con herramientas externas de e-mail marketing o mensajería masiva.

3. qué mecanismos técnicos podrían separar finalidades

* Banderas o flags de consentimiento en BD: Agregar columnas como acepta_marketing BOOLEAN DEFAULT FALSE o estatus_oposicion para filtrar las consultas comerciales.

* Vistas segmentadas con filtros por consentimiento: Crear vistas SQL que incluyan la cláusula WHERE acepta_marketing = TRUE para ser consumidas por las áreas comerciales.

* Desvinculación/anonimización parcial: Mover los datos históricos del cliente a un esquema disociado donde no pueda reidentificarse para análisis estadísticos puros.

4. por qué la decisión final no debe ser tomada únicamente por el DBA

El DBA gestiona la infraestructura técnica y la ejecución de consultas, pero carece de la atribución legal y de negocio para determinar si una oposición es procedente. Las áreas legal, de cumplimiento o el Data Protection Officer (DPO) son quienes deben evaluar si existen obligaciones legales como normativas fiscales o contractuales que prevalezcan sobre la solicitud del titular antes de ordenar una acción técnica en la base de datos.

---

# Actividad 10 — Política de retención
La organización propone:
    > “Conservar todos los datos de clientes indefinidamente porque podrían ser útiles en el futuro.”

Analiza esta política.
Responde:
### Pregunta 1
**¿Es compatible con el principio de minimización?**
**No.** El principio de minimización de datos junto con el de limitación del plazo de conservación establece que los datos personales solo deben conservarse durante el tiempo estrictamente necesario para cumplir con las finalidades para las cuales fueron recabados. Almacenar información de forma indefinida bajo la premisa de que "podría ser útil en el futuro" violenta directamente estas normativas.

### Pregunta 2
**¿Qué riesgos genera conservar información innecesaria?**
* **Aumento de la superficie de ataque y riesgo de fuga:** A mayor volumen de datos históricos almacenados, mayor es el impacto de seguridad y la exposición ante accesos no autorizados o filtraciones.
* **Infracciones y sanciones legales:** Incumplimiento directo de legislaciones de privacidad (LFPDPPP, RGPD, etc.), lo que puede acarrear multas administrativas severas.
* **Costos de almacenamiento e ineficiencia operativa:** Incremento innecesario en los costos de infraestructura, respaldos más pesados y tiempos de consulta degradados en la base de datos.
* **Inexactitud de los datos:** Los datos antiguos no actualizados pierden calidad y pertinencia, generando sesgos o errores en análisis futuros.

### Pregunta 3
**¿Qué debería determinar la organización antes de establecer un periodo de retención?**
1. **Identificación de finalidades:** Clarificar para qué proceso de negocio o servicio se utiliza cada categoría de datos.
2. **Obligaciones legales y regulatorias:** Consultar leyes fiscales, mercantiles y laborales que dictan plazos de retención obligatorios (por ejemplo, conservar comprobantes fiscales durante 5 años).
3. **Periodo de bloqueo (*Depuración/LOCKED*):** Definir la fase intermedia donde los datos no se tratan activamente, pero se conservan protegidos únicamente para responder a responsabilidades derivadas de su tratamiento antes de su eliminación definitiva.

### Pregunta 4
**¿Qué información debería documentarse para justificar el periodo seleccionado?**
* **Categoría de datos:** Tipo de dato (identificación, contacto, fiscal, transaccional).
* **Finalidad del tratamiento:** Razón de negocio o servicio que justifica su recolección.
* **Fundamento legal:** Ley o norma específica que exige la conservación durante un periodo determinado.
* **Duración exacta de la retención:** Plazo definitivo (ej. 3 años tras el cierre de la cuenta + 5 años de bloqueo fiscal).
* **Procedimiento de eliminación o borrado seguro:** Método técnico por el cual los datos serán purgados o anonimizados de forma irreversible al concluir el plazo.

Crea:
```
evidencias/10-retencion.md
```

