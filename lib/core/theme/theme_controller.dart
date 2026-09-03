import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Administra el tema de la aplicación móvil y conserva la elección local.
///
/// Este controlador es la única fuente de verdad para el modo claro u oscuro.
/// Mantenerlo fuera de `main.dart` evita que las pantallas dependan del punto de
/// entrada de la aplicación y permite probarlo o sustituirlo de forma aislada.
class ThemeController extends ChangeNotifier {
  ThemeController(this._preferences)
    : _themeMode =
          (_preferences.getBool(_darkModePreferenceKey) ?? false)
              ? ThemeMode.dark
              : ThemeMode.light;

  static const String _darkModePreferenceKey = 'darkMode';

  final SharedPreferences _preferences;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  /// Cambia el tema y persiste la selección sin bloquear la interfaz.
  void setDarkMode(bool enabled) {
    final nextMode = enabled ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode == nextMode) return;

    _themeMode = nextMode;
    notifyListeners();
    unawaited(_preferences.setBool(_darkModePreferenceKey, enabled));
  }
}
