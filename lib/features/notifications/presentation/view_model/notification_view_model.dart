import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:yumm_ai/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:yumm_ai/features/notifications/presentation/state/notification_state.dart';

final getNotificationsUsecaseProvider = Provider(
  (ref) => GetNotificationsUsecase(
    repository: ref.read(notificationRepositoryProvider),
  ),
);

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
      () => NotificationViewModel(),
    );

class NotificationViewModel extends Notifier<NotificationState> {
  late final GetNotificationsUsecase _getNotificationsUsecase;

  @override
  NotificationState build() {
    _getNotificationsUsecase = ref.read(getNotificationsUsecaseProvider);
    return NotificationState.initial();
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (state.isLoading) return;

    if (isRefresh) {
      state = state.copyWith(page: 1, hasMore: true, notifications: []);
    }

    if (!state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _getNotificationsUsecase(
      GetNotificationsParams(page: state.page, limit: 20),
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.errorMessage);
      },
      (notificationsData) {
        state = state.copyWith(
          isLoading: false,
          notifications: [...state.notifications, ...notificationsData],
          page: state.page + 1,
          hasMore: notificationsData.length >= 20,
        );
      },
    );
  }
}
