import 'package:flutter_riverpod/legacy.dart';
import 'package:yumm_ai/features/auth/domin/usecases/change_password_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/verify_password_usecase.dart';
import 'package:yumm_ai/features/auth/presentation/state/change_password_state.dart';

final changePasswordViewModelProvider =
    StateNotifierProvider.autoDispose<
      ChangePasswordViewModel,
      ChangePasswordState
    >((ref) {
      return ChangePasswordViewModel(
        ref.read(verifyPasswordUseCaseProvider),
        ref.read(changePasswordUseCaseProvider),
      );
    });

class ChangePasswordViewModel extends StateNotifier<ChangePasswordState> {
  final VerifyPasswordUseCase _verifyPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordViewModel(
    this._verifyPasswordUseCase,
    this._changePasswordUseCase,
  ) : super(const ChangePasswordState());

  Future<void> verifyOldPassword(String password) async {
    state = state.copyWith(status: ChangePasswordStatus.loading);
    final result = await _verifyPasswordUseCase(password);
    result.fold(
      (failure) => state = state.copyWith(
        status: ChangePasswordStatus.oldPasswordVerificationFailed,
        errorMessage: failure.errorMessage,
      ),
      (isValid) {
        if (isValid) {
          state = state.copyWith(
            status: ChangePasswordStatus.oldPasswordVerified,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            status: ChangePasswordStatus.oldPasswordVerificationFailed,
            errorMessage: "Incorrect old password",
          );
        }
      },
    );
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(status: ChangePasswordStatus.loading);
    final result = await _changePasswordUseCase(
      ChangePasswordParams(oldPassword: oldPassword, newPassword: newPassword),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: ChangePasswordStatus.changePasswordFailed,
        errorMessage: failure.errorMessage,
      ),
      (user) => state = state.copyWith(
        status: ChangePasswordStatus.changePasswordSuccess,
        errorMessage: null,
      ),
    );
  }

  void resetState() {
    state = const ChangePasswordState();
  }
}
