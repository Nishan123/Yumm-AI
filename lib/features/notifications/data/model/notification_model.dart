import 'package:yumm_ai/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.targetAudience,
    required super.sentCount,
    required super.failureCount,
    required super.status,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      targetAudience: json['targetAudience'] ?? 'all',
      sentCount: json['sentCount'] ?? 0,
      failureCount: json['failureCount'] ?? 0,
      status: json['status'] ?? 'success',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
