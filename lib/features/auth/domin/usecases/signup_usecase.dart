// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

class SignupUsecaseParam extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String authProvider;

  const SignupUsecaseParam({
    required this.email,
    required this.password,
    required this.fullName,
    this.authProvider = "email_password",
  });

  @override
  List<Object> get props => [email, password, fullName, authProvider];
}

final signupUsecaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignupUsecase(authRepository: authRepository);
});

class SignupUsecase implements UsecaseWithParms<bool, SignupUsecaseParam> {
  final IAuthRepository _authRepository;
  SignupUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, bool>> call(params) async {
    final entity = UserEntity(
      email: params.email,
      fullName: params.fullName,
      authProvider: params.authProvider,
      password: params.password,
    );
    return _authRepository.signUpWithEmailPassword(entity);
  }
}
