import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/profile/data/repositories/profile_repository.dart';
import 'package:yumm_ai/features/profile/domain/repositories/profile_repository.dart';

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return UpdateProfileUsecase(profileRepository);
});

class UpdateProfileParams {
  final String fullName;
  final String uid;
  final List<String> allergicIng;
  final bool isSubscribed;
  final String profilePic;

  UpdateProfileParams({
    required this.fullName,
    required this.uid,
    required this.allergicIng,
    required this.isSubscribed, required this.profilePic,
  });
}

class UpdateProfileUsecase
    implements UsecaseWithParms<void, UpdateProfileParams> {
  final IProfileRepository _profileRepository;

  UpdateProfileUsecase(this._profileRepository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) async {
    return await _profileRepository.updateProfile(
      params.fullName,
      params.isSubscribed,
      params.allergicIng,
      params.profilePic,
      params.uid
    );
  }
}
