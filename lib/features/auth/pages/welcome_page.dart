import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/auth_hero.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AnimatedBackground(isDark: isDark)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_rounded, size: 36, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 12),
                        Text('Welcome to DavnorShield', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        Text(
                          'Protect yourself and your community from phishing, scams, fake QR codes, and cyber threats happening around Davao del Norte.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isDark ? const Color(0xFFB7C8DB) : const Color(0xFF64748B),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const AuthHero(variant: AuthHeroVariant.welcome),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Column(
                      children: [
                        PrimaryButton(label: 'Log In', onPressed: () => context.go('/login')),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          height: 56,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => context.go('/signup'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              side: BorderSide(color: Theme.of(context).colorScheme.primary),
                              backgroundColor: Colors.white,
                            ),
                            child: Text('Create Account', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your information is protected with end-to-end encryption.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark ? const Color(0xFFB7C8DB) : const Color(0xFF64748B),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
