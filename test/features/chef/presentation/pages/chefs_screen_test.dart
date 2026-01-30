import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/presentation/pages/chefs_screen.dart';

void main() {
  testWidgets('chefs screen loads correctly', (WidgetTester tester) async {
    // Set a larger screen size to prevent overflow
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: ChefsScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text("Select your desired chef"), findsOneWidget);
  });
}
