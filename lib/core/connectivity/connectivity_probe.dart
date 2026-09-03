import 'connectivity_probe_stub.dart'
    if (dart.library.io) 'connectivity_probe_io.dart';

/// Comprueba conectividad real mediante la implementación de cada plataforma.
///
/// `connectivity_plus` solo informa si existe una interfaz de red; esta sonda
/// confirma además que el servicio remoto puede alcanzarse.
Future<bool> hasInternetReachability() => probeInternetReachability();
