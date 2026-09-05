import 'package:flutter/material.dart';

import '../constants/app_animations.dart';
import '../constants/app_colors.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final active = index == currentIndex;
        return AnimatedContainer(
          duration: AppAnimations.indicator,
          curve: AppAnimations.material,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: active ? AppColors.emerald : AppColors.dotInactiveLight,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
