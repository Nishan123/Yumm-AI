import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';

class BugReportModel {
  final String? id;
  final String? reportId;
  final String reportDescription;
  final String problemType;
  final String reportedBy;
  final String screenshotUrl;
  final bool? isResolved;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BugReportModel({
    this.id,
    this.reportId,
    required this.reportDescription,
    required this.problemType,
    required this.reportedBy,
    required this.screenshotUrl,
    this.isResolved,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BugReportModel.fromJson(Map<String, dynamic> json) {
    return BugReportModel(
      id: json['_id'] as String?,
      reportId: json['reportId'] as String?,
      reportDescription: json['reportDescription'] as String,
      problemType: json['problemType'] as String,
      reportedBy: json['reportedBy'] as String,
      screenshotUrl: json['screenshotUrl'] as String,
      isResolved: json['isResolved'] as bool?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportDescription': reportDescription,
      'problemType': problemType,
      'reportedBy': reportedBy,
      'screenshotUrl': screenshotUrl,
      'status': status,
    };
  }

  ReportBugEntity toEntity() {
    return ReportBugEntity(
      id: id,
      reportId: reportId ?? '',
      reportDescription: reportDescription,
      problemType: problemType,
      reportedBy: reportedBy,
      screenshotUrl: screenshotUrl,
      isResolved: isResolved ?? false,
      status: status ?? 'open',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
