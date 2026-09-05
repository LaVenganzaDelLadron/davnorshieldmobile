import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_animations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../controller/onboarding_controller.dart';
import '../widgets/onboarding_footer.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final pages = ref.watch(onboardingPagesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 65,
              child: Stack(
                children: [
                  Positioned.fill(child: AnimatedBackground(isDark: isDark)),
                  PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: pages.length,
                    physics: const PageScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AnimatedSwitcher(
                        duration: AppAnimations.pageTransition,
                        child: OnboardingPage(
                          key: ValueKey(index),
                          model: pages[index],
                          isActive: state.currentPage == index,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 35,
              child: OnboardingFooter(
                currentIndex: state.currentPage,
                isLastPage: state.isLastPage,
                primaryLabel: state.isLastPage ? 'Get Started' : 'Continue',
                onContinue: () async {
                  if (state.isLastPage) {
                    await controller.finish();
                    if (context.mounted) {
                      context.go('/welcome');
                    }
                    return;
                  }
                  await controller.nextPage();
                },
                onSkip: () async {
                  await controller.skip();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
