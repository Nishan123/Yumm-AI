import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  return ForgotPasswordUsecase(
    authRepository: ref.read(authRepositoryProvider),
  );
});

class ForgotPasswordUsecase implements UsecaseWithParms<void, String> {
  final IAuthRepository _authRepository;

  ForgotPasswordUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await _authRepository.forgotPassword(params);
  }
}
