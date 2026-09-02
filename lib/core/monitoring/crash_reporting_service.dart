import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashReportingService {
  const CrashReportingService._();

  @visibleForTesting
  static bool shouldEnableCollection({
    required bool isReleaseMode,
    required bool isWeb,
    required TargetPlatform platform,
  }) {
    return isReleaseMode && !isWeb && platform == TargetPlatform.android;
  }

  static Future<void> initialize() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    final crashlytics = FirebaseCrashlytics.instance;
    final shouldCollect = shouldEnableCollection(
      isReleaseMode: kReleaseMode,
      isWeb: kIsWeb,
      platform: defaultTargetPlatform,
    );

    try {
      await crashlytics.setCrashlyticsCollectionEnabled(shouldCollect);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('No se pudo configurar Crashlytics: $error');
      }
      return;
    }

    if (!shouldCollect) return;

    final previousFlutterErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutterErrorHandler?.call(details);
      unawaited(crashlytics.recordFlutterFatalError(details));
    };

    final previousPlatformErrorHandler = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      previousPlatformErrorHandler?.call(error, stack);
      unawaited(crashlytics.recordError(error, stack, fatal: true));
      return true;
    };
  }
}
