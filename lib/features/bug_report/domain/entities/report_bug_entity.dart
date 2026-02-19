import 'package:equatable/equatable.dart';

class ReportBugEntity extends Equatable {
  final String? id;
  final String reportId;
  final String reportedBy;
  final String screenshotUrl;
  final String problemType;
  final String reportDescription;
  final bool isResolved;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReportBugEntity({
    this.id,
    required this.reportId,
    required this.reportedBy,
    required this.screenshotUrl,
    required this.problemType,
    required this.reportDescription,
    required this.isResolved,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      reportId,
      reportedBy,
      screenshotUrl,
      problemType,
      reportDescription,
      isResolved,
      status,
      createdAt,
      updatedAt,
    ];
  }
}
