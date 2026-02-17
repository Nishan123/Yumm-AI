import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';

abstract class BugReportRepository {
  Future<Either<Failure, ReportBugEntity>> reportBug(
    ReportBugEntity bugReport,
    Uint8List? screenshot,
  );
}
