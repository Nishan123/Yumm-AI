import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/macro_chef_view_model.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/pages/macro_chef_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockMacroChefViewModel extends MacroChefViewModel {
  @override
  ChefState build() => const ChefState();
}

void main() {
  testWidgets('MacroChefScreen renders correctly', (tester) async {
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
          macroChefViewModelProvider.overrideWith(
            () => MockMacroChefViewModel(),
          ),
        ],
        child: const MaterialApp(home: MacroChefScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Macro Chef'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
