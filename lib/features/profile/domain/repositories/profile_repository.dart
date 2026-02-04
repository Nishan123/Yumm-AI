import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';

abstract interface class IProfileRepository {

  Future<Either<Failure, String>> updateProfilePic(File image, String uid);

  Future<Either<Failure, void>> updateProfile(String fullName, bool isSubscriberd, List<String> allergicIngridents, String profilePic, String uid);

}
