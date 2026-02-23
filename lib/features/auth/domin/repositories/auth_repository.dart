import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> signUpWithEmailPassword(UserEntity userEntity);
  Future<Either<Failure, UserEntity>> loginWithEmailPassword(
    String email,
    String password,
  );

  /// Gets current user from local storage (SharedPreferences/Hive)
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Gets current user from the server/database (requires network)
  Future<Either<Failure, UserEntity>> getCurrentUserFromServer();
  Future<Either<Failure, UserEntity>> signInWithGoogle(String idToken);
  Future<Either<Failure, bool>> logOut();
  Future<Either<Failure, bool>> verifyPassword(String password);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, UserEntity>> changePassword(
    String oldPassword,
    String newPassword,
  );
}
