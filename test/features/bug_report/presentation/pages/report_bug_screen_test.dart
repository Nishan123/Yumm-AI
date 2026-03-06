import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/bug_report/presentation/view_model/bug_report_view_model.dart';
import 'package:yumm_ai/features/bug_report/presentation/state/bug_report_state.dart';
import 'package:yumm_ai/features/bug_report/presentation/pages/report_bug_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBugReportViewModel extends BugReportViewModel {
  @override
  BugReportState build() => const BugReportState();
}

void main() {
  testWidgets('ReportBugScreen renders correctly', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final mockAuthRepo = MockAuthRepository();

    const testUser = UserEntity(
      uid: 'u1',
      email: 'test@test.com',
      fullName: 'Test User',
      authProvider: 'emailPassword',
    );
    when(
      () => mockAuthRepo.getCurrentUserFromServer(),
    ).thenAnswer((_) async => const Right(testUser));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
          bugReportViewModelProvider.overrideWith(
            () => MockBugReportViewModel(),
          ),
        ],
        child: const MaterialApp(home: ReportBugScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Report Bug'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
