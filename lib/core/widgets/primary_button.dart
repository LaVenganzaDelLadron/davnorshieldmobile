import 'package:flutter/material.dart';

import '../constants/app_animations.dart';
import '../constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: enabled
                  ? const [AppColors.emerald, AppColors.emeraldDark]
                  : [AppColors.dotInactiveLight, AppColors.dotInactiveLight.withOpacity(0.8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: AppAnimations.indicator,
              child: Text(
                label,
                key: ValueKey(label),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
