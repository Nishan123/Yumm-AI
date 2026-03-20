import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/pages/edit_recipe_screen.dart';

class MockCookbookViewModel extends CookbookViewModel {
  @override
  CookbookState build() => const CookbookState();
}

void main() {
  testWidgets('EditRecipeScreen renders correctly with no params', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cookbookViewModelProvider.overrideWith(() => MockCookbookViewModel()),
        ],
        child: const MaterialApp(home: EditRecipeScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Edit Recipe'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
