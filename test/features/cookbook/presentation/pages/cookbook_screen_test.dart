import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/pages/cookbook_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCookbookViewModel extends CookbookViewModel {
  @override
  CookbookState build() => const CookbookState();
}

void main() {
  testWidgets('CookbookScreen renders correctly', (tester) async {
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
          cookbookViewModelProvider.overrideWith(() => MockCookbookViewModel()),
        ],
        child: const MaterialApp(home: CookbookScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Your Cookbook'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
