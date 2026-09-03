import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cintli_montessori/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeController', () {
    test('restaura el modo oscuro guardado', () async {
      SharedPreferences.setMockInitialValues({'darkMode': true});
      final preferences = await SharedPreferences.getInstance();

      final controller = ThemeController(preferences);

      expect(controller.themeMode, ThemeMode.dark);
    });

    test('notifica y persiste un cambio de tema', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final controller = ThemeController(preferences);
      var notificationCount = 0;
      controller.addListener(() => notificationCount++);

      controller.setDarkMode(true);
      await Future<void>.delayed(Duration.zero);

      expect(controller.themeMode, ThemeMode.dark);
      expect(notificationCount, 1);
      expect(preferences.getBool('darkMode'), isTrue);
    });

    test('ignora selecciones que no cambian el tema', () async {
      SharedPreferences.setMockInitialValues({'darkMode': false});
      final preferences = await SharedPreferences.getInstance();
      final controller = ThemeController(preferences);
      var notificationCount = 0;
      controller.addListener(() => notificationCount++);

      controller.setDarkMode(false);

      expect(notificationCount, 0);
    });
  });
}
