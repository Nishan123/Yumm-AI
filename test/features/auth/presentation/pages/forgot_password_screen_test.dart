import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/pages/forgot_password_screen.dart';

class MockAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => const AuthState();
}

void main() {
  testWidgets('ForgotPasswordScreen renders correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(() => MockAuthViewModel()),
        ],
        child: const MaterialApp(home: Scaffold(body: ForgotPasswordScreen())),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Forgot'), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);
  });
}
