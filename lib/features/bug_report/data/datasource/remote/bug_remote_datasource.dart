import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/services/storage/token_storage_service.dart';
import 'package:yumm_ai/features/bug_report/data/datasource/bug_datasource.dart';
import 'package:yumm_ai/features/bug_report/data/model/bug_report_model.dart';

final remoteBugReportProvider = Provider((ref) {
  return BugReportRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class BugReportRemoteDataSource implements IRemoteBugDatasource {
  final ApiClient _apiClient;
  final TokenStorageService _tokenService;

  BugReportRemoteDataSource({
    required ApiClient apiClient,
    required TokenStorageService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<BugReportModel> reportBug(BugReportModel bugReport) async {
    try {
      final token = await _tokenService.getToken();
      final response = await _apiClient.post(
        ApiEndpoints.reportBug,
        data: bugReport.toJson(),
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        ),
      );
      return BugReportModel.fromJson(response.data['data']);
    } catch (e) {
      debugPrint("BugReportRemoteDataSource error: $e");
      rethrow;
    }
  }

  @override
  Future<String> uploadScreenshot(Uint8List screenshot) async {
    try {
      final token = await _tokenService.getToken();
      final formData = FormData.fromMap({
        'screenshot': MultipartFile.fromBytes(
          screenshot,
          filename: 'bug_screenshot.png',
        ),
      });

      final response = await _apiClient.post(
        ApiEndpoints.uploadBugReportImage,
        data: formData,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        ),
      );

      return response.data['data']['imageUrl'];
    } catch (e) {
      debugPrint("UploadScreenshot error: $e");
      rethrow;
    }
  }
}
