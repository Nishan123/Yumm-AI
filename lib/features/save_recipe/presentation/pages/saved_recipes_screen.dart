import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/save_recipe/presentation/view_model/save_recipe_view_model.dart';
import 'package:yumm_ai/features/save_recipe/presentation/widgets/saved_recipe_card.dart';

class SavedRecipesScreen extends ConsumerStatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  ConsumerState<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends ConsumerState<SavedRecipesScreen> {
  @override
  void initState() {
    super.initState();
    // Initial fetch attempt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(saveRecipeViewModelProvider.notifier).getSavedRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for user changes to trigger fetch if it wasn't ready initially
    ref.listen(currentUserProvider, (previous, next) {
      if (next.asData?.value != null && (previous?.asData?.value == null)) {
        ref.read(saveRecipeViewModelProvider.notifier).getSavedRecipes();
      }
    });

    final saveRecipeState = ref.watch(saveRecipeViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Saved Recipes")),
      body: saveRecipeState.isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : saveRecipeState.failure != null
          ? Center(
              child: Text(
                saveRecipeState.failure!.errorMessage,
                style: AppTextStyles.normalText.copyWith(),
              ),
            )
          : saveRecipeState.savedRecipes == null ||
                saveRecipeState.savedRecipes!.isEmpty
          ? Center(child: Text("No saved recipes yet!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: saveRecipeState.savedRecipes!.length,
              itemBuilder: (context, index) {
                final recipe = saveRecipeState.savedRecipes![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SavedRecipeCard(recipe: recipe),
                );
              },
            ),
    );
  }
}
