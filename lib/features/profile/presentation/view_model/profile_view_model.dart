import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/providers/user_selectors.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/update_profile_pic_usecase.dart';
import 'package:yumm_ai/features/profile/presentation/state/profile_screen_state.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/profile_card.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileScreenState>(
      () => ProfileViewModel(),
    );

class ProfileViewModel extends Notifier<ProfileScreenState> {
  late final GetCurrentUserUsecase _currentUserUsecase;
  late final UpdateProfilePicUsecase _updateProfilePicUsecase;

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

        state = state.copyWith(profileState: ProfileStates.loaded);
      },
    );
  }

  @override
  ProfileScreenState build() {
    _currentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _updateProfilePicUsecase = ref.read(updateProfilePicUsecaseProvider);
    return const ProfileScreenState();
  }
}
