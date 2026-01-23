import 'dart:io';

abstract interface class IProfileRemoteDatasource {
  Future<String> updateProfilePic(File image, String uid);
}
