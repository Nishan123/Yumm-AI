import 'package:flutter/material.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/ingredient_list.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/instructions_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/shared_recipe_bottom_sheet.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/tools_list.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_state_provider.dart';

class RecipeDetailsWidget extends ConsumerStatefulWidget {
  final RecipeEntity recipe;
  const RecipeDetailsWidget({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailsWidget> createState() =>
      _RecipeDetailsWidgetState();
}

class _RecipeDetailsWidgetState extends ConsumerState<RecipeDetailsWidget> {
  int _currentTabIndex = 0;

  void _toggleIngredient(int index, bool value) {
    ref
        .read(recipeStateCacheProvider.notifier)
        .toggleIngredient(widget.recipe.recipeId, index, value);
  }

  void _toggleInstruction(int index, bool value) {
    ref
        .read(recipeStateCacheProvider.notifier)
        .toggleInstruction(widget.recipe.recipeId, index, value);
  }

  void _toggleTool(int index, bool value) {
    ref
        .read(recipeStateCacheProvider.notifier)
        .toggleKitchenTool(widget.recipe.recipeId, index, value);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the recipe state provider with the passed recipe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recipeStateCacheProvider.notifier)
          .initializeIfNeeded(widget.recipe.recipeId, widget.recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the recipe state from the provider
    final recipeSnapshot = ref.watch(
      recipeStateProvider(widget.recipe.recipeId),
    );
    final currentRecipe = recipeSnapshot.recipe ?? widget.recipe;

    return SharedRecipeBottomSheet(
      recipe: currentRecipe,
      onTabChanged: (index) {
        if (mounted) {
          setState(() {
             _currentTabIndex = index;
          });
        }
      },
      ingredientsBody: IngredientList(
        isActive: _currentTabIndex == 0,
        ingredients: currentRecipe.ingredients,
        onToggle: _toggleIngredient,
      ),
      instructionsBody: InstructionsList(
        isActive: _currentTabIndex == 1,
        instruction: currentRecipe.steps,
        onToggle: _toggleInstruction,
      ),
      toolsBody: ToolsList(
        kitchenTool: currentRecipe.kitchenTools,
        isActive: _currentTabIndex == 2,
        onToggle: _toggleTool,
      ),
    );
  }
}
