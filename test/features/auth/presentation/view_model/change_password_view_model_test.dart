import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/usecases/change_password_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/verify_password_usecase.dart';
import 'package:yumm_ai/features/auth/presentation/state/change_password_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/change_password_view_model.dart';

class MockVerifyPasswordUseCase extends Mock implements VerifyPasswordUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class FakeUserEntity extends Fake implements UserEntity {}

class FakeChangePasswordParams extends Fake implements ChangePasswordParams {}

void main() {
  late ProviderContainer container;
  late MockVerifyPasswordUseCase mockVerifyPasswordUseCase;
  late MockChangePasswordUseCase mockChangePasswordUseCase;

  setUpAll(() {
    registerFallbackValue(FakeChangePasswordParams());
  });

  setUp(() {
    mockVerifyPasswordUseCase = MockVerifyPasswordUseCase();
    mockChangePasswordUseCase = MockChangePasswordUseCase();

    container = ProviderContainer(
      overrides: [
        verifyPasswordUseCaseProvider.overrideWithValue(
          mockVerifyPasswordUseCase,
        ),
        changePasswordUseCaseProvider.overrideWithValue(
          mockChangePasswordUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is ChangePasswordStatus.initial', () {
    final state = container.read(changePasswordViewModelProvider);
    expect(state.status, ChangePasswordStatus.initial);
  });

  test(
    'verifyOldPassword success updates state to oldPasswordVerified',
    () async {
      when(
        () => mockVerifyPasswordUseCase.call(any()),
      ).thenAnswer((_) async => const Right(true));

      final viewModel = container.read(
        changePasswordViewModelProvider.notifier,
      );
      await viewModel.verifyOldPassword('password');

      final state = container.read(changePasswordViewModelProvider);
      expect(state.status, ChangePasswordStatus.oldPasswordVerified);
    },
  );

  test(
    'changePassword success updates state to changePasswordSuccess',
    () async {
      when(
        () => mockChangePasswordUseCase.call(any()),
      ).thenAnswer((_) async => Right(FakeUserEntity()));

      final viewModel = container.read(
        changePasswordViewModelProvider.notifier,
      );
      await viewModel.changePassword(oldPassword: 'old', newPassword: 'new');

      final state = container.read(changePasswordViewModelProvider);
      expect(state.status, ChangePasswordStatus.changePasswordSuccess);
    },
  );
}
