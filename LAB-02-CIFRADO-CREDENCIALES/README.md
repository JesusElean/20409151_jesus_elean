# Introducción

En la actualidad, las bases de datos almacenan información crítica que va desde credenciales de acceso hasta datos personales y financieros sensibles, lo que las convierte en un objetivo primordial para actores maliciosos. El problema central abordado radica en la vulnerabilidad de almacenar dicha información en texto plano o transmitirla por redes inseguras sin mecanismos de cifrado ni políticas de gestión de llaves. Una mala implementación en la capa de persistencia o en la capa de red permite que actores con acceso de lectura directos, atacantes con herramientas de captura de tráfico de red o la filtración de respaldos expongan de forma masiva la confidencialidad de los usuarios. Por ello, es imprescindible evaluar e implementar estrategias integrales de seguridad en reposo, en tránsito y de administración de secretos.

--- 

# Protección de credenciales

Existe una distinción fundamental entre almacenar contraseñas en texto claro, aplicarles un hash o cifrarlas. El texto claro guarda la contraseña exactamente como la escribe el usuario, permitiendo que cualquiera con acceso a la tabla la lea directamente y la comprometa en otros servicios. Por su parte, el cifrado es un proceso bidireccional que utiliza una clave secreta para transformar los datos, permitiendo recuperar el texto original mediante una operación de descifrado, lo cual resulta innecesario e inseguro para validar credenciales. En cambio, un hash criptográfico con sal, como el generado por la función crypt con algoritmos como Blowfish en pgcrypto, es un proceso unidireccional e irreversible que genera una huella digital única para cada contraseña. La verificación de credenciales no requiere recuperar la clave original, sino comparar el hash del intento de autenticación contra el hash almacenado, neutralizando así los ataques de tablas precalculadas y protegiendo el secreto aun si la base de datos es filtrada.

---

# Protección de datos sensibles

En este laboratorio se identificó y protegió el Registro Federal de Contribuyentes (RFC) de los clientes como dato sensible representativo mediante cifrado simétrico utilizando la función pgp_sym_encrypt de la extensión pgcrypto. A diferencia de un identificador genérico, el RFC constituye un dato personal identificable de carácter fiscal cuya exposición puede facilitar la suplantación de identidad o el fraude. Se seleccionó el cifrado simétrico bajo el estándar OpenPGP debido a que, por necesidades operativas, las aplicaciones legítimas requieren recuperar la cadena original en texto plano mediante pgp_sym_decrypt con la clave correspondiente, manteniendo el dato ilegible en reposo para consultas generales directas sobre el campo tipo bytea.

---

# TLS

Transport Layer Security (TLS) es un protocolo criptográfico que resuelve el problema de la interceptación e inspección no autorizada de datos durante su comunicación en la red (protección en tránsito). Al evaluar el estado de la conexión en PostgreSQL mediante consultas a pg_stat_ssl y la variable del sistema ssl, se verificó que la sesión local se ejecutaba de forma predeterminada sin TLS (ssl en off o f), enviando las consultas y datos en texto claro a través del socket. Asimismo, al forzar un modo de conexión estricto como sslmode=require desde la interfaz de comandos psql, el servidor rechazó la conexión debido a la ausencia de certificados SSL configurados en el archivo de parámetros del motor, evidenciando la diferencia entre una sesión protegida y una no protegida.

---

# Gestión de claves

Las claves criptográficas nunca deben almacenarse directamente dentro de las consultas, archivos de migración .sql ni en repositorios de código fuente. Escribir una clave estática en los scripts expone la contraseña de descifrado en el historial de comandos, en los registros de auditoría y consultas del servidor (query logs), y en los sistemas de control de versiones como Git. Si la clave queda incrustada en el código, pierde su naturaleza de secreto y anula cualquier beneficio técnico que proporcione el algoritmo de cifrado, haciendo inútil la protección de la columna cifrada.

---

# Resultados

Se logró crear e implementar esquemas de bases de datos que diferencian una estructura insegura de una segura para la gestión de usuarios, demostrando la generación de hashes no reversibles con sal mediante pgcrypto. Se aplicó exitosamente el cifrado simétrico en columnas de datos sensibles y su posterior descifrado controlado mediante la clave correspondiente. Adicionalmente, se diagnosticó el estado de cifrado en tránsito en el motor PostgreSQL, se compararon los distintos niveles de validación de sslmode y se definió una política formal de gestión de llaves que abarca todo su ciclo de vida.

---

# Problemas encontrados

Durante la ejecución del laboratorio se presentó un error de sintaxis al intentar interpretar directamente rutas de scripts locales dentro de la consola interactiva psql. Asimismo, al intentar establecer una conexión remota exigiendo sslmode=require mediante psql, el servidor emitió un error de conexión debido a que la instancia local de PostgreSQL no tenía habilitado el soporte SSL ni los certificados digitales configurados. Ambos incidentes permitieron comprender la diferencia entre comandos propios del cliente/shell y sentencias SQL, así como la configuración requerida a nivel de servidor para sostener conexiones cifradas obligatorias.

---

# Conclusiones

Se aprendió que la seguridad en bases de datos exige un modelo defensivo en profundidad donde cada capa atiende una amenaza específica: los hashes unidireccionales para credenciales, el cifrado simétrico para datos legibles sensibles, TLS para el tráfico de red y los gestores de secretos para la custodia de claves. En un entorno de producción aplicaría la sustitución total de claves en código por gestores centralizados como HashiCorp Vault o AWS Secrets Manager, la exigencia estricta de conexiones cifradas con sslmode=verify-full mediante certificados de autoridades de confianza, y el uso de funciones de derivación de claves robustas como Argon2id o bcrypt para el manejo de credenciales.

---

# Preguntas de reflexión

Una contraseña no debe almacenarse en texto claro porque cualquier persona con acceso de lectura a la tabla, respaldo o registro de auditoría obtendría directamente la credencial, exponiendo la cuenta del usuario y permitiendo ataques en cadena hacia otras plataformas donde el usuario reutilice la misma contraseña.

Un hash no es equivalente a un cifrado porque el cifrado es un proceso bidireccional diseñado para transformar datos de forma reversible mediante una clave, mientras que el hash es una función matemática unidireccional e irreversible diseñada para generar un resumen único sin posibilidad de recuperar el texto original.

El cifrado de una columna no sustituye al control de acceso porque el cifrado protege la confidencialidad del dato en reposo contra accesos no autorizados a nivel de disco o almacenamiento, mientras que el control de acceso define las reglas, permisos y roles de qué usuarios autorizados pueden ejecutar operaciones específicas en el motor de base de datos.

TLS no sustituye a los mecanismos de autorización de PostgreSQL porque TLS únicamente garantiza la confidencialidad, integridad y autenticación de la canalización de comunicación entre el cliente y el servidor, pero no determina qué tablas, esquemas o comandos SQL tiene permitido ejecutar un usuario una vez establecida la sesión.

Si una organización pierde la clave criptográfica utilizada para cifrar información sensible, la información cifrada se vuelve matemáticamente inalcanzable de forma permanente, provocando una pérdida irrecuperable de datos sin posibilidad de descifrado.

Si una clave criptográfica se publica accidentalmente en GitLab, la clave queda expuesta de inmediato y de forma permanente en el historial de commits del repositorio, lo que permite a cualquier usuario con acceso al repositorio o al historial descifrar los datos protegidos si obtiene una copia de la base de datos o intercepta la información.

Un repositorio privado no debe considerarse un almacén de secretos porque no ofrece controles de acceso criptográficos adecuados para llaves, el secreto queda expuesto en texto plano en las copias locales de los desarrolladores y la seguridad depende únicamente de los permisos del repositorio, violando los principios de mínimo privilegio y auditoría de secretos.

La diferencia radica en que la protección de información almacenada (en reposo) utiliza hashes, cifrado simétrico o cifrado de disco para salvaguardar los datos en tablas o medios físicos, mientras que la protección en transmisión (en tránsito) utiliza protocolos como TLS para cifrar el canal de red e impedir la escucha o alteración de los datos mientras viajan entre el cliente y el servidor.

La gestión de claves es tan importante como el algoritmo criptográfico porque la fortaleza matemática de un algoritmo moderno es inútil si la clave que lo controla es débil, se almacena en texto plano, no se rota o se expone por malas prácticas de custodia.

Como mecanismo adicional implementaría el cifrado automático de los archivos de respaldo en reposo mediante herramientas como GPG o AWS KMS, segregando el almacenamiento del respaldo de la ubicación de las llaves de descifrado y aplicando políticas de acceso basadas en roles con autenticación multifactor.