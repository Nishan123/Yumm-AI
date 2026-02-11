import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final verifyPasswordUseCaseProvider = Provider((ref) {
  return VerifyPasswordUseCase(ref.read(authRepositoryProvider));
});

class VerifyPasswordUseCase implements UsecaseWithParms<bool, String> {
  final IAuthRepository _authRepository;

  VerifyPasswordUseCase(this._authRepository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _authRepository.verifyPassword(params);
  }
}
