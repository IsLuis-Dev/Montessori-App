import 'package:package_info_plus/package_info_plus.dart';

/// Mantiene metadatos de la compilación visibles en la aplicación.
///
/// Debe inicializarse una vez durante el arranque mediante [loadAppInfo].
class AppInfo {
  AppInfo._();

  static String appName = '';
  static String packageName = '';
  static String version = '';
  static String buildNumber = '';

  /// Carga nombre, paquete y versión desde la plataforma.
  static Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    appName = info.appName;
    packageName = info.packageName;
    version = info.version;
    buildNumber = info.buildNumber;
  }

  /// Devuelve la versión y el número interno de compilación.
  static String get fullVersion => '$version+$buildNumber';

  /// Versión pública que se muestra a los usuarios.
  static String get displayVersion => version;
}
