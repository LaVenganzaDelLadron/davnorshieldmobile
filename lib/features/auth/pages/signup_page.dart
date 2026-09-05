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
import '../widgets/barangay_dropdown.dart';
import '../widgets/municipality_dropdown.dart';
import '../widgets/password_stregth.dart';
import 'login_page.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
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
                    title: 'Create Your Account',
                    subtitle: 'Join DavnorShield and help keep Davao del Norte safe online.',
                    onBack: () => context.go('/welcome'),
                    icon: Icons.security_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AuthHero(variant: AuthHeroVariant.signup),
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
                                hint: 'example@email.com',
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
                              const SizedBox(height: AppSpacing.sm),
                              PasswordStrengthPanel(
                                strength: controller.passwordStrength,
                                requirements: controller.passwordRequirements,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _ConfirmPasswordField(
                                controller: confirmController,
                                obscure: state.obscureConfirmPassword,
                                onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                                onChanged: controller.setConfirmPassword,
                                matches: state.confirmPassword.isEmpty ? null : controller.passwordsMatch,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Where do you live?', style: Theme.of(context).textTheme.titleMedium),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              MunicipalityDropdown(state: state, controller: controller),
                              const SizedBox(height: AppSpacing.md),
                              BarangayDropdown(state: state, controller: controller),
                              const SizedBox(height: AppSpacing.md),
                              _PrivacyBanner(isDark: isDark),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(value: state.termsAccepted, onChanged: (v) => controller.toggleTerms(v ?? false)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Wrap(
                                        children: [
                                          const Text('I agree to the '),
                                          TextButton(onPressed: () {}, child: const Text('Privacy Policy')),
                                          const Text(' and '),
                                          TextButton(onPressed: () {}, child: const Text('Terms of Service')),
                                          const Text('.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              PrimaryButton(
                                label: 'Create Account',
                                enabled: controller.canSubmitSignup,
                                onPressed: state.termsAccepted
                                    ? () async {
                                        final ok = await controller.signUp();
                                        if (ok && context.mounted) {
                                          _showSuccess(context);
                                          await Future<void>.delayed(const Duration(milliseconds: 700));
                                          if (context.mounted) context.go('/dashboard');
                                        }
                                      }
                                    : () {},
                              ),
                              if (state.errorMessage != null) ...[
                                const SizedBox(height: 10),
                                Text(state.errorMessage!, style: const TextStyle(color: Color(0xFFDC2626))),
                              ],
                            ],
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
                        Text('Already have an account? ', style: Theme.of(context).textTheme.bodyLarge),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Log In'),
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

  void _showSuccess(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Account Created Successfully'),
        content: const Text('Redirecting you to the dashboard...'),
        actions: const [],
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF10233D) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_rounded, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Location is only used to send scam alerts in your municipality and barangay.'),
          ),
        ],
      ),
    );
  }
}
