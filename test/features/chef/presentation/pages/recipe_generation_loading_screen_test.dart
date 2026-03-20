import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/active_chef_provider.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/pages/recipe_generation_loading_screen.dart';

void main() {
  testWidgets('RecipeGenerationLoadingScreen renders correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeChefStateProvider.overrideWith(
            (ref) => const ChefState(
              loadingMessage: 'Your Recipe is being generated',
            ),
          ),
        ],
        child: const MaterialApp(home: RecipeGenerationLoadingScreen()),
      ),
    );
    await tester.pump();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
