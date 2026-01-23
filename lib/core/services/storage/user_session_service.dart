import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/features/auth/data/model/user_api_model.dart';

// SharedPreferences instance provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

// UserSessionService provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  // Keys for storing user data
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUid = 'user_uid';
  static const String _keyEmail = 'user_email';
  static const String _keyRole = 'user_role';
  static const String _keyFullName = 'user_full_name';
  static const String _keyProfilePic = 'user_profile_pic';
  static const String _keyAllergicTo = 'user_allergic_to';
  static const String _keyAuthProvider = 'user_auth_provider';
  static const String _keyIsSubscribed = 'user_is_subscribed';
  static const String _keyCreatedAt = 'user_created_at';
  static const String _keyUpdatedAt = 'user_updated_at';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // Save user session after login using UserApiModel
  Future<void> saveUserSession(UserApiModel user) async {
    await _prefs.setBool(_keyIsLoggedIn, true);

    if (user.uid != null) {
      await _prefs.setString(_keyUid, user.uid!);
    }
    await _prefs.setString(_keyEmail, user.email);
    await _prefs.setString(_keyFullName, user.fullName);
    await _prefs.setString(_keyAuthProvider, user.authProvider);

    if (user.role != null) {
      await _prefs.setString(_keyRole, user.role!);
    }
    if (user.profilePic != null) {
      await _prefs.setString(_keyProfilePic, user.profilePic!);
    }
    if (user.allergicTo != null) {
      await _prefs.setString(_keyAllergicTo, jsonEncode(user.allergicTo));
    }
    if (user.isSubscribedUser != null) {
      await _prefs.setBool(_keyIsSubscribed, user.isSubscribedUser!);
    }
    if (user.createdAt != null) {
      await _prefs.setString(_keyCreatedAt, user.createdAt!.toIso8601String());
    }
    if (user.updatedAt != null) {
      await _prefs.setString(_keyUpdatedAt, user.updatedAt!.toIso8601String());
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get current user as UserApiModel
  UserApiModel? getCurrentUser() {
    if (!isLoggedIn()) return null;

    final email = _prefs.getString(_keyEmail);
    final fullName = _prefs.getString(_keyFullName);
    final authProvider = _prefs.getString(_keyAuthProvider);

    if (email == null || fullName == null || authProvider == null) {
      return null;
    }

    List<String>? allergicTo;
    final allergicToJson = _prefs.getString(_keyAllergicTo);
    if (allergicToJson != null) {
      allergicTo = (jsonDecode(allergicToJson) as List).cast<String>();
    }

    DateTime? createdAt;
    final createdAtStr = _prefs.getString(_keyCreatedAt);
    if (createdAtStr != null) {
      createdAt = DateTime.tryParse(createdAtStr);
    }

    DateTime? updatedAt;
    final updatedAtStr = _prefs.getString(_keyUpdatedAt);
    if (updatedAtStr != null) {
      updatedAt = DateTime.tryParse(updatedAtStr);
    }

    return UserApiModel(
      uid: _prefs.getString(_keyUid),
      email: email,
      role: _prefs.getString(_keyRole),
      fullName: fullName,
      profilePic: _prefs.getString(_keyProfilePic),
      allergicTo: allergicTo,
      authProvider: authProvider,
      isSubscribedUser: _prefs.getBool(_keyIsSubscribed),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Get current user UID
  String? getCurrentUserUid() {
    return _prefs.getString(_keyUid);
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _prefs.getString(_keyEmail);
  }

  // Get current user role
  String? getCurrentUserRole() {
    return _prefs.getString(_keyRole);
  }

  // Get current user full name
  String? getCurrentUserFullName() {
    return _prefs.getString(_keyFullName);
  }

  // Get current user profile picture
  String? getCurrentUserProfilePic() {
    return _prefs.getString(_keyProfilePic);
  }

  // Get current user allergies
  List<String>? getCurrentUserAllergies() {
    final allergicToJson = _prefs.getString(_keyAllergicTo);
    if (allergicToJson != null) {
      return (jsonDecode(allergicToJson) as List).cast<String>();
    }
    return null;
  }

  // Get current user auth provider
  String? getCurrentUserAuthProvider() {
    return _prefs.getString(_keyAuthProvider);
  }

  // Get current user subscription status
  bool? getCurrentUserIsSubscribed() {
    return _prefs.getBool(_keyIsSubscribed);
  }

  // Get current user created date
  DateTime? getCurrentUserCreatedAt() {
    final createdAtStr = _prefs.getString(_keyCreatedAt);
    if (createdAtStr != null) {
      return DateTime.tryParse(createdAtStr);
    }
    return null;
  }

  // Get current user updated date
  DateTime? getCurrentUserUpdatedAt() {
    final updatedAtStr = _prefs.getString(_keyUpdatedAt);
    if (updatedAtStr != null) {
      return DateTime.tryParse(updatedAtStr);
    }
    return null;
  }

  // Update user allergies
  Future<void> updateAllergies(List<String> allergies) async {
    await _prefs.setString(_keyAllergicTo, jsonEncode(allergies));
  }

  // Update user profile picture
  Future<void> updateProfilePic(String profilePic) async {
    await _prefs.setString(_keyProfilePic, profilePic);
  }

  // Update user subscription status
  Future<void> updateSubscriptionStatus(bool isSubscribed) async {
    await _prefs.setBool(_keyIsSubscribed, isSubscribed);
  }

  // Clear user session (logout)
  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUid);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyFullName);
    await _prefs.remove(_keyProfilePic);
    await _prefs.remove(_keyAllergicTo);
    await _prefs.remove(_keyAuthProvider);
    await _prefs.remove(_keyIsSubscribed);
    await _prefs.remove(_keyCreatedAt);
    await _prefs.remove(_keyUpdatedAt);
  }
}
