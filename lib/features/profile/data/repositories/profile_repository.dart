import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/profile/data/datasource/remote/profile_remote_datasource.dart';
import 'package:yumm_ai/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final remoteDatasource = ref.watch(profileRemoteDatasourceProvider);
  return ProfileRepository(remoteDatasource: remoteDatasource);
});

class ProfileRepository implements IProfileRepository {
  final ProfileRemoteDatasource _remoteDatasource;

  ProfileRepository({required ProfileRemoteDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, String>> updateProfilePic(
    File image,
    String uid,
  ) async {
    try {
      final profilePicUrl = await _remoteDatasource.updateProfilePic(
        image,
        uid,
      );
      return Right(profilePicUrl);
    } on DioException catch (e) {
      debugPrint('ProfileRepository: DioException - ${e.message}');
      final message =
          e.response?.data?['message'] ?? 'Failed to upload profile picture';
      return Left(ApiFailure(message: message));
    } catch (e) {
      debugPrint('ProfileRepository: Exception - $e');
      return Left(ApiFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
    String fullName,
    bool isSubscriberd,
    List<String> allergicIngridents,
    String profilePic,
    String uid
  ) async {
    try {
      await _remoteDatasource.updateProfile(fullName,profilePic,allergicIngridents,isSubscriberd, uid);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
