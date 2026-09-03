import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cintli_montessori/core/theme/colors.dart';
import 'package:cintli_montessori/features/auth/presentation/controllers/current_user_controller.dart';

/// Inicializa la experiencia visual y dirige la sesión a la ruta correcta.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoSlideController;
  late Animation<Offset> _logoSlideAnimation;

  late List<AnimationController> _letterControllers;

  late AnimationController _montessoriController;
  late Animation<double> _montessoriScale;
  late Animation<double> _montessoriOpacity;

  static const String _title = 'Cintli';

  bool _navigationTriggered = false;
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLetterAnimations();
  }

  /// Configura los controladores que forman la secuencia de entrada.
  void _initializeAnimations() {
    _logoSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _letterControllers = List.generate(_title.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 520),
      );
    });

    _logoSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2.5),
    ).animate(
      CurvedAnimation(parent: _logoSlideController, curve: Curves.easeInOut),
    );

    _montessoriController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _montessoriScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _montessoriController, curve: Curves.elasticOut),
    );

    _montessoriOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _montessoriController, curve: Curves.easeIn),
    );
  }

  /// Reproduce la secuencia antes de resolver la ruta de la sesión.
  void _startLetterAnimations() {
    for (int i = 0; i < _letterControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (!mounted) return;
        _letterControllers[i].forward();
        if (i == _letterControllers.length - 1) {
          Future.delayed(const Duration(milliseconds: 350), () {
            if (!mounted) return;
            _montessoriController.forward();

            Future.delayed(const Duration(milliseconds: 550), () {
              if (!mounted) return;
              setState(() => _showLoading = true);

              Future.delayed(const Duration(milliseconds: 450), () {
                if (!mounted) return;
                _logoSlideController.forward().then((_) {
                  _navigateAfterProfileCheck();
                });
              });
            });
          });
        }
      });
    }
  }

  /// Dirige una sola vez a inicio o autenticación según el perfil vigente.
  Future<void> _navigateAfterProfileCheck() async {
    if (_navigationTriggered) return;
    _navigationTriggered = true;

    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
      return;
    }

    final currentUserController = context.read<CurrentUserController>();
    final profileAlreadyLoaded =
        currentUserController.user?.uid == authUser.uid &&
        !currentUserController.isLoading;
    if (!profileAlreadyLoaded) {
      await currentUserController.loadCurrentUser(authUser: authUser);
    }

    if (!mounted) return;
    if (currentUserController.hasAppAccess) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void dispose() {
    _logoSlideController.dispose();
    _montessoriController.dispose();
    for (final controller in _letterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBlueSurface,
      body: Center(
        child:
            _showLoading
                ? _buildLoading()
                : SlideTransition(
                  position: _logoSlideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedLogo(size: 130),
                      const SizedBox(height: 10),
                      _buildAnimatedMontessori(size: 130),
                    ],
                  ),
                ),
      ),
    );
  }

  /// Construye la marca con una animación independiente por letra.
  Widget _buildAnimatedLogo({required double size}) {
    List<String> letters = ['C', 'i', 'n', 't', 'l', 'i'];
    List<Color> colors = [
      AppColors.primaryRed,
      AppColors.primaryGreen,
      AppColors.primaryYellow,
      AppColors.primaryBlue,
      AppColors.primaryTurquoise,
      AppColors.primaryOrange,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(letters.length, (index) {
        final controller = _letterControllers[index];

        final scale = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut),
        );

        final rotation = Tween<double>(begin: -1.0, end: 0.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
        );

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: rotation.value,
              child: Transform.scale(
                scale: scale.value,
                child: Text(
                  letters[index],
                  style: TextStyle(
                    fontFamily: 'LettersForLearners',
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.bold,
                    color: colors[index],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// Construye la segunda línea de la marca con escala y opacidad.
  Widget _buildAnimatedMontessori({required double size}) {
    return FadeTransition(
      opacity: _montessoriOpacity,
      child: ScaleTransition(
        scale: _montessoriScale,
        child: Text(
          'Montessori',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: size * 0.2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Presenta el estado breve mientras se resuelve el perfil escolar.
  Widget _buildLoading() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Colors.white, strokeWidth: 4),
        SizedBox(height: 20),
        Text(
          'Cargando...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Lato',
          ),
        ),
      ],
    );
  }
}
