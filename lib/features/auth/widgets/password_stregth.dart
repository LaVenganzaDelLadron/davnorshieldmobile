import 'package:flutter/material.dart';

import '../../../core/constants/app_animations.dart';
import '../controllers/auth_controller.dart';

class PasswordStrengthPanel extends StatelessWidget {
  const PasswordStrengthPanel({
    super.key,
    required this.strength,
    required this.requirements,
  });

  final PasswordStrength strength;
  final List<bool> requirements;

  @override
  Widget build(BuildContext context) {
    final color = switch (strength) {
      PasswordStrength.weak => const Color(0xFFDC2626),
      PasswordStrength.medium => const Color(0xFFF59E0B),
      PasswordStrength.strong => const Color(0xFF16A34A),
    };

    final label = switch (strength) {
      PasswordStrength.weak => 'Weak',
      PasswordStrength.medium => 'Medium',
      PasswordStrength.strong => 'Strong',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Password Strength', style: Theme.of(context).textTheme.labelLarge),
            const Spacer(),
            AnimatedSwitcher(
              duration: AppAnimations.indicator,
              child: Text(label, key: ValueKey(label), style: TextStyle(color: color, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: TweenAnimationBuilder<double>(
            duration: AppAnimations.indicator,
            tween: Tween(begin: 0, end: _progressFor(strength)),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _RequirementChip(label: 'Minimum 8 characters', ok: requirements[0]),
            _RequirementChip(label: 'Uppercase letter', ok: requirements[1]),
            _RequirementChip(label: 'Lowercase letter', ok: requirements[2]),
            _RequirementChip(label: 'Number', ok: requirements[3]),
            _RequirementChip(label: 'Special character', ok: requirements[4]),
          ],
        ),
      ],
    );
  }

  double _progressFor(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.weak => 0.3,
      PasswordStrength.medium => 0.65,
      PasswordStrength.strong => 1,
    };
  }
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label, required this.ok});

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final color = ok ? const Color(0xFF16A34A) : const Color(0xFF64748B);
    return AnimatedContainer(
      duration: AppAnimations.indicator,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFFE8F7EE) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ok ? const Color(0xFF16A34A).withOpacity(0.28) : const Color(0xFFE2E8F0)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
