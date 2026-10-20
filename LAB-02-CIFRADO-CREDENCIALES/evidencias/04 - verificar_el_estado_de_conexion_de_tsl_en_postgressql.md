## Actividad 4 — Protección de datos durante la comunicación

Hasta este momento hemos protegido información almacenada.

Ahora analizaremos otro problema:

¿Qué sucede con la información mientras viaja entre el cliente y PostgreSQL?

Una consulta como:

```sql
SELECT *
FROM clientes;
```

viaja entre el cliente y el servidor.

Si la conexión no está protegida, una persona con capacidad para observar el tráfico de red podría intentar obtener información de la comunicación.

Para resolver este problema se utiliza TLS (Transport Layer Security).

## Actividad 5 — Verificar el estado de TLS en PostgreSQL

### Preguntas

**¿La conexión actual utiliza TLS?**

No, la conexión actual no utiliza TLS. Esto se confirma tanto en el parámetro general (ssl está en off) como en la sesión actual, donde la consulta a pg_stat_ssl devuelve f (falso) para la columna ssl.

**¿Qué versión de TLS se está utilizando?**

Ninguna, ya que la sesión no está cifrada. Si bien el parámetro ssl_min_protocol_version indica que el servidor está configurado para requerir al menos TLSv1.2 cuando sí se use cifrado, la sesión actual se estableció sin activar TLS (al tratarse de una conexión local por defecto a través de sockets o localhost sin forzar parámetros SSL).

**¿Qué algoritmo de cifrado aparece?**

Ninguno. La columna cipher en la salida de pg_stat_ssl se encuentra vacía porque los datos se están transmitiendo en texto plano.

**¿Qué diferencia existe entre una conexión protegida con TLS y una conexión sin TLS?**

Todos los datos (incluyendo comandos SQL, nombres de usuario y contraseñas o datos sensibles) viajan por la red en texto plano. Cualquier atacante con acceso a la red o herramientas de captura de tráfico (packet sniffing como Wireshark o tcpdump) puede interceptar y leer la información fácilmente. Con TSL Los datos se cifran antes de salir del cliente y se descifran al llegar al servidor. Esto garantiza: Confidencialidad: Nadie puede leer el contenido del tráfico aunque lo intercepte, Integridad: Se asegura que los datos no sean modificados en el transcurso de la comunicación, Autenticación: Permite verificar la identidad del servidor de base de datos mediante certificados digitales, previniendo ataques de tipo Man-in-the-Middle (MitM).