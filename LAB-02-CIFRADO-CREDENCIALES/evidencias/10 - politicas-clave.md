# Política de Gestión y Protección de Claves Criptográficas

Esta política establece los lineamientos obligatorios para el manejo seguro del ciclo de vida de las claves criptográficas dentro de la organización.

1. **Generación:** Todas las claves criptográficas deben generarse exclusivamente utilizando generadores de números pseudoaleatorios criptográficamente seguros (CSPRNG) con longitudes y algoritmos estándar de la industria (por ejemplo, AES-256).
2. **Almacenamiento:** Las claves criptográficas **nunca** deben almacenarse en texto plano dentro del código fuente, archivos de configuración locales o repositorios de control de versiones. Deben residir en gestores de secretos dedicados (como HashiCorp Vault, AWS Secrets Manager o servicios equivalentes).
3. **Acceso:** El acceso a las claves se rige estrictamente por el principio de **mínimo privilegio**, limitándose únicamente a los servicios y roles autorizados mediante autenticación robusta y control de acceso basado en roles (RBAC).
4. **Rotación:** Las claves deben someterse a un proceso de rotación periódica programada, así como a una sustitución inmediata ante cualquier cambio de personal con privilegios o sospecha de compromiso.
5. **Respaldo:** Las copias de seguridad de las claves de cifrado deben almacenarse de forma independiente a los datos cifrados, fuertemente protegidas mediante cifrado adicional y ubicadas en entornos segregados.
6. **Revocación:** El sistema debe contar con un mecanismo automatizado y eficiente para revocar de forma instantánea cualquier clave o certificado que haya expirado o cuyo compromiso haya sido detectado.
7. **Exposición accidental:** Ante cualquier evidencia o sospecha de filtración de una clave, se debe declarar su compromiso inmediato, ejecutando protocolos de revocación de emergencia, rotación y auditoría forense del impacto.
8. **Eliminación:** Las claves obsoletas o retiradas deben eliminarse de forma permanente y segura (*secure deletion*), garantizando que no existan copias residuales recuperables en los medios de almacenamiento.

## Verificación final de conceptos

**¿Una contraseña debe cifrarse o protegerse mediante un mecanismo de derivación de claves para contraseñas?**

Sí. Las contraseñas nunca deben cifrarse de forma reversible (cifrado simétrico o asimétrico), sino protegerse mediante funciones de hash unidireccionales con sal y factor de trabajo ajustable (funciones de derivación de claves) como bcrypt, Argon2 o PBKDF2. Esto garantiza que, aunque la base de datos sea comprometida, las contraseñas originales no puedan recuperarse fácilmente.

**¿Qué diferencia existe entre enmascaramiento, seudonimizacion y cifrado?**

Enmascaramiento: Oculta parcialmente los datos mostrados (por ejemplo, ****-****-****-1234) para impedir la visualización completa en pantallas o reportes sin alterar el dato subyacente.

Seudonimización: Sustituye los identificadores directos por un valor ficticio o token, manteniendo una tabla de correspondencia aislada y protegida para permitir análisis estadísticos o operativos sin exponer directamente la identidad.

Cifrado: Transforma los datos mediante un algoritmo matemático y una clave secreta, haciendo que la información sea completamente ilegible para cualquier persona que no posea la clave de descifrado legítima.

**¿Qué problema resuelve TLS?**

TLS (Transport Layer Security) resuelve el problema de la seguridad en tránsito. Protege los datos mientras viajan por la red entre el cliente y el servidor de base de datos, garantizando confidencialidad (evita escuchas e interceptaciones), integridad (evita que los datos sean modificados en el camino) y autenticación (verifica la identidad del servidor mediante certificados).

**¿Dónde debería almacenarse una clave criptográfica en un entorno real?**

En un entorno de producción real, las claves criptográficas deben almacenarse en sistemas especializados de gestión de secretos (como HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, Google Secret Manager) o, como alternativa mínima estricta, en variables de entorno segregadas y con permisos altamente restringidos en el servidor de ejecución, jamás en archivos de código o repositorios.
**¿Es correcto subir una contraseña o clave real a GitLab aunque el repositorio sea privado?**

No.
Un repositorio privado reduce la exposición general frente a actores públicos externos, pero no convierte un secreto en información apropiada para almacenar dentro del código. Cualquier colaborador con acceso al repositorio, la existencia de copias locales o posibles brechas de acceso a la plataforma dejarían expuestas las credenciales de forma permanente en el control de versiones.