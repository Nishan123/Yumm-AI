import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final String targetAudience;
  final int sentCount;
  final int failureCount;
  final String status;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.targetAudience,
    required this.sentCount,
    required this.failureCount,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    targetAudience,
    sentCount,
    failureCount,
    status,
    createdAt,
  ];
}
