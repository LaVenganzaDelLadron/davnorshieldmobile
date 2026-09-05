import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:davnorshield/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() {
  testWidgets('shows onboarding content', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: OnboardingScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Stop Online Scams Before They Reach You'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
