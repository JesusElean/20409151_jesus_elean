# Informe de Laboratorio 1.
## Actividad 1 - Clasificación de los datos.
Antes de implementar controles de protección, analizar los atributos de la tabla clientes.

Completar la siguiente matriz:

| Campo | ¿Identifica Directamente | ¿Puede contribuír a identificar | ¿Requiere protección | Justificación |
|-------|--------------------------|---------------------------------|----------------------|---------------|
| id | No|  Sí|Sí| Es un identificador interno de valor único, víncula los datos de los clientes en el sistema, protegerlo ayuda a que se eviten cruces no autorizados|
| nombre | Sí | Sí|Sí| Es el nombre completo de la persona. Es un elemento principal e identificador directo.
| correo | Sí| Sí|Sí| Es un dato de contactp único y personal, se asocia de manera directa con el individuo.|
| teléfono | Sí| Sí|Sí|Número de contacto privado vinculado inequivocadamente a una persona|
| rfc | Sí| Sí|Sí| Es la clave oficial y única de carácter fiscal que ayuda a identificar formalmente a la persona|
| edad| No | Sí|Sí, de manera moderada| Es un dato demográfico que por sí solo no identifica, pero si reduce el universo posible de candidados.|
| ciudad| No| Sí|Si, baja.| Ubicación general que acota al perfil demográfico del cliente.|
| codigo_postal| No| Sí| Sí, media| Es un dato geográfico preciso.|
| fecha_alta| No| No|No|Es un metadato operativo del sistema que indica la fecha del registro, no revela informacion personal ni de identidad.|



### Respuestas a preguntas:
1. **¿Qué campos identifican directamente a una persona?**

nombre, correo, telefono y rfc. Estos atributos permiten asociar la información de manera unívoca e inequívoca a una persona física específica sin necesidad de referencias cruzadas complejas.
2. **¿Qué campos no identifican por sí solos pero podrían contribuír a hacerlo?**

edad, ciudad y codigo_postal (también el id desde una perspectiva relacional técnica). Son considerados cuasi-identificadores o atributos demográficos que por sí mismos son genéricos, pero que aportan contexto para acotar perfiles.
3. **¿Qué combinación de campos podrían incrementar el riesgo de reidentificación?**

La combinación de edad + ciudad + codigo_postal (junto con metadatos como fecha_alta). Cruzar variables de ubicación geográfica y demografía permite reidentificar a un porcentaje elevado de individuos anonimizados al cruzarse con fuentes de datos externas o públicas (como redes sociales).   
4. **¿Todos los datos que deben protegerse son necesariamente datos personales sensibles desde el punto de vista jurídico?**

No. Legalmente, los datos sensibles son aquellos que afectan la esfera más íntima de su titular por ejemplo: estado de salud, origen étnico, creencias religiosas, orientación sexual, etc.. Los campos de esta tabla (nombre, rfc, correo) son datos personales generales o de identificación, los cuales sí requieren protección rigurosa por motivos de seguridad de la información, privacidad y prevención de robo de identidad, aunque jurídicamente no pertenezcan a la categoría de "sensibles".

## Actividad 2 — Enmascaramiento (masking)

El área de soporte necesita consultar información de los clientes, pero no requiere visualizar los valores completos de correo, teléfono y RFC.

El objetivo es proporcionar una vista con información parcialmente ocultada y evitar que el usuario tenga acceso directo a la tabla original.

### Respuestas a Preguntas:
1. **¿Qué información continúa existiendo en la tabla original?**

Se mantiene toda la información personal sin ninguna alteración o restricción. La tabla conserva los datos integros para los procesos o roles que si pósean privilegios como los del DBA.
2. **¿Que información puede visualizar el usuario `soporte`?**

El usuario con el rol de soporte solo puede ver el id del cliente asi como su nombre completo, pero el resto de datos los mira cortos ya que se distinguen unas cuantas letras y todo lo demas se oculta con asteríscos.
3. **¿Por qué no es suficiente ocultar datos únicamente en la aplicación?**

Porque cualquier usuario con privilegios de conexión a la base de datos podriá consultar la tabla de clientes sin ninguna restricción y extraer toda la información confidencial o sensible.
4. **¿Qué ocurría sí `soporte` tuviera acceso directo a clientes?**

No existiera el principio de minimo privilegio. Los de soporte tendrían acceso a la información de los datos sensibles, incrementendo el riesgo de filtraciones de información, el mal uso de datos personales o exposición accidental ante incidentes de seguridad.

## Actividad 3 — Seudonimización (pseudonymization)

El área de analítica necesita estudiar información de clientes sin acceder directamente a su identidad.

Para ello se utilizará un identificador sustituto denominado token.

## Actividad 4 — Separación de funciones

La seudonimización pierde gran parte de su utilidad si el mismo usuario puede consultar tanto los datos seudonimizados como el mapa que permite recuperar la identidad.
### Respuestas a preguntas:
1. **¿Qué ocurriría si `analista` pudiera consultar también `pii.mapa_cliente`?**

Se rompería el principio de seudonimizacion, ya que al tener acceso tanto a datos analiticos como a la tabla de correspondencia, el rol de analista podria realizar un JOIN y vincular tokens directamente con los identificadores originales en `public.clientes`, descubriendo la identidad real de las personas.
2. **¿Qué principios de seguridad se está aplicando al separar ambos accesos?**

Se aplica el principio de separación de funciones y el principio de menor privilegio tambien conocidos en ingles como Segregation of Duties o SoD y Least Privilege. Consiste en dividir los accesos criticos de manera que ningún rol individual posea control total o visibilidad cruzada de información sensible y sus llaves de descifrado al mismo tiempo.
3. **¿Por qué la seudonimización no equivale a anomización?**

Porque la seudonimizacion es reversible, mientras que la anomizacion es irreversible. La seudonimizacion utiliza un identificador sustituto conocido como token pero conserva la tabla de correspondencia. En cambio, la anomizacion los datos se transforman de forma permanente y se destruye cualquier vínculo o mecanismo que permita reidentificar a la persona.
4. **¿Qué información permite volver a relacionar el token con una persona?**

La tabla de correspondencia `pii.mapa_cliente`, la cual vincula directamente el token con el id del cliente `cliente_id`.

## Actividad 5 — Anonimización (anonymization)
El área de dirección solicita información estadística.

No necesita conocer los clientes individualmente.

El objetivo es generar información agregada y reducir el riesgo de reidentificación.

## Actividad 6 — Análisis del riesgo de reidentificación

Analizar el resultado obtenido en la actividad anterior.
### Respuestas a las preguntas:
1. **¿Qué identificadores directos fueron eliminados?**

Se eliminaron el id, el nombre, el correo, el telefono, y el rfc.
2. **¿Qué cuasi-identificadores permanecen?**

La edad se convierte en rangos y la región geografica derivada de los primeros dígitos del codigo postal.
3. **¿Qué combinaciones de atributos podrían reducir el anonimato?**

La combinación cruzada de rangos de edad muy específicos, regiones geográficas pequeñas y fechas de registro exactas.
4. **¿Qué sucede cuando un grupo contiene pocos registros?**

Incrementa drasticamente el riesgo de una reidentificacion, ya que un atacante con informacion externa puede deducir con facilidad quien es el titular de ese registro unico.
5. **¿Qué atributos deberian generalizarse?**

Atributos numericos como la edad y codigos postales completos
6. **¿Qué información deberia suprimirse?**

Aquellos grupos que no cumplan con un umbral minimo de registros.
7. **¿Es correcto afirmar que el conjunto de datos es "100 % anónimo", ¿Por qué?**

No es correcto. Ya que el riesgo cero no existe, siempre existe la posibilidad de reidentificacion mediante ataques de triangulacion de datos, cruce con bases de datos externas o variables auxiliares imprevistas.

### Reto
Modificar la consulta anterior para reducir aún más el riesgo de reidentificación.

Documentar:
* **cambio realizado**

Se ampliaron los intervalos de edad a categorías más amplias (18-40 y 41+).   
Se redujo la precisión de la ubicación geográfica utilizando únicamente el primer dígito del código postal (LEFT(codigo_postal, 1)) para agrupar por macro-regiones.   
Se aplicó la cláusula de supresión de grupos pequeños HAVING COUNT(*) >= 2 para asegurar que únicamente se muestren combinaciones con un tamaño mínimo de población.  
* **motivo**

Los filtros iniciales y los rangos geográficos detallados (como dos dígitos de código postal) generaban subgrupos muy pequeños (conteo de 1), lo que exponía los registros al aislamiento y facilitaba su deducción o cruce con fuentes externas.
* **resultado obtenido**

La consulta agrupó exitosamente la información en dos bloques estadísticos seguros:

* 18-40 (Jóvenes/Adultos): 3 registros en la macro-región 8.   
* 41+ (Adultos Mayores/Ancianos): 2 registros en la macro-región 
    
Ningún grupo contiene registros aislados o singulares (todos cumplen con $count \ge 2$).  
* **riesgo que se pretende reducir**

Riesgo de reidentificación por singularidad y ataques de enlace: Se evita que un usuario o analista pueda aislar a una persona específica combinando su edad exacta y su ubicación postal precisa.

## Actividad 7 — Retención de datos

La organización debe definir qué información conserva y durante cuánto tiempo.

Primero identificar los registros que hipotéticamente superan el periodo de conservación establecido.

Para este ejercicio se utilizará un periodo de cinco años:

```sql
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '5 years';
```

No ejecutar el DELETE sobre la tabla principal.

El objetivo de esta actividad es identificar los registros afectados y diseñar el procedimiento.

Documentar:

* **qué registros serían afectados**

Ningún registro actual de la tabla clientes sería afectado, ya que todas las fechas de alta registradas corresponden al año actual.
* **cuál sería la justificación del periodo**

El periodo de 5 años se justifica comúnmente con base en normativas fiscales, mercantiles y legales aplicables (por ejemplo, obligaciones de conservación de contabilidad, contratos comerciales y rastreabilidad de operaciones mercantiles), equilibrando la necesidad operativa e histórica de la empresa con los principios de minimización de datos y limitación del almacenamiento de la privacidad.
* **qué aprobación debería existir antes de eliminar información**

Dirección / Oficial de Privacidad / Cumplimiento (Compliance): Para validar que no existan litigios pendientes, auditorías activas o requerimientos legales que exijan mantener dichos expedientes.
Área Legal: Confirmación de que el plazo legal de prescripción de obligaciones ha caducado.

* **qué respaldo debería existir**

Full Backup de la base de datos o de un esquema de archivo histórico.
Una exportación aislada de los registros que van a ser depurados en un formato seguro (ej. dump cifrado) para salvaguardar la trazabilidad ante eventuales auditorías retroactivas.
* **qué evidencia debería conservarse**

Se debe generar y archivar una bitácora de auditoría de depuración, la cual debe contener:

Fecha y hora exacta de la ejecución del proceso.

Identificación del usuario o rol responsable de la ejecución.

El número total de registros afectados y eliminados.

El folio o la constancia de aprobación firmada por los responsables de cumplimiento/dirección.
* **qué procedimiento permitiría recuperar información eliminada accidentalmente**

En caso de un borrado accidental o imprevisto, la recuperación se realizaría mediante:

Restauración puntual de respaldo (Point-in-Time Recovery - PITR) en un entorno de pruebas o de staging para extraer únicamente los registros afectados y reinsertarlos de manera controlada.

Uso del esquema de respaldo histórico de contingencia, donde previamente se habrían migrado los datos en lugar de eliminarlos de forma definitiva (práctica recomendada de soft-delete o archivo histórico previo al purgado físico).

La eliminación física de información se trabajará posteriormente en las prácticas de respaldo y recuperación.

