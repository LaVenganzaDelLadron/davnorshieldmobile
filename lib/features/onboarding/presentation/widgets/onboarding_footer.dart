import 'package:flutter/material.dart';

import '../../../../core/constants/app_animations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/page_indicator.dart';
import '../../../../core/widgets/primary_button.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.currentIndex,
    required this.isLastPage,
    required this.primaryLabel,
    required this.onContinue,
    required this.onSkip,
  });

  final int currentIndex;
  final bool isLastPage;
  final String primaryLabel;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PageIndicator(currentIndex: currentIndex),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(label: primaryLabel, onPressed: onContinue),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: onSkip,
              child: Text(isLastPage ? 'Skip' : 'Skip'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedOpacity(
            duration: AppAnimations.footer,
            opacity: 1,
            child: const SafeArea(top: false, child: SizedBox(height: 1)),
          ),
        ],
      ),
    );
  }
}
