# Política de seguridad

## Alcance y versión mantenida

Este repositorio contiene una versión pública de portafolio de Cintli
Montessori. El proyecto se encuentra en preproducción y gestiona dominios
sensibles como autenticación, perfiles escolares, información académica y
reglas de acceso de Firebase.

La rama `main` representa la única línea mantenida de preproducción. Las ramas
de trabajo y versiones anteriores pueden no recibir correcciones de seguridad.

Este documento cubre código Flutter, automatizaciones de GitHub, reglas de
Firebase y configuración pública del repositorio. No autoriza pruebas contra
cuentas, dispositivos o proyectos Firebase ajenos.

Se consideran especialmente relevantes los hallazgos relacionados con:

- acceso no autorizado a Firestore, Storage o Realtime Database;
- escalamiento o suplantación de roles;
- exposición de credenciales, datos personales o configuraciones privadas;
- creación o recuperación indebida de cuentas;
- dependencias o workflows que permitan comprometer el repositorio.

## Cómo reportar una vulnerabilidad

No abras un issue público ni incluyas datos reales de estudiantes, familias,
docentes o personal escolar.

Utiliza el reporte privado de vulnerabilidades de GitHub cuando esté disponible
en la pestaña **Security** del repositorio. Como alternativa, envía el reporte a
[luisitprivt@gmail.com](mailto:luisitprivt@gmail.com) con el asunto
`[Seguridad Montessori-App] Resumen del hallazgo`.

Incluye únicamente la información necesaria para reproducir el problema:

- componente y versión o commit afectado;
- precondiciones y pasos de reproducción;
- impacto observado o potencial;
- evidencia anonimizada;
- propuesta de mitigación, si existe.

No adjuntes credenciales activas, exportaciones de Firebase ni información
personal. Si el hallazgo involucra un secreto válido, indica solamente el tipo
y la ubicación general para acordar un canal de manejo seguro.

## Pruebas permitidas

- Utiliza datos, cuentas y proyectos Firebase propios o expresamente
  autorizados.
- Detén la prueba si existe riesgo de acceder a información personal.
- No realices denegación de servicio, ingeniería social ni automatizaciones que
  degraden la disponibilidad.
- No publiques una prueba de concepto antes de que exista una mitigación.

## Gestión del reporte

El responsable del repositorio confirmará la recepción cuando sea posible,
evaluará alcance y severidad, y coordinará una divulgación responsable. No
publiques detalles técnicos antes de que exista una mitigación o se acuerde una
fecha de divulgación.

## Criterios de evaluación

La evaluación considera impacto sobre confidencialidad, integridad,
disponibilidad, alcance de usuarios y facilidad de explotación. Una corrección
puede incluir código, reglas, revocación de credenciales o configuración del
servicio afectado.

La recepción de un reporte no garantiza recompensa económica. Se reconocerá la
colaboración cuando sea apropiado y exista autorización de la persona que
reportó el hallazgo.
