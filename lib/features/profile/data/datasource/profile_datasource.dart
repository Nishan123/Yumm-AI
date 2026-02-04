import 'dart:io';

abstract interface class IProfileRemoteDatasource {
  Future<String> updateProfilePic(File image, String uid);
  Future<void> updateProfile(String fullName, String profilePic, List<String> allergicIng, bool isSubscribed, String uid);
}
