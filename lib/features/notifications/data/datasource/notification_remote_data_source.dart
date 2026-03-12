import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/notifications/data/model/notification_model.dart';

final notificationRemoteDataSourceProvider = Provider(
  (ref) => NotificationRemoteDataSource(apiClient: ref.read(apiClientProvider)),
);

class NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSource({required this.apiClient});

  Future<Either<Failure, List<NotificationModel>>> getNotificationLogs(
    int page,
    int limit,
  ) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getNotificationLogs,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['logs'];
        final notifications = data
            .map((e) => NotificationModel.fromJson(e))
            .toList();
        return Right(notifications);
      } else {
        return Left(
          GeneralFailure(
            response.statusMessage ?? 'Failed to load notifications',
          ),
        );
      }
    } on DioException catch (e) {
      String errorMessage = e.message ?? 'Failed to load notifications';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return Left(
        ApiFailure(statusCode: e.response?.statusCode, message: errorMessage),
      );
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
