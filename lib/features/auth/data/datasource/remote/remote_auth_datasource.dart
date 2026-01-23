import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/services/storage/token_storage_service.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/datasource/user_datasource.dart';
import 'package:yumm_ai/features/auth/data/model/user_api_model.dart';

final authRemoteDatasourceProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  final tokenStorageService = ref.read(tokenServiceProvider);
  return RemoteAuthDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
    tokenStorageService: tokenStorageService,
  );
});

class RemoteAuthDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenStorageService _tokenStorageService;

  RemoteAuthDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenStorageService tokenStorageService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenStorageService = tokenStorageService;

  @override
  Future<UserApiModel?> getCurrentUser() async {
    final response = await _apiClient.get(
      ApiEndpoints.getCurrentUser(_userSessionService.getCurrentUserUid()!),
    );
    if (response.data["success"]) {
      final userData = response.data["data"] as Map<String, dynamic>;
      return UserApiModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<bool> logOut() async {
    await _tokenStorageService.deleteToken();
    await _userSessionService.clearSession();
    return true;
  }

  @override
  Future<UserApiModel?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );
    if (response.data["success"]) {
      final user = response.data["data"]["user"] as Map<String, dynamic>;
      final token = response.data["data"]["token"] as String;
      _tokenStorageService.saveToken(token);
      final userModel = UserApiModel.fromJson(user);

      _userSessionService.saveUserSession(userModel);
      return userModel;
    } else {
      return null;
    }
  }

  @override
  Future<UserApiModel> signWithEmailPassword(UserApiModel userModel) async {
    final response = await _apiClient.post(
      ApiEndpoints.signup,
      data: userModel.toJson(),
    );
    if (response.data['success'] == true) {
      final data = response.data["data"]["user"] as Map<String, dynamic>;
      final token = response.data["data"]["token"] as String;
      _tokenStorageService.saveToken(token);
      final registeredUser = UserApiModel.fromJson(data);
      return registeredUser;
    }
    // Throw an exception with the error message so the error is properly handled
    throw Exception(response.data['message'] ?? 'Signup failed');
  }

  @override
  Future<UserApiModel?> signInWithGoogle(String idToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.googleSignIn,
      data: {"idToken": idToken},
    );
    if (response.data["success"]) {
      final user = response.data["data"]["user"] as Map<String, dynamic>;
      final token = response.data["data"]["token"] as String;
      _tokenStorageService.saveToken(token);
      final userModel = UserApiModel.fromJson(user);
      _userSessionService.saveUserSession(userModel);
      return userModel;
    } else {
      return null;
    }
  }
}
