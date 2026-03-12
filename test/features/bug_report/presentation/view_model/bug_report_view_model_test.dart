import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';
import 'package:yumm_ai/features/bug_report/domain/usecases/report_bug_usecase.dart';
import 'package:yumm_ai/features/bug_report/presentation/state/bug_report_state.dart';
import 'package:yumm_ai/features/bug_report/presentation/view_model/bug_report_view_model.dart';

class MockReportBugUseCase extends Mock implements ReportBugUseCase {}

class FakeReportBugParams extends Fake implements ReportBugParams {}

class FakeReportBugEntity extends Fake implements ReportBugEntity {}

void main() {
  late ProviderContainer container;
  late MockReportBugUseCase mockReportBugUseCase;

  setUpAll(() {
    registerFallbackValue(FakeReportBugParams());
  });

  setUp(() {
    mockReportBugUseCase = MockReportBugUseCase();

    container = ProviderContainer(
      overrides: [
        reportBugUseCaseProvider.overrideWithValue(mockReportBugUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is BugReportStatus.initial', () {
    final state = container.read(bugReportViewModelProvider);
    expect(state.status, BugReportStatus.initial);
  });

  test('reportBug success updates state to success', () async {
    when(
      () => mockReportBugUseCase.call(any()),
    ).thenAnswer((_) async => Right(FakeReportBugEntity()));

    final viewModel = container.read(bugReportViewModelProvider.notifier);
    await viewModel.reportBug(
      description: 'Test desc',
      problemType: 'Test type',
      reportedBy: 'User',
      screenshot: null,
    );

    final state = container.read(bugReportViewModelProvider);
    expect(state.status, BugReportStatus.success);
  });
}
