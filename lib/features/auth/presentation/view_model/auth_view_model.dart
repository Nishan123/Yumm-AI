import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/services/app_state_reset_service.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/login_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/logout_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/signup_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/google_signin_usecase.dart';

import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final SignupUsecase _signupUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final GoogleSigninUsecase _googleSignInUsecase;
  late final AppStateResetService _appStateResetService;

  @override
  AuthState build() {
    _signupUsecase = ref.read(signupUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsercaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _googleSignInUsecase = ref.read(googleSignInUsecaseProvider);
    _appStateResetService = ref.read(appStateResetServiceProvider);
    return const AuthState();
  }

  Future<void> signup({
    required String email,
    required String password,
    String? fullName,
    String authProvider = "emailPassword",
  }) async {
    state = state.copyWith(status: AuthStatus.emailPasswordLoading);
    final params = SignupUsecaseParam(
      email: email,
      password: password,
      fullName: fullName ?? email,
      authProvider: authProvider,
    );
    final result = await _signupUsecase.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (isRegistered) {
        if (isRegistered) {
          state = state.copyWith(status: AuthStatus.registered);
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Signup failed",
          );
        }
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    // Clear any previously cached state before login
    _appStateResetService.resetAllState();

    state = state.copyWith(status: AuthStatus.emailPasswordLoading);
    final result = await _loginUsecase.call(
      LoginUsecaseParam(email: email, password: password),
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (user) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.emailPasswordLoading);
    final result = await _logoutUsecase.call();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (isLoggedOut) {
        if (isLoggedOut) {
          // Reset all app state providers to clear previous user's data
          _appStateResetService.resetAllState();
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Logout failed",
          );
        }
      },
    );
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.emailPasswordLoading);
    final result = await _getCurrentUserUsecase.call();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: failure.errorMessage,
        );
      },
      (user) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    // Clear any previously cached state before login
    _appStateResetService.resetAllState();

    state = state.copyWith(status: AuthStatus.googleAuthLoading);
    final result = await _googleSignInUsecase.call();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (user) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      },
    );
  }
}
