import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/notifications/domain/entities/notification_entity.dart';
import 'package:yumm_ai/features/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsParams {
  final int page;
  final int limit;

  const GetNotificationsParams({this.page = 1, this.limit = 20});
}

class GetNotificationsUsecase
    implements
        UsecaseWithParms<List<NotificationEntity>, GetNotificationsParams> {
  final INotificationRepository repository;

  GetNotificationsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) {
    return repository.getNotificationLogs(params.page, params.limit);
  }
}
