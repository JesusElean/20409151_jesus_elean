# Verificación final

Antes de finalizar el laboratorio, debes poder explicar:

## Privacidad
**¿Qué diferencia existe entre seguridad de la información y privacidad?**
La seguridad de la información se enfoca en proteger los datos frente a accesos no autorizados, alteraciones o pérdidas mediante medidas técnicas y criptográficas, mientras que la privacidad determina quién tiene derecho a acceder a esos datos y bajo qué condiciones legítimas. En otras palabras, la seguridad es el mecanismo de defensa contra amenazas, y la privacidad es el marco ético y normativo que define el uso correcto y autorizado de la información personal de los titulares.

## Finalidad
**¿Por qué una organización no debería utilizar automáticamente todos los datos que posee para cualquier propósito?**
Una organización no puede utilizar libremente todos sus datos para cualquier propósito debido al principio de finalidad, el cual establece que la información debe recolectarse para un objetivo específico, explícito y legítimo. Reutilizar los datos en otros contextos sin el consentimiento del titular o sin una base jurídica válida vulnera la confianza del usuario, infringe las normativas de protección de datos y expone a la empresa a sanciones legales graves por extralimitación en el tratamiento.

## Minimización
**¿Por qué almacenar más información no necesariamente es mejor?**
Almacenar más información de la necesaria no es mejor porque incrementa innecesariamente la superficie de ataque y los costos de infraestructura. Cuantos más datos personales innecesarios conserve una organización, mayor será el impacto económico, legal y reputacional en caso de una brecha de seguridad, además de contravenir directamente el principio de minimización que exige limitar la recolección a lo estrictamente indispensable para cumplir con la finalidad del servicio.

## ARCO
**¿Qué implicaciones técnicas tienen los derechos de acceso, rectificación, cancelación y oposición?**
Los derechos ARCO tienen profundas implicaciones técnicas en la base de datos que van más allá de una simple respuesta administrativa. El acceso requiere consultas seguras que rastreen expedientes completos y metadatos; la rectificación exige actualización transaccional precisa y bitácoras de auditoría; la cancelación implica un desafío técnico complejo para purgar copias en respaldos, réplicas, logs y sistemas externos; y la oposición requiere mecanismos de filtrado o banderas de exclusión para suspender tratamientos específicos sin destruir datos operativos obligatorios.

## Retención
**¿Por qué la conservación indefinida puede representar un riesgo?**
La conservación indefinida de los datos representa un riesgo crítico porque expone información histórica innecesaria a posibles fugas de seguridad a largo plazo, contraviene el principio de limitación del plazo de almacenamiento y genera costos operativos y de almacenamiento elevados. Además, retener datos más tiempo del estrictamente necesario o legalmente obligatorio aumenta la vulnerabilidad ante auditorías y demandas por incumplimiento de las leyes de privacidad.

## Gobierno
**¿Quién debería decidir qué datos pueden utilizarse y para qué finalidad?**
La decisión sobre qué datos se pueden utilizar y para qué finalidad no debe recaer de forma aislada en el equipo técnico, sino en un comité de gobierno de datos, los responsables de cumplimiento legal y el oficial de privacidad (DPO), en coordinación con los líderes de cada unidad de negocio. Estas áreas son las únicas con la autoridad jurídica y estratégica para evaluar la licitud del tratamiento, mientras que el rol técnico se limita a implementar las directrices aprobadas.

## DBA
**¿Cuál es la responsabilidad del DBA y cuáles decisiones deben involucrar a otras áreas?**
La responsabilidad principal del DBA es garantizar la integridad, disponibilidad, rendimiento y seguridad técnica de las bases de datos aplicando los controles de acceso y cifrado correspondientes. Sin embargo, el DBA no debe tomar decisiones unilaterales sobre la interpretación de normativas legales, la procedencia de solicitudes de derechos ARCO, la aprobación de finalidades secundarias o la definición de políticas de retención, ya que esas determinaciones corresponden exclusivamente a las áreas legales, de cumplimiento y de negocio de la organización.