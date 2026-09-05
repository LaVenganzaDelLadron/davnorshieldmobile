import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/pages/forgot_password_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/pages/welcome_page.dart';
import '../features/dashboard/pages/dashboard_page.dart';
import '../features/onboarding/controller/onboarding_controller.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _SplashGatePage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
});

class _SplashGatePage extends ConsumerStatefulWidget {
  const _SplashGatePage();

  @override
  ConsumerState<_SplashGatePage> createState() => _SplashGatePageState();
}

class _SplashGatePageState extends ConsumerState<_SplashGatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasSeen = await ref.read(onboardingRepositoryProvider).hasSeenOnboarding();
      final isAuthenticated = await ref.read(authRepositoryProvider).isAuthenticated();
      if (!mounted) return;
      if (!hasSeen) {
        context.go('/onboarding');
        return;
      }
      context.go(isAuthenticated ? '/dashboard' : '/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navy, AppColors.navyDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_rounded, size: 72, color: Colors.white),
              SizedBox(height: 16),
              Text(
                AppStrings.appName,
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
