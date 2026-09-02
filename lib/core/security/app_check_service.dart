import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Inicializa Firebase App Check sin impedir el arranque de la aplicación.
///
/// La aplicación forzosa se controla exclusivamente desde Firebase Console.
/// Mientras los productos permanezcan en Supervisión, un problema de
/// certificación no bloquea el acceso legítimo a Firebase.
class AppCheckService {
  AppCheckService._();

  static const _webSiteKey = String.fromEnvironment(
    'FIREBASE_APP_CHECK_WEB_SITE_KEY',
  );

  static bool _initialized = false;

  static Future<bool> initialize() async {
    if (_initialized) return true;

    if (kIsWeb && !kDebugMode && _webSiteKey.isEmpty) {
      debugPrint(
        'App Check web permanece inactivo: falta '
        'FIREBASE_APP_CHECK_WEB_SITE_KEY.',
      );
      return false;
    }

    if (!kIsWeb && !_supportsNativeAttestation) return false;

    try {
      await FirebaseAppCheck.instance.activate(
        providerWeb:
            kIsWeb
                ? kDebugMode
                    ? WebDebugProvider()
                    : ReCaptchaEnterpriseProvider(_webSiteKey)
                : null,
        providerAndroid:
            kDebugMode
                ? const AndroidDebugProvider()
                : const AndroidPlayIntegrityProvider(),
        providerApple:
            kDebugMode
                ? const AppleDebugProvider()
                : const AppleAppAttestWithDeviceCheckFallbackProvider(),
      );
      _initialized = true;
      return true;
    } catch (error, stackTrace) {
      debugPrint('No fue posible inicializar Firebase App Check: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  static bool get _supportsNativeAttestation {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }
}
