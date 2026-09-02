import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototipo_2/core/monitoring/crash_reporting_service.dart';

void main() {
  group('CrashReportingService.shouldEnableCollection', () {
    test('habilita reportes solo en una compilacion release Android', () {
      expect(
        CrashReportingService.shouldEnableCollection(
          isReleaseMode: true,
          isWeb: false,
          platform: TargetPlatform.android,
        ),
        isTrue,
      );
    });

    test('deshabilita reportes fuera de release', () {
      expect(
        CrashReportingService.shouldEnableCollection(
          isReleaseMode: false,
          isWeb: false,
          platform: TargetPlatform.android,
        ),
        isFalse,
      );
    });

    test('deshabilita reportes en web', () {
      expect(
        CrashReportingService.shouldEnableCollection(
          isReleaseMode: true,
          isWeb: true,
          platform: TargetPlatform.android,
        ),
        isFalse,
      );
    });

    test('deshabilita reportes fuera de Android', () {
      expect(
        CrashReportingService.shouldEnableCollection(
          isReleaseMode: true,
          isWeb: false,
          platform: TargetPlatform.iOS,
        ),
        isFalse,
      );
    });
  });
}
