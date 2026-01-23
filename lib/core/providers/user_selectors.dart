import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';


// Basic user identification providers
final userUidProvider = Provider<String?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserUid();
});

final userEmailProvider = Provider<String?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserEmail();
});

final userNameProvider = Provider<String?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserFullName();
});

// Profile-related providers
final userProfilePicProvider = Provider<String?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserProfilePic();
});

final userRoleProvider = Provider<String?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserRole();
});

final userIsSubscribedProvider = Provider<bool?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserIsSubscribed();
});

final userAllergiesProvider = Provider<List<String>?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserAllergies();
});

final userAuthProviderProvider = Provider<String?>((ref) {
  return ref.watch(userSessionServiceProvider).getCurrentUserAuthProvider();
});

// Check if user is logged in
final isUserLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(userSessionServiceProvider).isLoggedIn();
});

/// Combined selectors for common use cases
/// Use these when you need multiple related fields together

// Profile card data - name, email, profile pic, subscription status
final userProfileCardDataProvider = Provider<UserProfileCardData>((ref) {
  final service = ref.watch(userSessionServiceProvider);
  return UserProfileCardData(
    fullName: service.getCurrentUserFullName(),
    email: service.getCurrentUserEmail(),
    profilePic: service.getCurrentUserProfilePic(),
    isSubscribed: service.getCurrentUserIsSubscribed(),
  );
});

// Basic info - just name and email
final userBasicInfoProvider = Provider<UserBasicInfo>((ref) {
  final service = ref.watch(userSessionServiceProvider);
  return UserBasicInfo(
    fullName: service.getCurrentUserFullName(),
    email: service.getCurrentUserEmail(),
  );
});

// Avatar data - profile pic and name (for fallback initial)
final userAvatarDataProvider = Provider<UserAvatarData>((ref) {
  final service = ref.watch(userSessionServiceProvider);
  return UserAvatarData(
    profilePic: service.getCurrentUserProfilePic(),
    fullName: service.getCurrentUserFullName(),
  );
});

/// Data classes for combined selectors

class UserProfileCardData {
  final String? fullName;
  final String? email;
  final String? profilePic;
  final bool? isSubscribed;

  const UserProfileCardData({
    this.fullName,
    this.email,
    this.profilePic,
    this.isSubscribed,
  });
}

class UserBasicInfo {
  final String? fullName;
  final String? email;

  const UserBasicInfo({this.fullName, this.email});
}

class UserAvatarData {
  final String? profilePic;
  final String? fullName;

  const UserAvatarData({this.profilePic, this.fullName});

  String get initial =>
      (fullName?.isNotEmpty == true) ? fullName![0].toUpperCase() : 'U';
}
