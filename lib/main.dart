import 'package:flutter/material.dart';
import 'package:cintli_montessori/core/config/app_feature_flags.dart';
import 'package:cintli_montessori/features/auth/data/repositories/firestore_current_user_repository.dart';
import 'package:cintli_montessori/features/auth/presentation/controllers/current_user_controller.dart';
import 'package:cintli_montessori/screens/calendar_screen.dart';
import 'package:cintli_montessori/people/teachers_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/app_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'news/news_screen.dart';
import 'academics/grades_screen.dart';
import 'people/students_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/firebase_options.dart';
import 'screens/splash_screen.dart';
import 'features/auth/presentation/screens/unauthorized_screen.dart';
import 'core/theme/colors.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/app_info.dart';
import 'core/widgets/app_loading_skeleton.dart';
import 'core/connectivity/network_status_controller.dart';
import 'core/monitoring/crash_reporting_service.dart';
import 'core/security/app_check_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Estas tareas no dependen entre sí; ejecutarlas en paralelo reduce el tiempo
  // que Android e iOS permanecen esperando antes de montar la interfaz.
  final preferencesFuture = SharedPreferences.getInstance();
  await Future.wait<void>([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then<void>((_) {}),
    initializeDateFormatting('es_MX'),
    AppInfo.loadAppInfo(),
  ]);
  await AppCheckService.initialize();
  await CrashReportingService.initialize();
  final prefs = await preferencesFuture;

  // Los controladores globales se crean una sola vez y se liberan con el árbol.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => ThemeController(prefs)),
        ChangeNotifierProvider(create: (context) => NetworkStatusController()),
        ChangeNotifierProvider(
          create:
              (context) => CurrentUserController(
                repository: FirestoreCurrentUserRepository(),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Configura temas, rutas y la protección global de perfiles autenticados.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<ThemeController, ThemeMode>(
      (notifier) => notifier.themeMode,
    );

    return MaterialApp(
      title: 'Cintli Montessori',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primaryBlue,
        fontFamily: 'LettersForLearners',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primaryBlue,
        fontFamily: 'LettersForLearners',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkSurface,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBlue,
          secondary: AppColors.primaryTurquoise,
          surface: AppColors.darkSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.brandBlueSurface,
          foregroundColor: Colors.white,
        ),
      ),

      // El controlador conserva la preferencia entre ejecuciones.
      themeMode: themeMode,

      builder: (context, child) {
        final accessState = context.select<
          CurrentUserController,
          ({bool authenticated, bool loading, bool hasAccess})
        >(
          (controller) => (
            authenticated: controller.isAuthenticated,
            loading: controller.isLoading,
            hasAccess: controller.hasAppAccess,
          ),
        );

        if (!accessState.authenticated) {
          return child ?? const SizedBox.shrink();
        }

        if (accessState.loading) {
          // Se conserva la ruta mientras se actualiza el perfil. Sustituir el
          // Navigator volvería a montar el splash y reiniciaría su navegación.
          return child ?? const SizedBox.shrink();
        }

        if (!accessState.hasAccess) {
          return const UnauthorizedScreen();
        }

        return child ?? const SizedBox.shrink();
      },

      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/home': (context) => const AppAccessPage(child: HomeScreen()),
        '/news':
            (context) => const MobileFeaturePage(
              allowDisabledMobileAdmin: AppFeatureFlags.enableMobileAdminNews,
              child: NewsScreen(),
            ),
        '/calendar':
            (context) => const MobileFeaturePage(
              allowDisabledMobileAdmin:
                  AppFeatureFlags.enableMobileAdminCalendar,
              child: CalendarScreen(),
            ),
        '/grades': (context) => const MobileFeaturePage(child: GradesScreen()),
        '/stats': (context) => const MobileFeaturePage(child: StatsScreen()),
        '/settings': (context) => const AppAccessPage(child: SettingsScreen()),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/students') {
          return MaterialPageRoute(
            builder: (_) => const AdminOnlyPage(child: StudentsScreen()),
          );
        }

        if (settings.name == '/teachers') {
          return MaterialPageRoute(
            builder: (_) => const AdminOnlyPage(child: TeachersScreen()),
          );
        }

        return null;
      },

      debugShowCheckedModeBanner: false,
    );
  }
}

/// Protege una ruta que requiere una cuenta escolar activa.
class AppAccessPage extends StatelessWidget {
  const AppAccessPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final accessState = context
        .select<CurrentUserController, ({bool loading, bool hasAccess})>(
          (controller) => (
            loading: controller.isLoading,
            hasAccess: controller.hasAppAccess,
          ),
        );

    if (accessState.loading) {
      return const AppLoadingSkeleton();
    }

    return accessState.hasAccess ? child : const UnauthorizedScreen();
  }
}

/// Protege funciones móviles y respeta el alcance administrativo deshabilitado.
class MobileFeaturePage extends StatelessWidget {
  const MobileFeaturePage({
    super.key,
    required this.child,
    this.allowDisabledMobileAdmin = false,
  });

  final Widget child;
  final bool allowDisabledMobileAdmin;

  @override
  Widget build(BuildContext context) {
    final accessState = context.select<
      CurrentUserController,
      ({bool loading, bool isAdmin, bool hasAccess})
    >(
      (controller) => (
        loading: controller.isLoading,
        isAdmin: controller.isAdmin,
        hasAccess: controller.hasAppAccess,
      ),
    );

    if (accessState.loading) {
      return const AppLoadingSkeleton();
    }

    final adminMobileDisabled =
        accessState.isAdmin &&
        !AppFeatureFlags.enableMobileAdmin &&
        !allowDisabledMobileAdmin;

    return accessState.hasAccess && !adminMobileDisabled
        ? child
        : const UnauthorizedScreen();
  }
}

/// Restringe rutas móviles reservadas a la administración habilitada.
class AdminOnlyPage extends StatelessWidget {
  const AdminOnlyPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final accessState = context
        .select<CurrentUserController, ({bool loading, bool isAdmin})>(
          (controller) => (
            loading: controller.isLoading,
            isAdmin: controller.isAdmin,
          ),
        );

    if (accessState.loading) {
      return const AppLoadingSkeleton();
    }

    return accessState.isAdmin && AppFeatureFlags.enableMobileAdmin
        ? child
        : const UnauthorizedScreen();
  }
}
