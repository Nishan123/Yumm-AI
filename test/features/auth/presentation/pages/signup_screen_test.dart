import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/pages/signup_screen.dart';

class MockAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => const AuthState();
}

void main() {
  testWidgets('SignupScreen renders correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(() => MockAuthViewModel()),
        ],
        child: const MaterialApp(home: SignupScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Sign Up !'), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
  });
}
