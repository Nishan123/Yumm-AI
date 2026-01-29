import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumm_ai/features/auth/presentation/pages/login_screen.dart';
import 'package:yumm_ai/features/auth/presentation/pages/signup_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';

class MockAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
    return const AuthState();
  }
}

void main() {
  testWidgets('signup sceen testing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(() => MockAuthViewModel()),
        ],
        child: MaterialApp(home: SignupScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("Sign Up !"), findsOneWidget);
  });

  testWidgets('login screen testing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(() => MockAuthViewModel()),
        ],
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("Welcome\nBack !"), findsOneWidget);
  });
}
