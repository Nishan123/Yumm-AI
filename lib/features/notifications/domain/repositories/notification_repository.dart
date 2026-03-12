import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/notifications/domain/entities/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotificationLogs(
    int page,
    int limit,
  );
}
