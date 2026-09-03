import 'package:flutter/foundation.dart';

/// Conserva la selección académica compartida entre rutas de calificaciones.
///
/// No contiene información de sesión ni realiza consultas. Su responsabilidad
/// se limita a mantener el periodo y el estudiante que el usuario seleccionó.
class AppState with ChangeNotifier {
  int _selectedTerm = 1;
  String _selectedStudentId = '';
  String _selectedStudentName = '';
  String _selectedGroupId = '';

  int get selectedTerm => _selectedTerm;
  String get selectedStudentId => _selectedStudentId;
  String get selectedStudentName => _selectedStudentName;
  String get selectedGroupId => _selectedGroupId;

  /// Cambia el periodo cuando el valor pertenece al rango vigente de 1 a 3.
  void changeTerm(int newTerm) {
    if (newTerm < 1 || newTerm > 3 || _selectedTerm == newTerm) return;

    _selectedTerm = newTerm;
    notifyListeners();
  }

  /// Establece el estudiante sobre el que operan las rutas académicas.
  void setStudentContext({
    required String studentId,
    required String studentName,
    required String groupId,
  }) {
    if (_selectedStudentId == studentId &&
        _selectedStudentName == studentName &&
        _selectedGroupId == groupId) {
      return;
    }

    _selectedStudentId = studentId;
    _selectedStudentName = studentName;
    _selectedGroupId = groupId;
    notifyListeners();
  }

  /// Elimina la selección al abandonar el flujo de un estudiante.
  void clearStudentContext() {
    if (_selectedStudentId.isEmpty &&
        _selectedStudentName.isEmpty &&
        _selectedGroupId.isEmpty) {
      return;
    }

    _selectedStudentId = '';
    _selectedStudentName = '';
    _selectedGroupId = '';
    notifyListeners();
  }
}
