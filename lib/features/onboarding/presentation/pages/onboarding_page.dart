import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../data/models/onboarding_page_model.dart';
import '../widgets/hero_animation.dart';
import '../widgets/onboarding_content.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.model,
    required this.isActive,
  });

  final OnboardingPageModel model;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Center(child: HeroAnimation(type: model.animationType))),
          const SizedBox(height: AppSpacing.md),
          OnboardingContent(
            title: model.title,
            description: model.description,
            isActive: isActive,
          ),
        ],
      ),
    );
  }
}
