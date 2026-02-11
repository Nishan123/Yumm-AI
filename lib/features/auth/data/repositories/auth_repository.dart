import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/connectivity/network_info.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:yumm_ai/features/auth/data/datasource/remote/remote_auth_datasource.dart';
import 'package:yumm_ai/features/auth/data/datasource/user_datasource.dart';
import 'package:yumm_ai/features/auth/data/model/user_api_model.dart';
import 'package:yumm_ai/features/auth/data/model/user_hive_model.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) {
  final userLocalDataSource = ref.read(authLocalDatasourceProvider);
  final userRemoteDataSource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSessionService = ref.watch(userSessionServiceProvider);
  return AuthRepository(
    userLocalDatasource: userLocalDataSource,
    userRemoteDatasource: userRemoteDataSource,
    networkInfo: networkInfo,
    userSessionService: userSessionService,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _userLocalDatasource;
  final IAuthRemoteDatasource _userRemoteDatasource;
  final NetworkInfo _networkInfo;
  final UserSessionService _userSessionService;

  AuthRepository({
    required IAuthLocalDatasource userLocalDatasource,
    required IAuthRemoteDatasource userRemoteDatasource,
    required NetworkInfo networkInfo,
    required UserSessionService userSessionService,
  }) : _userLocalDatasource = userLocalDatasource,
       _userRemoteDatasource = userRemoteDatasource,
       _networkInfo = networkInfo,
       _userSessionService = userSessionService;

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final userApiModel = await _userRemoteDatasource.loginWithEmailPassword(
          email,
          password,
        );
        if (userApiModel != null) {
          return Right(userApiModel.toEntity());
        }
        return Left(ApiFailure(message: "Login Failed"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"],
            statusCode: e.response?.statusCode,
          ),
        );
      }
    } else {
      try {
        final user = await _userLocalDatasource.loginWithEmailPassword(
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
  }

  @override
  Future<Either<Failure, bool>> signUpWithEmailPassword(
    UserEntity userEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = UserApiModel.fromEntity(userEntity);
        await _userRemoteDatasource.signWithEmailPassword(user);
        return Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')),
        );
      }
    } else {
      try {
        // convert entity to model
        final model = UserHiveModel.fromEntity(userEntity);
        final result = await _userLocalDatasource.signWithEmailPassword(model);
        if (result) {
          return Right(true);
        }
        return Left(LocalDatabaseFailure(message: "Failed to Signup"));
      } catch (e) {
        return Left((LocalDatabaseFailure(message: "$e")));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // First try to get user from session service (SharedPreferences)
      // This is where API login stores the user data
      final sessionUser = _userSessionService.getCurrentUser();
      if (sessionUser != null) {
        return Right(sessionUser.toEntity());
      }

      // Fall back to local Hive storage for offline scenarios
      final user = await _userLocalDatasource.getCurrentUser();
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
  Future<Either<Failure, UserEntity>> getCurrentUserFromServer() async {
    if (await _networkInfo.isConnected) {
      try {
        final userApiModel = await _userRemoteDatasource.getCurrentUser();
        if (userApiModel != null) {
          // Update local session cache with fresh data from server
          await _userSessionService.saveUserSession(userApiModel);
          return Right(userApiModel.toEntity());
        }
        return Left(ApiFailure(message: "Failed to fetch user from server"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Network error",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: "$e"));
      }
    } else {
      // No network - fall back to local storage
      return getCurrentUser();
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle(String idToken) async {
    if (await _networkInfo.isConnected) {
      try {
        final userApiModel = await _userRemoteDatasource.signInWithGoogle(
          idToken,
        );
        if (userApiModel != null) {
          return Right(userApiModel.toEntity());
        }
        return Left(ApiFailure(message: "Google Sign-In failed"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Google Sign-In failed",
            statusCode: e.response?.statusCode,
          ),
        );
      }
    } else {
      return Left(
        ApiFailure(
          message: "No internet connection. Google Sign-In requires network.",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final result = await _userLocalDatasource.logOut();
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to log out"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "$e"));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPassword(String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final uid = _userSessionService.getCurrentUserUid();
        if (uid == null) {
          return Left(ApiFailure(message: "User not logged in"));
        }
        final result = await _userRemoteDatasource.verifyPassword(
          uid,
          password,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Failed to verify password",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: "$e"));
      }
    } else {
      return Left(
        ApiFailure(message: "No internet connection. Cannot verify password."),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final uid = _userSessionService.getCurrentUserUid();
        if (uid == null) {
          return Left(ApiFailure(message: "User not logged in"));
        }
        final userApiModel = await _userRemoteDatasource.changePassword(
          uid,
          oldPassword,
          newPassword,
        );

        if (userApiModel != null) {
          // Update session with new user data if necessary
          // For password change, token might stay same but let's ensure session is fresh
          await _userSessionService.saveUserSession(userApiModel);
          return Right(userApiModel.toEntity());
        }
        return Left(
          ApiFailure(message: "Failed to change password. Please try again."),
        );
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Failed to change password",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: "$e"));
      }
    } else {
      return Left(
        ApiFailure(message: "No internet connection. Cannot change password."),
      );
    }
  }
}
