import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
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
        builder: (context, state) => const _DestinationPage(
          title: 'Welcome',
          subtitle: 'Your cybersecurity workspace starts here.',
          primaryActionLabel: 'Login',
          secondaryActionLabel: 'Sign Up',
          primaryPath: '/login',
          secondaryPath: '/signup',
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const _DestinationPage(
          title: 'Login',
          subtitle: 'Secure access for returning users.',
          primaryActionLabel: 'Back',
          secondaryActionLabel: 'Sign Up',
          primaryPath: '/welcome',
          secondaryPath: '/signup',
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const _DestinationPage(
          title: 'Sign Up',
          subtitle: 'Create a new DavnorShield account.',
          primaryActionLabel: 'Back',
          secondaryActionLabel: 'Login',
          primaryPath: '/welcome',
          secondaryPath: '/login',
        ),
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
      if (!mounted) return;
      context.go(hasSeen ? '/welcome' : '/onboarding');
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

class _DestinationPage extends StatelessWidget {
  const _DestinationPage({
    required this.title,
    required this.subtitle,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
    required this.primaryPath,
    required this.secondaryPath,
  });

  final String title;
  final String subtitle;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final String primaryPath;
  final String secondaryPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(subtitle, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(primaryPath),
                child: Text(primaryActionLabel),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(secondaryPath),
                child: Text(secondaryActionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
