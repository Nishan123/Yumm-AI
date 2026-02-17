import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/bug_report/data/datasource/remote/bug_remote_datasource.dart';
import 'package:yumm_ai/features/bug_report/data/model/bug_report_model.dart';
import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';
import 'package:yumm_ai/features/bug_report/domain/repositories/bug_report_repository.dart';

final bugReportRepositoryProvider = Provider<BugReportRepository>((ref) {
  return BugReportRepositoryImpl(
    remoteDataSource: ref.read(remoteBugReportProvider),
  );
});

class BugReportRepositoryImpl implements BugReportRepository {
  final BugReportRemoteDataSource _remoteDataSource;

  BugReportRepositoryImpl({required BugReportRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ReportBugEntity>> reportBug(
    ReportBugEntity bugReport,
    Uint8List? screenshot,
  ) async {
    try {
      String screenshotUrl = bugReport.screenshotUrl;

      if (screenshot != null) {
        screenshotUrl = await _remoteDataSource.uploadScreenshot(screenshot);
      }

      final bugReportModel = BugReportModel(
        reportDescription: bugReport.reportDescription,
        problemType: bugReport.problemType,
        reportedBy: bugReport.reportedBy,
        screenshotUrl: screenshotUrl,
      );

      final result = await _remoteDataSource.reportBug(bugReportModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
