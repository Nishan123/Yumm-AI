import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/services/app_state_reset_service.dart';
import 'package:yumm_ai/features/auth/domin/usecases/logout_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/delete_user_verified_usecase.dart';
import 'package:yumm_ai/features/profile/presentation/state/delete_profile_state.dart';

final deleteProfileViewModelProvider =
    NotifierProvider<DeleteProfileViewModel, DeleteProfileState>(
      () => DeleteProfileViewModel(),
    );

class DeleteProfileViewModel extends Notifier<DeleteProfileState> {
  late DeleteUserWithPasswordUsecase _deleteWithPasswordUsecase;
  late DeleteUserWithGoogleUsecase _deleteWithGoogleUsecase;
  late LogoutUsecase _logoutUsecase;
  late AppStateResetService _appStateResetService;

  @override
  DeleteProfileState build() {
    _deleteWithPasswordUsecase = ref.read(
      deleteUserWithPasswordUsecaseProvider,
    );
    _deleteWithGoogleUsecase = ref.read(deleteUserWithGoogleUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsercaseProvider);
    _appStateResetService = ref.read(appStateResetServiceProvider);
    return const DeleteProfileState();
  }

  /// Delete user profile with password verification (for emailPassword auth users)
  Future<void> deleteWithPassword({
    required String uid,
    required String password,
  }) async {
    state = state.copyWith(status: DeleteProfileStatus.loading);

    final result = await _deleteWithPasswordUsecase.call(
      DeleteUserWithPasswordParams(uid: uid, password: password),
    );

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: DeleteProfileStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (success) async {
        // Account deleted successfully, log out and reset app state
        await _performLogoutAndReset();
        state = state.copyWith(
          status: DeleteProfileStatus.success,
          successMessage: "Your account has been deleted successfully",
        );
      },
    );
  }

  /// Delete user profile with Google verification (for Google auth users)
  Future<void> deleteWithGoogle({required String uid}) async {
    state = state.copyWith(status: DeleteProfileStatus.loading);

    final result = await _deleteWithGoogleUsecase.call(
      DeleteUserWithGoogleParams(uid: uid),
    );

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: DeleteProfileStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (success) async {
        // Account deleted successfully, log out and reset app state
        await _performLogoutAndReset();
        state = state.copyWith(
          status: DeleteProfileStatus.success,
          successMessage: "Your account has been deleted successfully",
        );
      },
    );
  }

  /// Log out and reset all app state after successful deletion
  Future<void> _performLogoutAndReset() async {
    await _logoutUsecase.call();
    _appStateResetService.resetAllState();
  }

  /// Reset state back to initial
  void resetState() {
    state = const DeleteProfileState();
  }
}
