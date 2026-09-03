# Guía de contribución

## Alcance

Cintli Montessori es un proyecto propietario publicado como portafolio. Una
contribución requiere autorización del propietario y debe respetar la licencia,
la privacidad de la comunidad escolar y las reglas de este documento.

## Preparación

1. Crea tu propia configuración local de Firebase.
2. Ejecuta `flutter pub get`.
3. Confirma que `flutter analyze` y `flutter test` finalizan correctamente.
4. Utiliza exclusivamente cuentas y datos ficticios.

No solicites ni reutilices credenciales personales del propietario.

## Ramas

`main` representa la línea estable de preproducción. No se trabaja directamente
sobre ella.

Usa nombres breves y descriptivos:

```text
feat/notificaciones-grupo
fix/calendario-evento-duplicado
refactor/tema-aplicacion
docs/guia-arquitectura
test/repositorio-noticias
chore/dependencias-flutter
```

Las ramas creadas por Codex utilizan el prefijo `codex/`.

No reutilices una rama ya fusionada y no hagas `force push` sin autorización
explícita y una razón documentada.

## Commits

Cada commit debe representar una sola intención verificable y seguir
Conventional Commits:

```text
<tipo>(<alcance>): <descripción en presente>
```

Tipos aceptados:

| Tipo | Uso |
| --- | --- |
| `feat` | Capacidad visible nueva |
| `fix` | Corrección de comportamiento |
| `refactor` | Cambio interno sin alterar el comportamiento esperado |
| `docs` | Documentación sin cambios funcionales |
| `test` | Pruebas nuevas o corregidas |
| `build` | Compilación, SDK o configuración de plataforma |
| `ci` | Automatización de integración continua |
| `chore` | Mantenimiento sin efecto funcional |

Ejemplos:

```text
feat(news): permite archivar comunicados vencidos
fix(auth): evita navegar con una cuenta inactiva
refactor(theme): separa la persistencia del punto de entrada
docs(contributing): documenta validaciones del pull request
```

El encabezado no termina con punto. El cuerpo, cuando sea necesario, explica el
motivo, las decisiones y las validaciones; no enumera cada línea modificada.

## Clean Code

- Un archivo debe tener una responsabilidad principal.
- La presentación no construye consultas ni rutas de Firebase.
- Los controladores reciben dependencias por constructor.
- Los repositorios encapsulan acceso a datos y conversiones externas.
- Los nombres expresan intención y evitan abreviaturas sin contexto.
- Los métodos extensos se separan por responsabilidad, no por cantidad
  arbitraria de líneas.
- Las constantes de negocio se centralizan; no se duplican identificadores o
  nombres de campos.
- Se elimina código muerto en lugar de conservarlo comentado.
- No se crea una abstracción hasta que exista una frontera o sustitución real.

Consulta [ARCHITECTURE.md](ARCHITECTURE.md) antes de mover responsabilidades
entre capas.

## Comentarios

Los comentarios se redactan en español profesional, sin emojis y con la misma
voz técnica del repositorio.

Documenta:

- responsabilidad de una API pública;
- reglas de negocio que no son evidentes;
- efectos secundarios y orden requerido de operaciones;
- compatibilidad con datos históricos;
- decisiones de seguridad o plataforma;
- razones para una solución aparentemente inusual.

No documentes:

- sintaxis que ya expresa el código;
- comentarios como “crea variable”, “abre pantalla” o “retorna valor”;
- información temporal que debería estar en un issue;
- credenciales, identificadores privados o datos personales;
- bloques de código deshabilitados.

Un comentario incorrecto es más peligroso que la ausencia de comentario. Debe
actualizarse en el mismo commit que cambia el comportamiento descrito.

## Firebase

Todo cambio en Firebase debe indicar qué producto y rutas afecta. Si modifica
una consulta, revisa también reglas e índices.

Está prohibido versionar:

- `.firebaserc` real;
- `google-services.json`;
- `GoogleService-Info.plist`;
- `firebase_options.dart` generado;
- cuentas de servicio, tokens y material de firma;
- exportaciones de emuladores con datos reales.

App Check permanece sin aplicación forzosa durante la preproducción. Activarlo
en Firebase Console no forma parte de un cambio ordinario de código.

## Validación requerida

Ejecuta como mínimo:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos --fatal-warnings
flutter test
flutter build apk --debug
```

Si cambia el panel administrativo:

```bash
flutter build web --release -t lib/admin_web/main_admin.dart
```

Si cambian reglas, agrega pruebas con Firebase Emulator Suite. Si cambia una
interfaz, verifica teléfono compacto, teléfono amplio y escritorio según
corresponda.

## Pull requests

Un pull request debe ser pequeño, coherente y revisable. Incluye:

- problema y alcance;
- solución aplicada;
- riesgos y elementos fuera de alcance;
- evidencia de pruebas;
- impacto en Firebase, seguridad y datos;
- capturas cuando exista un cambio visual.

No mezcles una función, un refactor general y una actualización de dependencias
en el mismo pull request.

## Definición de terminado

Un cambio está terminado cuando:

- cumple el requisito acordado;
- conserva las fronteras de arquitectura;
- no incorpora datos o archivos sensibles;
- incluye pruebas proporcionales al riesgo;
- pasa análisis, pruebas y compilaciones aplicables;
- actualiza comentarios y documentación afectados;
- puede revertirse sin depender de cambios no publicados;
- fue revisado y fusionado mediante pull request.
