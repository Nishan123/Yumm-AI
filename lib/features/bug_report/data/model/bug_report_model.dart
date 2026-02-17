import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';

class BugReportModel {
  final String? reportId;
  final String reportDescription;
  final String problemType;
  final String reportedBy;
  final String screenshotUrl;
  final bool? isResolved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BugReportModel({
    this.reportId,
    required this.reportDescription,
    required this.problemType,
    required this.reportedBy,
    required this.screenshotUrl,
    this.isResolved,
    this.createdAt,
    this.updatedAt,
  });

  factory BugReportModel.fromJson(Map<String, dynamic> json) {
    return BugReportModel(
      reportId: json['_id'] as String?, // Assuming backend uses _id
      reportDescription: json['reportDescription'] as String,
      problemType: json['problemType'] as String,
      reportedBy: json['reportedBy'] as String,
      screenshotUrl: json['screenshotUrl'] as String,
      isResolved: json['isResolved'] as bool?,
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
      // _id, createdAt, updatedAt are usually server-generated, so might not need to send them
    };
  }

  ReportBugEntity toEntity() {
    return ReportBugEntity(
      reportId: reportId ?? '',
      reportDescription: reportDescription,
      problemType: problemType,
      reportedBy: reportedBy,
      screenshotUrl: screenshotUrl,
      isResolved: isResolved ?? false, // Default to false if null
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
