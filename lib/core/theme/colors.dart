import 'package:flutter/material.dart';

/// Paleta institucional y colores semánticos compartidos por la aplicación.
///
/// Las pantallas deben usar estos valores para conservar contraste y coherencia
/// entre los temas claro y oscuro.
class AppColors {
  /// Colores de marca independientes del tema.
  static const Color primaryRed = Color(0xFFFF5E52);
  static const Color primaryGreen = Color(0xFF2DC121);
  static const Color primaryYellow = Color(0xFFFFD731);
  static const Color primaryBlue = Color(0xFF0073DB);
  static const Color primaryTurquoise = Color(0xFF01B7CE);
  static const Color primaryOrange = Color(0xFFFAA619);
  static const Color brandBlueSurface = Color(0xFF003E9F);
  static const Color ink = Color(0xFF1D2530);
  static const Color softBackground = Color(0xFFF7FAFC);
  static const Color softBlue = Color(0xFFEAF5FF);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF172033);
  static const Color darkSurfaceAlt = Color(0xFF1D2A44);

  /// Devuelve el azul principal con contraste suficiente para el tema activo.
  static Color getBlue(bool isDarkMode) {
    return isDarkMode ? const Color(0xFF66B2FF) : primaryBlue;
  }

  /// Fondo principal de la aplicación.
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : softBackground;

  /// Color de texto con máxima jerarquía.
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white : ink;

  /// Color de texto para información secundaria.
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFD6E1F0)
          : Colors.black54;

  /// Azul adaptado al tema del contexto.
  static Color adaptiveBlue(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF66B2FF)
          : primaryBlue;

  /// Superficie utilizada por tarjetas.
  static Color cardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurface
          : Colors.white;

  /// Color de iconos y controles sobre la superficie principal.
  static Color iconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black87;

  /// Color para bordes y divisores de baja jerarquía.
  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white30
          : Colors.grey[300]!;
}
