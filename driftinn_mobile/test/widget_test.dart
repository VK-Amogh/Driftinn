import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:driftinn_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Set a realistic screen size for the test
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const DriftinnApp());

    // Verify that LandingScreen shows key elements
    // Note: LandingScreen contains "Driftin", "DISCOVER CONNECTIONS", "Create Account"
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
