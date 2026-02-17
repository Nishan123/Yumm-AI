import 'package:equatable/equatable.dart';

class ReportBugEntity extends Equatable {
  final String reportId;
  final String reportedBy;
  final String screenshotUrl;
  final String problemType;
  final String reportDescription;
  final bool isResolved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReportBugEntity({
    required this.reportId,
    required this.reportedBy,
    required this.screenshotUrl,
    required this.problemType,
    required this.reportDescription,
    required this.isResolved,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      reportId,
      reportedBy,
      screenshotUrl,
      problemType,
      reportDescription,
      isResolved,
      createdAt,
      updatedAt,
    ];
  }
}
