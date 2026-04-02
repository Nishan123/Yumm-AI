import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';

final tokenServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService(apiClient: ref.read(apiClientProvider));
});

class TokenStorageService {
  final ApiClient _apiClient;

  TokenStorageService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<void> saveToken(String token) async {
    await _apiClient.saveTokens(accessToken: token);
  }

  Future<String?> getToken() async {
    return _apiClient.getAccessToken();
  }

  Future<void> deleteToken() async {
    await _apiClient.clearTokens();
  }
}
