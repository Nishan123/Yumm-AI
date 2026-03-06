import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/bug_report/domain/entities/report_bug_entity.dart';
import 'package:yumm_ai/features/bug_report/domain/repositories/bug_report_repository.dart';
import 'package:yumm_ai/features/bug_report/domain/usecases/report_bug_usecase.dart';

class MockBugReportRepository extends Mock implements BugReportRepository {}

void main() {
  late ReportBugUseCase usecase;
  late MockBugReportRepository mockRepository;

  setUp(() {
    mockRepository = MockBugReportRepository();
    usecase = ReportBugUseCase(mockRepository);
  });

  final tBugReport = ReportBugEntity(
    reportId: 'req_1',
    reportedBy: 'user_1',
    screenshotUrl: 'http://url.com',
    problemType: 'Test Category',
    reportDescription: 'Test Description',
    isResolved: false,
    status: 'Pending',
  );
  final tScreenshot = Uint8List.fromList([1, 2, 3]);
  final tParams = ReportBugParams(
    bugReport: tBugReport,
    screenshot: tScreenshot,
  );

  test('should call reportBug on the repository', () async {
    // arrange
    when(
      () => mockRepository.reportBug(tBugReport, tScreenshot),
    ).thenAnswer((_) async => Right(tBugReport));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, Right(tBugReport));
    verify(() => mockRepository.reportBug(tBugReport, tScreenshot));
    verifyNoMoreInteractions(mockRepository);
  });
}
