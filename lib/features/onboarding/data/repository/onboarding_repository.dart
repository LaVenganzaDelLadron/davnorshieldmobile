import 'package:shared_preferences/shared_preferences.dart';

import '../models/onboarding_page_model.dart';

class OnboardingRepository {
  static const _seenKey = 'hasSeenOnboarding';

  const OnboardingRepository();

  List<OnboardingPageModel> pages() => const [
        OnboardingPageModel(
          title: 'Stop Online Scams Before They Reach You',
          description: 'Detect phishing links, fake SMS messages, dangerous QR codes, and online scams before they reach you.',
          illustrationAsset: 'shield',
          animationType: OnboardingAnimationType.shield,
        ),
        OnboardingPageModel(
          title: 'See Scams Happening Near You',
          description: 'Receive live scam alerts happening in your municipality and barangay across Davao del Norte.',
          illustrationAsset: 'map',
          animationType: OnboardingAnimationType.map,
        ),
        OnboardingPageModel(
          title: 'AI + Community Protection',
          description: 'AI learns scam patterns from community reports and protects everyone through smarter cyber alerts.',
          illustrationAsset: 'network',
          animationType: OnboardingAnimationType.network,
        ),
      ];

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) ?? false;
  }

  Future<void> markSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }
}
