import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/pages/login_screen.dart';

class MockAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => const AuthState();
}

void main() {
  testWidgets('LoginScreen renders correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(() => MockAuthViewModel()),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Log In'), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);
  });
}
