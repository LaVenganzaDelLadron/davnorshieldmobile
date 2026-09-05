// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:davnorshield/main.dart';

void main() {
  testWidgets('shows onboarding content', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(const DavnorShieldApp());
    await tester.pumpAndSettle();

    expect(find.text('Stop Online Scams Before They Reach You'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
