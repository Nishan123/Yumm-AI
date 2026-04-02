import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/services/storage/token_storage_service.dart';
import 'package:yumm_ai/features/food_pref/data/datasource/food_pref_datasource.dart';
import 'package:yumm_ai/features/food_pref/data/model/food_pref_api_model.dart';

final remoteFoodPrefDatasourceProvider = Provider((ref) {
  return RemoteFoodPrefDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class RemoteFoodPrefDatasource implements IRemoteFoodPrefDatasource {
  final ApiClient _apiClient;
  final TokenStorageService _tokenService;
  RemoteFoodPrefDatasource({
    required ApiClient apiClient,
    required TokenStorageService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<FoodPrefApiModel?> getUserFoodPref(String uid) async {
    final response = await _apiClient.get(ApiEndpoints.getFoodPreference(uid));
    if (response.data['success']) {
      final data = response.data['data'] as Map<String, dynamic>;
      return FoodPrefApiModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<FoodPrefApiModel?> saveFoodPref(FoodPrefApiModel foodPref) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.addFoodPreference,
      data: foodPref.toJson(),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      ),
    );
    if (response.data['success']) {
      final data = response.data['data'] as Map<String, dynamic>;
      return FoodPrefApiModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<FoodPrefApiModel?> updateFoodPref(
    String prefId,
    FoodPrefApiModel foodPref,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.put(
      ApiEndpoints.updateFoodPreference(prefId),
      data: foodPref.toJson(),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      ),
    );
    if (response.data['success']) {
      final data = response.data['data'] as Map<String, dynamic>;
      return FoodPrefApiModel.fromJson(data);
    }
    return null;
  }
}
