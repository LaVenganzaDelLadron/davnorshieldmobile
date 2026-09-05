import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../data/models/onboarding_page_model.dart';
import '../data/repository/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return const OnboardingRepository();
});

final onboardingPagesProvider = Provider<List<OnboardingPageModel>>((ref) {
  return ref.watch(onboardingRepositoryProvider).pages();
});

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref.watch(onboardingRepositoryProvider));
});

class OnboardingState {
  const OnboardingState({
    required this.currentPage,
    required this.isLastPage,
  });

  final int currentPage;
  final bool isLastPage;

  OnboardingState copyWith({int? currentPage, bool? isLastPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._repository)
      : pageController = PageController(),
        super(const OnboardingState(currentPage: 0, isLastPage: false));

  final OnboardingRepository _repository;
  final PageController pageController;

  List<OnboardingPageModel> get pages => _repository.pages();

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page, isLastPage: page == pages.length - 1);
  }

  Future<void> nextPage() async {
    if (state.isLastPage) return;
    await pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> skip() async {
    await pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> finish() async {
    await _repository.markSeenOnboarding();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
