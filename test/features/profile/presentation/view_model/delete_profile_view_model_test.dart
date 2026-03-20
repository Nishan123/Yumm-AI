import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/services/app_state_reset_service.dart';
import 'package:yumm_ai/features/auth/domin/usecases/logout_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/delete_user_verified_usecase.dart';
import 'package:yumm_ai/features/profile/presentation/state/delete_profile_state.dart';
import 'package:yumm_ai/features/profile/presentation/view_model/delete_profile_view_model.dart';

class MockDeleteUserWithPasswordUsecase extends Mock
    implements DeleteUserWithPasswordUsecase {}

class MockDeleteUserWithGoogleUsecase extends Mock
    implements DeleteUserWithGoogleUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockAppStateResetService extends Mock implements AppStateResetService {}

class FakeDeleteUserWithPasswordParams extends Fake
    implements DeleteUserWithPasswordParams {}

void main() {
  late ProviderContainer container;
  late MockDeleteUserWithPasswordUsecase mockDeleteUserWithPasswordUsecase;
  late MockDeleteUserWithGoogleUsecase mockDeleteUserWithGoogleUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockAppStateResetService mockAppStateResetService;

  setUpAll(() {
    registerFallbackValue(FakeDeleteUserWithPasswordParams());
  });

  setUp(() {
    mockDeleteUserWithPasswordUsecase = MockDeleteUserWithPasswordUsecase();
    mockDeleteUserWithGoogleUsecase = MockDeleteUserWithGoogleUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockAppStateResetService = MockAppStateResetService();

    when(
      () => mockLogoutUsecase.call(),
    ).thenAnswer((_) async => const Right(true));
    when(() => mockAppStateResetService.resetAllState()).thenAnswer((_) {});

    container = ProviderContainer(
      overrides: [
        deleteUserWithPasswordUsecaseProvider.overrideWithValue(
          mockDeleteUserWithPasswordUsecase,
        ),
        deleteUserWithGoogleUsecaseProvider.overrideWithValue(
          mockDeleteUserWithGoogleUsecase,
        ),
        logoutUsercaseProvider.overrideWithValue(mockLogoutUsecase),
        appStateResetServiceProvider.overrideWithValue(
          mockAppStateResetService,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is properties default', () {
    final state = container.read(deleteProfileViewModelProvider);
    expect(state.status, DeleteProfileStatus.initial);
  });

  test('deleteWithPassword success updates state to success', () async {
    when(
      () => mockDeleteUserWithPasswordUsecase.call(any()),
    ).thenAnswer((_) async => const Right(true));

    final viewModel = container.read(deleteProfileViewModelProvider.notifier);
    await viewModel.deleteWithPassword(uid: 'user_1', password: 'password');

    final state = container.read(deleteProfileViewModelProvider);
    expect(state.status, DeleteProfileStatus.success);
  });
}
