import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';

abstract interface class IProfileRepository {
  /// Updates the user's profile picture
  /// Returns the URL of the uploaded profile picture on success
  Future<Either<Failure, String>> updateProfilePic(File image, String uid);
}
