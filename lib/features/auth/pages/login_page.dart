import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_hero.dart';
import '../widgets/auth_header.dart';
import '../widgets/remember_me_checkbox.dart';
import 'forgot_password_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);
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
                  const SizedBox(height: AppSpacing.sm),
                  AuthHeader(
                    title: 'Welcome Back 👋',
                    subtitle: 'Sign in to continue protecting your community.',
                    onBack: () => context.go('/welcome'),
                    icon: Icons.shield_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AuthHero(variant: AuthHeroVariant.login),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: ListView(
                      children: [
                        GlassCard(
                          child: Column(
                            children: [
                              _AuthField(
                                controller: emailController,
                                label: 'Email Address',
                                hint: 'Enter your email address',
                                icon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                valid: state.email.isEmpty || controller.isEmailValid,
                                onChanged: controller.setEmail,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _PasswordField(
                                controller: passwordController,
                                obscure: state.obscurePassword,
                                onToggleVisibility: controller.togglePasswordVisibility,
                                onChanged: controller.setPassword,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  RememberMeCheckbox(value: state.rememberMe, onChanged: controller.toggleRememberMe),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => context.push('/forgot-password'),
                                    child: const Text('Forgot Password?'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              PrimaryButton(
                                label: 'Log In',
                                onPressed: () async {
                                  final ok = await controller.login();
                                  if (ok && context.mounted) {
                                    context.go('/dashboard');
                                  }
                                },
                              ),
                              if (state.errorMessage != null) ...[
                                const SizedBox(height: 10),
                                Text(state.errorMessage!, style: const TextStyle(color: Color(0xFFDC2626))),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              child: Text('OR', style: Theme.of(context).textTheme.labelLarge),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () async {
                              await controller.guestContinue();
                              if (context.mounted) {
                                context.go('/dashboard');
                              }
                            },
                            child: const Text('Continue as Guest'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: Theme.of(context).textTheme.bodyLarge),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: const Text('Create Account'),
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

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.keyboardType,
    required this.valid,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool valid;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: valid ? const Color(0xFFE2E8F0) : const Color(0xFFDC2626)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.6),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleVisibility,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_rounded),
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
