import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/storage/user_session_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start fade-in immediately
    _fadeController.forward();

    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Reduced from 5s to 2.5s — just enough for the GIF logo to play
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    // Check if user is already logged in
    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSessionService.isLoggedIn();

    if (isLoggedIn) {
      context.goNamed("main");
    } else {
      context.goNamed("signup");
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            "${ConstantsString.assetGif}/animated_text_logo.gif",
            width: 200,
          ),
        ),
      ),
    );
  }
}
