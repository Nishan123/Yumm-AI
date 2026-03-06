import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/usecases/forgot_password_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/google_signin_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/login_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/logout_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/signup_usecase.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/core/services/app_state_reset_service.dart';

class MockSignupUsecase extends Mock implements SignupUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockGoogleSigninUsecase extends Mock implements GoogleSigninUsecase {}

class MockForgotPasswordUsecase extends Mock implements ForgotPasswordUsecase {}

class MockAppStateResetService extends Mock implements AppStateResetService {}

class FakeUserEntity extends Fake implements UserEntity {
  @override
  String? get uid => "test_uid";
  @override
  String get email => "test@test.com";
}

class FakeSignupUsecaseParam extends Fake implements SignupUsecaseParam {}

class FakeLoginUsecaseParam extends Fake implements LoginUsecaseParam {}

void main() {
  late ProviderContainer container;
  late MockSignupUsecase mockSignupUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockGoogleSigninUsecase mockGoogleSigninUsecase;
  late MockForgotPasswordUsecase mockForgotPasswordUsecase;
  late MockAppStateResetService mockAppStateResetService;

  setUpAll(() {
    registerFallbackValue(FakeSignupUsecaseParam());
    registerFallbackValue(FakeLoginUsecaseParam());
  });

  setUp(() {
    mockSignupUsecase = MockSignupUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockGoogleSigninUsecase = MockGoogleSigninUsecase();
    mockForgotPasswordUsecase = MockForgotPasswordUsecase();
    mockAppStateResetService = MockAppStateResetService();

    when(() => mockAppStateResetService.resetAllState()).thenAnswer((_) {});

    container = ProviderContainer(
      overrides: [
        signupUsecaseProvider.overrideWithValue(mockSignupUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        logoutUsercaseProvider.overrideWithValue(mockLogoutUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        googleSignInUsecaseProvider.overrideWithValue(mockGoogleSigninUsecase),
        forgotPasswordUsecaseProvider.overrideWithValue(
          mockForgotPasswordUsecase,
        ),
        appStateResetServiceProvider.overrideWithValue(
          mockAppStateResetService,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is AuthStatus.initial', () {
    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.initial);
  });

  test('signup success updates state to AuthStatus.registered', () async {
    when(
      () => mockSignupUsecase.call(any()),
    ).thenAnswer((_) async => const Right(true));

    final viewModel = container.read(authViewModelProvider.notifier);
    await viewModel.signup(email: 'test@test.com', password: 'password');

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.registered);
  });
}
