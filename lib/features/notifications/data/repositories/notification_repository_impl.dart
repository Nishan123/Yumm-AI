import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:yumm_ai/features/notifications/domain/entities/notification_entity.dart';
import 'package:yumm_ai/features/notifications/domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>(
  (ref) => NotificationRepositoryImpl(
    remoteDataSource: ref.read(notificationRemoteDataSourceProvider),
  ),
);

class NotificationRepositoryImpl implements INotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotificationLogs(
    int page,
    int limit,
  ) async {
    return await remoteDataSource.getNotificationLogs(page, limit);
  }
}
