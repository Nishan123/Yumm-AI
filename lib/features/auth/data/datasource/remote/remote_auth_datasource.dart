import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/datasource/user_datasource.dart';
import 'package:yumm_ai/features/auth/data/model/user_api_model.dart';

final authRemoteDatasourceProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return RemoteAuthDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
  );
});

class RemoteAuthDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  RemoteAuthDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<UserApiModel?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    throw UnimplementedError();
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
      final registeredUser = UserApiModel.fromJson(data);
      return registeredUser;
    }
    // Throw an exception with the error message so the error is properly handled
    throw Exception(response.data['message'] ?? 'Signup failed');
  }
}
