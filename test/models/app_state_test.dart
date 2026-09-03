import 'package:flutter_test/flutter_test.dart';
import 'package:cintli_montessori/models/app_state.dart';

void main() {
  group('AppState', () {
    test('solo acepta periodos académicos entre uno y tres', () {
      final state = AppState();

      state.changeTerm(2);
      state.changeTerm(4);

      expect(state.selectedTerm, 2);
    });

    test('notifica una sola vez cuando cambia el contexto', () {
      final state = AppState();
      var notificationCount = 0;
      state.addListener(() => notificationCount++);

      state.setStudentContext(
        studentId: 'student-1',
        studentName: 'Estudiante de prueba',
        groupId: 'group-1',
      );
      state.setStudentContext(
        studentId: 'student-1',
        studentName: 'Estudiante de prueba',
        groupId: 'group-1',
      );

      expect(notificationCount, 1);
    });

    test('limpia el contexto seleccionado', () {
      final state =
          AppState()..setStudentContext(
            studentId: 'student-1',
            studentName: 'Estudiante de prueba',
            groupId: 'group-1',
          );

      state.clearStudentContext();

      expect(state.selectedStudentId, isEmpty);
      expect(state.selectedStudentName, isEmpty);
      expect(state.selectedGroupId, isEmpty);
    });
  });
}
