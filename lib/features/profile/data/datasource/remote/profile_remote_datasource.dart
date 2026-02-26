import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/storage/token_storage_service.dart';
import 'package:yumm_ai/features/profile/data/datasource/profile_datasource.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorageService = ref.watch(tokenServiceProvider);
  return ProfileRemoteDatasource(
    apiClient: apiClient,
    tokenStorageService: tokenStorageService,
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final TokenStorageService _tokenStorageService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required TokenStorageService tokenStorageService,
  }) : _apiClient = apiClient,
       _tokenStorageService = tokenStorageService;

  // Update profile
  @override
  Future<String> updateProfilePic(File image, String uid) async {
    // Use path package for cross-platform filename extraction
    final fileName = p.basename(image.path);
    final formData = FormData.fromMap({
      "profilePic": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });
    final token = await _tokenStorageService.getToken();
    debugPrint('ProfileRemoteDatasource: Uploading profile pic for uid: $uid');

    final response = await _apiClient.uploadFile(
      formData: formData,
      ApiEndpoints.updateProfilePic(uid),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      ),
    );

    debugPrint('ProfileRemoteDatasource: Response data: ${response.data}');
    final data = response.data["data"];

    if (data is String) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final profilePicUrl = data["profilePic"] as String?;
      if (profilePicUrl != null) {
        debugPrint('ProfileRemoteDatasource: Profile pic URL: $profilePicUrl');
        return profilePicUrl;
      }
      throw Exception('Profile pic URL not found in response map');
    }

    throw Exception('Unexpected response format: ${data.runtimeType}');
  }

  @override
  Future<void> updateProfile(
    String fullName,
    String profilePic,
    List<String> allergicIng,
    bool isSubscribed,
    String uid,
  ) async {
    final token = await _tokenStorageService.getToken();
    await _apiClient.put(
      ApiEndpoints.updateUser(uid),
      data: {
        'fullName': fullName,
        'profilePic': profilePic,
        'allergenicIngredients': allergicIng,
        'isSubscribedUser': isSubscribed,
      },
      options: Options(
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      ),
    );
  }

  @override
  Future<bool> deleteProfile(String uid, [String? reason]) async {
    final token = await _tokenStorageService.getToken();
    final response = await _apiClient.delete(
      ApiEndpoints.deleteUser(uid),
      data: reason != null ? {'reason': reason} : null,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      ),
    );

    final success = response.data["success"] as bool;
    if (success) {
      return true;
    }
    throw Exception(ApiFailure(message: "${response.data['message']}"));
  }

  @override
  Future<bool> deleteProfileWithPassword(
    String uid,
    String password, [
    String? reason,
  ]) async {
    final token = await _tokenStorageService.getToken();
    final response = await _apiClient.delete(
      ApiEndpoints.deleteUserWithPassword(uid),
      data: {'password': password, if (reason != null) 'reason': reason},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      ),
    );

    final success = response.data["success"] as bool;
    if (success) {
      return true;
    }
    throw Exception(ApiFailure(message: "${response.data['message']}"));
  }

  @override
  Future<bool> deleteProfileWithGoogle(
    String uid,
    String idToken, [
    String? reason,
  ]) async {
    final token = await _tokenStorageService.getToken();
    final response = await _apiClient.delete(
      ApiEndpoints.deleteUserWithGoogle(uid),
      data: {'idToken': idToken, if (reason != null) 'reason': reason},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      ),
    );

    final success = response.data["success"] as bool;
    if (success) {
      return true;
    }
    throw Exception(ApiFailure(message: "${response.data['message']}"));
  }
}
