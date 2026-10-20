# Actividad 3 — El problema de la gestión de claves

El siguiente ejemplo funciona técnicamente:

Pero existe un problema.

La clave aparece dentro del código.

Esto puede provocar exposición mediante:

* scripts
* repositorios Git
* archivos de configuración
* registros de ejecución
* capturas de pantalla
* respaldos
* documentación
* variables mal administradas


**¿Qué ocurriría si esta clave fuera una clave utilizada realmente por una organización y el archivo se publicara en un repositorio Git?**

Si esa clave fuera real y se publicara en un repositorio Git, las consecuencias serían catastróficas a nivel de seguridad y privacidad. Cualquier persona con acceso al repositorio obtendría la clave de cifrado. Con esa clave y acceso a la base de datos, podría descifrar la información confidencial de todos los clientes de forma inmediata.
Aunque el archivo con la clave se elimine en un commit posterior, la clave sigue grabada en el historial de versiones del repositorio, a menos que se realicen acciones destructivas avanzadas de limpieza. Si alguien clonó el repositorio antes de borrarlo, ya se habrá llevado la clave. La filtración de datos de identificación personal o fiscal incumple normativas de protección de datos, lo que puede derivar en multas severas, auditorías y demandas legales contra la organización.
La pérdida de confianza por parte de los clientes y socios comerciales al enterarse de que sus datos sensibles fueron expuestos por una negligencia interna.