import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> signUpWithEmailPassword(UserEntity userEntity);
  Future<Either<Failure, UserEntity>> loginWithEmailPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logOut();
}
