/// Mantiene disponibles las plataformas sin `dart:io`.
///
/// En web, la disponibilidad real de Firebase se resuelve por las operaciones
/// del SDK y sus estados de error.
Future<bool> probeInternetReachability() async => true;
