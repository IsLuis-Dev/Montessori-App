import '../models/app_user.dart';

/// Contrato para consultar y observar el perfil escolar de la sesión activa.
abstract class CurrentUserRepository {
  Stream<AppUser?> watchCurrentUserProfile({
    required String schoolId,
    required String uid,
  });

  Future<AppUser?> getCurrentUserProfile({
    required String schoolId,
    required String uid,
  });
}
