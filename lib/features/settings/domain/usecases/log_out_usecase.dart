import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final logOutUsecaseProvider = Provider((ref) {
  return LogOutUsecase(authRepository: ref.read(authRepositoryProvider));
});

class LogOutUsecase implements UsecaseWithoutParms {
  final IAuthRepository _authRepository;

  LogOutUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return _authRepository.logOut();
  }
}
