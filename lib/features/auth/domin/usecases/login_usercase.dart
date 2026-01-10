// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

class LoginUsecaseParam extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParam({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final loginUsecaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase implements UsecaseWithParms<UserEntity, LoginUsecaseParam> {
  final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUsecaseParam params) {
    return _authRepository.loginWithEmailPassword(
      params.email,
      params.password,
    );
  }
}
