import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/notifications/domain/entities/notification_entity.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final int page;

  const NotificationState({
    required this.isLoading,
    this.error,
    required this.notifications,
    required this.hasMore,
    required this.page,
  });

  factory NotificationState.initial() {
    return const NotificationState(
      isLoading: false,
      error: null,
      notifications: [],
      hasMore: true,
      page: 1,
    );
  }

  NotificationState copyWith({
    bool? isLoading,
    String? error,
    List<NotificationEntity>? notifications,
    bool? hasMore,
    int? page,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      notifications: notifications ?? this.notifications,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, notifications, hasMore, page];
}
