import 'package:flutter/material.dart';

import '../../../../core/constants/app_animations.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.isActive,
  });

  final String title;
  final String description;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSlide(
          duration: AppAnimations.headline,
          curve: AppAnimations.material,
          offset: isActive ? Offset.zero : const Offset(0.08, 0),
          child: AnimatedOpacity(
            duration: AppAnimations.headline,
            opacity: isActive ? 1 : 0.65,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.08),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSlide(
          duration: AppAnimations.description,
          curve: AppAnimations.material,
          offset: isActive ? Offset.zero : const Offset(0, 0.08),
          child: AnimatedOpacity(
            duration: AppAnimations.description,
            opacity: isActive ? 1 : 0.75,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
          ),
        ),
      ],
    );
  }
}
