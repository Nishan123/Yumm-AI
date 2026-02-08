import 'dart:io';

abstract interface class IProfileRemoteDatasource {
  Future<String> updateProfilePic(File image, String uid);
  Future<void> updateProfile(
    String fullName,
    String profilePic,
    List<String> allergicIng,
    bool isSubscribed,
    String uid,
  );
  Future<bool> deleteProfile(String uid);
  Future<bool> deleteProfileWithPassword(String uid, String password);
  Future<bool> deleteProfileWithGoogle(String uid, String idToken);
}
