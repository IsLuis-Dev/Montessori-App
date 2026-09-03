import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

/// Convierte errores técnicos conocidos en mensajes seguros para el usuario.
///
/// El texto resultante no expone rutas, reglas, identificadores ni detalles de
/// Firebase que puedan revelar información interna.
String userFriendlyErrorMessage(
  Object error, {
  required String fallback,
  String? permissionDenied,
  String? failedPrecondition,
}) {
  if (error is TimeoutException) {
    return 'La conexion esta tardando demasiado. Revisa tu internet e intenta nuevamente.';
  }

  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return permissionDenied ??
            'No tienes permisos para consultar esta informacion.';
      case 'failed-precondition':
        return failedPrecondition ??
            'La informacion aun se esta preparando. Intenta nuevamente en unos minutos.';
      case 'unavailable':
        return 'No se pudo conectar con el servicio. Revisa tu conexion e intenta nuevamente.';
      case 'deadline-exceeded':
        return 'La operacion tardo demasiado. Intenta nuevamente.';
      default:
        return fallback;
    }
  }

  return fallback;
}
