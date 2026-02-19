import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/bug_report/domain/usecases/report_bug_usecase.dart';
import 'package:yumm_ai/features/bug_report/presentation/state/bug_report_state.dart';
import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';

final bugReportViewModelProvider =
    NotifierProvider<BugReportViewModel, BugReportState>(
      () => BugReportViewModel(),
    );

class BugReportViewModel extends Notifier<BugReportState> {
  late final ReportBugUseCase _reportBugUseCase;

  @override
  BugReportState build() {
    _reportBugUseCase = ref.read(reportBugUseCaseProvider);
    return BugReportState.initial();
  }

  Future<void> reportBug({
    required String description,
    required String problemType,
    required String reportedBy,
    required Uint8List? screenshot,
  }) async {
    state = state.copyWith(status: BugReportStatus.loading, errorMessage: null);

    final bugReport = ReportBugEntity(
      reportId: '',
      reportDescription: description,
      problemType: problemType,
      reportedBy: reportedBy,
      screenshotUrl: '',
      isResolved: false,
      status: 'open',
    );

    final result = await _reportBugUseCase.call(
      ReportBugParams(bugReport: bugReport, screenshot: screenshot),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BugReportStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (success) {
        state = state.copyWith(status: BugReportStatus.success);
      },
    );
  }
}
