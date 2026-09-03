import '../models/calendar_event_model.dart';

/// Resume los grupos y estudiantes que puede consultar una cuenta.
class CalendarUserAudience {
  const CalendarUserAudience({
    required this.canReadAll,
    required this.groupIds,
    required this.isAdmin,
  });

  final bool canReadAll;
  final List<String> groupIds;
  final bool isAdmin;
}

/// Contrato para consultar y publicar eventos según su audiencia.
abstract class CalendarRepository {
  Stream<List<CalendarEventModel>> watchPublishedEvents({
    required String schoolId,
    required DateTime startDate,
    required DateTime endDate,
    required bool canReadAll,
    required List<String> visibleGroupIds,
  });

  Future<List<CalendarEventModel>> getPublishedEvents({
    required String schoolId,
    required DateTime startDate,
    required DateTime endDate,
    required bool canReadAll,
    required List<String> visibleGroupIds,
  });

  Future<void> createEvent(CalendarEventModel event);

  Future<bool> isAdmin({required String schoolId, required String userId});

  Future<CalendarUserAudience> getUserAudience({
    required String schoolId,
    required String userId,
  });
}
