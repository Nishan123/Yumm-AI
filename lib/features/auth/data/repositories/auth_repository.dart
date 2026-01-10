import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:yumm_ai/features/auth/data/datasource/user_datasource.dart';
import 'package:yumm_ai/features/auth/data/model/user_hive_model.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) {
  final userDataSource = ref.read(authLocalDatasourceProvider);
  return AuthRepository(userDatasource: userDataSource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _userDatasource;
  AuthRepository({required IAuthDatasource userDatasource})
    : _userDatasource = userDatasource;

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await _userDatasource.loginWithEmailPassword(
        email,
        password,
      );
      if (user != null) {
        return Right(user.toEntity());
      }
      return Left(LocalDatabaseFailure(message: "Invalid email or password"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "$e"));
    }
  }

  @override
  Future<Either<Failure, bool>> signUpWithEmailPassword(
    UserEntity userEntity,
  ) async {
    try {
      // convert entity to model
      final model = UserHiveModel.fromEntity(userEntity);
      final result = await _userDatasource.signWithEmailPassword(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to Signup"));
    } catch (e) {
      return Left((LocalDatabaseFailure(message: "$e")));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _userDatasource.getCurrentUser();
      if (user != null) {
        return Right(user.toEntity());
      }
      return Left(
        LocalDatabaseFailure(message: "No user is currently logged in"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "$e"));
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final result = await _userDatasource.logOut();
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to log out"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "$e"));
    }
  }
}
