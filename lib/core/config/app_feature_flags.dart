/// Centraliza funciones que todavía no forman parte del alcance móvil activo.
///
/// Estas banderas controlan disponibilidad visual, no autorización. Cualquier
/// acceso a datos debe seguir protegido por las reglas de Firebase.
class AppFeatureFlags {
  const AppFeatureFlags._();

  static const bool enableMobileAdmin = false;
  static const bool enableMobileAdminNews = false;
  static const bool enableMobileAdminCalendar = false;
}
