import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';

final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, UserEntity?>(
      () => CurrentUserNotifier(),
    );

class CurrentUserNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    return _fetchCurrentUser();
  }

  Future<UserEntity?> _fetchCurrentUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.getCurrentUserFromServer();
    return result.fold(
      (failure) => throw Exception(failure.errorMessage),
      (user) => user,
    );
  }

  /// Refresh user data from the server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCurrentUser());
  }

  /// Update local state after a profile update (optimistic update)
  void updateLocalUser(UserEntity updatedUser) {
    state = AsyncValue.data(updatedUser);
  }
}

/// Select only the user's UID
final currentUserUidProvider = Provider<AsyncValue<String?>>((ref) {
  return ref.watch(currentUserProvider).whenData((user) => user?.uid);
});

/// Select only the user's email
final currentUserEmailProvider = Provider<AsyncValue<String?>>((ref) {
  return ref.watch(currentUserProvider).whenData((user) => user?.email);
});

/// Select only the user's full name
final currentUserNameProvider = Provider<AsyncValue<String?>>((ref) {
  return ref.watch(currentUserProvider).whenData((user) => user?.fullName);
});

/// Select only the user's profile picture URL
final currentUserProfilePicProvider = Provider<AsyncValue<String?>>((ref) {
  return ref.watch(currentUserProvider).whenData((user) => user?.profilePic);
});

/// Select only the user's role
final currentUserRoleProvider = Provider<AsyncValue<String?>>((ref) {
  return ref.watch(currentUserProvider).whenData((user) => user?.role);
});

/// Select only the user's subscription status
final currentUserIsSubscribedProvider = Provider<AsyncValue<bool?>>((ref) {
  return ref
      .watch(currentUserProvider)
      .whenData((user) => user?.isSubscribedUser);
});

/// Select only the user's allergies list
final currentUserAllergiesProvider = Provider<AsyncValue<List<String>?>>((ref) {
  return ref.watch(currentUserProvider).whenData((user) => user?.allergicTo);
});
