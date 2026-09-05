enum OnboardingAnimationType { shield, map, network }

class OnboardingPageModel {
  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.illustrationAsset,
    required this.animationType,
  });

  final String title;
  final String description;
  final String illustrationAsset;
  final OnboardingAnimationType animationType;
}
