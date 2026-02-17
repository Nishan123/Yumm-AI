import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';
import 'package:yumm_ai/features/bug_report/domain/repositories/bug_report_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/bug_report/data/repositories/bug_report_repository_impl.dart';

final reportBugUseCaseProvider = Provider<ReportBugUseCase>((ref) {
  return ReportBugUseCase(ref.read(bugReportRepositoryProvider));
});

class ReportBugUseCase
    implements UsecaseWithParms<ReportBugEntity, ReportBugParams> {
  final BugReportRepository repository;

  ReportBugUseCase(this.repository);

  @override
  Future<Either<Failure, ReportBugEntity>> call(ReportBugParams params) async {
    return await repository.reportBug(params.bugReport, params.screenshot);
  }
}

class ReportBugParams extends Equatable {
  final ReportBugEntity bugReport;
  final Uint8List? screenshot;

  const ReportBugParams({required this.bugReport, required this.screenshot});

  @override
  List<Object?> get props => [bugReport, screenshot];
}
