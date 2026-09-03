import 'dart:async';
import 'dart:io';

/// Verifica alcance a Firestore sin autenticar ni leer información escolar.
Future<bool> probeInternetReachability() async {
  Socket? socket;
  try {
    socket = await Socket.connect(
      'firestore.googleapis.com',
      443,
      timeout: const Duration(seconds: 3),
    );
    return true;
  } on SocketException {
    return false;
  } on TimeoutException {
    return false;
  } finally {
    socket?.destroy();
  }
}
