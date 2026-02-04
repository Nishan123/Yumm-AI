import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/providers/user_selectors.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_from_server_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/update_profile_pic_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:yumm_ai/features/profile/presentation/state/profile_screen_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileScreenState>(
      () => ProfileViewModel(),
    );

class ProfileViewModel extends Notifier<ProfileScreenState> {
  late GetCurrentUserUsecase _currentUserUsecase;
  late UpdateProfilePicUsecase _updateProfilePicUsecase;
  late UpdateProfileUsecase _updateProfileUsecase;
  late GetCurrentUserFromServerUsecase _getCurrentUserFromServerUsecase;

  Future<void> getCurrentUser() async {
    state = state.copyWith(profileState: ProfileStates.loading);
    final result = await _currentUserUsecase.call();
    result.fold(
      (failure) {
        state = state.copyWith(
          profileState: ProfileStates.error,
          errorMsg: failure.errorMessage,
        );
      },
      (success) {
        state = state.copyWith(
          profileState: ProfileStates.loaded,
          userData: success,
        );
      },
    );
  }

  Future<void> updateProfilePic(File image) async {
    // Get the current user's uid
    final uid = ref.read(userUidProvider);
    if (uid == null) {
      state = state.copyWith(
        profileState: ProfileStates.error,
        errorMsg: 'User not logged in',
      );
      return;
    }

    state = state.copyWith(profileState: ProfileStates.loading);

    final params = UpdateProfilePicParams(image: image, uid: uid);
    final result = await _updateProfilePicUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          profileState: ProfileStates.error,
          errorMsg: failure.errorMessage,
        );
      },
      (profilePicUrl) {
        // Update local session storage with new profile pic URL
        ref.read(userSessionServiceProvider).updateProfilePic(profilePicUrl);

        // Invalidate providers to trigger UI refresh
        ref.invalidate(currentUserProvider);
        ref.invalidate(userProfilePicProvider);

        // Update cache key to bust image cache
        ref.read(profilePicCacheKeyProvider.notifier).state =
            DateTime.now().millisecondsSinceEpoch;

        state = state.copyWith(
          profileState: ProfileStates.success,
          message: "Profile image updated",
        );
      },
    );
  }

  Future<void> updateProfile({
    required String fullName,
    required List<String> allergicIng,
    required bool isSubscribed,
    required String profilePic,
    File? imageFile,
  }) async {
    final uid = ref.read(userUidProvider);
    if (uid == null) {
      state = state.copyWith(
        profileState: ProfileStates.error,
        errorMsg: 'User not logged in',
      );
      return;
    }

    state = ProfileScreenState(
      profileState: ProfileStates.loading,
      userData: state.userData,
    );

    String finalProfilePicUrl = profilePic;

    if (imageFile != null) {
      final params = UpdateProfilePicParams(image: imageFile, uid: uid);
      final picResult = await _updateProfilePicUsecase.call(params);

      picResult.fold(
        (failure) {
          state = state.copyWith(
            profileState: ProfileStates.error,
            errorMsg: failure.errorMessage,
          );
          return;
        },
        (newUrl) {
          finalProfilePicUrl = newUrl;
          // Update local session storage with new profile pic URL
          ref.read(userSessionServiceProvider).updateProfilePic(newUrl);

          // Invalidate providers to trigger UI refresh
          ref.invalidate(currentUserProvider);
          ref.invalidate(userProfilePicProvider);

          // Update cache key to bust image cache
          ref.read(profilePicCacheKeyProvider.notifier).state =
              DateTime.now().millisecondsSinceEpoch;
        },
      );
      if (state.profileState == ProfileStates.error) return;
    }

    final result = await _updateProfileUsecase.call(
      UpdateProfileParams(
        fullName: fullName,
        uid: uid,
        allergicIng: allergicIng,
        isSubscribed: isSubscribed,
        profilePic: finalProfilePicUrl,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          profileState: ProfileStates.error,
          errorMsg: failure.errorMessage,
        );
      },
      (success) async {
        // Fetch fresh data from server to update session and UI
        await _refreshUserData();
        state = state.copyWith(
          profileState: ProfileStates.success,
          message: "Profile Updated Successfully",
        );
      },
    );
  }

  Future<void> _refreshUserData() async {
    final result = await _getCurrentUserFromServerUsecase.call();
    result.fold(
      (failure) {
        // Even if refresh fails, we can try to rely on current state,
        // but better to show error or just finish loading
        state = state.copyWith(
          profileState: ProfileStates.loaded, // Or error?
          // If we fail to refresh, we might want to keep the old data visible
        );
      },
      (user) {
        // Invalidate providers to trigger UI refresh with new data
        ref.invalidate(currentUserProvider);
        state = state.copyWith(
          profileState: ProfileStates.loaded,
          userData: user,
        );
      },
    );
  }

  @override
  ProfileScreenState build() {
    _currentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _updateProfilePicUsecase = ref.read(updateProfilePicUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _getCurrentUserFromServerUsecase = ref.read(
      getCurrentUserFromServerUsecaseProvider,
    );
    return const ProfileScreenState();
  }
}
