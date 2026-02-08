import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/profile/data/repositories/profile_repository.dart';
import 'package:yumm_ai/features/profile/domain/repositories/profile_repository.dart';

class DeleteUserUsecaseParams {
  String uid;

  DeleteUserUsecaseParams({required this.uid});
}

final deleteUserUsecaseProvider = Provider((ref) {
  return DeleteUserUsecase(
    iprofileRepository: ref.watch(profileRepositoryProvider),
  );
});

class DeleteUserUsecase
    implements UsecaseWithParms<bool, DeleteUserUsecaseParams> {
  final IProfileRepository _iProfileRepository;
  DeleteUserUsecase({required IProfileRepository iprofileRepository})
    : _iProfileRepository = iprofileRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteUserUsecaseParams params) async {
    return await _iProfileRepository.deleteUser(params.uid);
  }
}
