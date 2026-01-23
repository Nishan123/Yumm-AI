import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/profile/data/repositories/profile_repository.dart';
import 'package:yumm_ai/features/profile/domain/repositories/profile_repository.dart';

final updateProfilePicUsecaseProvider = Provider((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return UpdateProfilePicUsecase(profileRepository: profileRepository);
});

class UpdateProfilePicParams {
  final File image;
  final String uid;

  const UpdateProfilePicParams({required this.image, required this.uid});
}

class UpdateProfilePicUsecase
    implements UsecaseWithParms<String, UpdateProfilePicParams> {
  final IProfileRepository _profileRepository;

  UpdateProfilePicUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, String>> call(UpdateProfilePicParams params) {
    return _profileRepository.updateProfilePic(params.image, params.uid);
  }
}
