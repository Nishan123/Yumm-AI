import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final changePasswordUseCaseProvider = Provider((ref) {
  return ChangePasswordUseCase(ref.read(authRepositoryProvider));
});

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class ChangePasswordUseCase
    implements UsecaseWithParms<UserEntity, ChangePasswordParams> {
  final IAuthRepository _authRepository;

  ChangePasswordUseCase(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(ChangePasswordParams params) {
    return _authRepository.changePassword(
      params.oldPassword,
      params.newPassword,
    );
  }
}
