import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/usecases/verify_password_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/change_password_usecase.dart';
import 'package:yumm_ai/features/auth/presentation/state/change_password_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/change_password_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/pages/change_password_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => const AuthState();
}

class MockVerifyPasswordUseCase extends Mock implements VerifyPasswordUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

void main() {
  testWidgets('ChangePasswordScreen renders correctly', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final mockAuthRepo = MockAuthRepository();
    final mockVerifyUseCase = MockVerifyPasswordUseCase();
    final mockChangePasswordUseCase = MockChangePasswordUseCase();

    const testUser = UserEntity(
      uid: 'u1',
      email: 'test@test.com',
      fullName: 'Test User',
      authProvider: 'emailPassword',
    );
    when(
      () => mockAuthRepo.getCurrentUserFromServer(),
    ).thenAnswer((_) async => const Right(testUser));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          authViewModelProvider.overrideWith(() => MockAuthViewModel()),
          verifyPasswordUseCaseProvider.overrideWithValue(mockVerifyUseCase),
          changePasswordUseCaseProvider.overrideWithValue(
            mockChangePasswordUseCase,
          ),
          changePasswordViewModelProvider.overrideWith((ref) {
            return ChangePasswordViewModel(
              mockVerifyUseCase,
              mockChangePasswordUseCase,
            );
          }),
        ],
        child: const MaterialApp(home: ChangePasswordScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
