import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/ingredient_list.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/instructions_list.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/shared_recipe_bottom_sheet.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/tools_list.dart';

/// Interactive recipe details widget for recipes that are in the user's cookbook.
/// Allows users to check/uncheck ingredients, instructions, and tools.
class CookbookRecipeDetailsWidget extends ConsumerStatefulWidget {
  final CookbookRecipeEntity recipe;

  const CookbookRecipeDetailsWidget({super.key, required this.recipe});

  @override
  ConsumerState<CookbookRecipeDetailsWidget> createState() =>
      _CookbookRecipeDetailsWidgetState();
}

class _CookbookRecipeDetailsWidgetState
    extends ConsumerState<CookbookRecipeDetailsWidget> {
  int _currentTabIndex = 0;

  void _toggleIngredient(int index, bool value) {
    ref.read(cookbookViewModelProvider.notifier).toggleIngredient(index, value);
  }

  void _toggleInstruction(int index, bool value) {
    ref
        .read(cookbookViewModelProvider.notifier)
        .toggleInstruction(index, value);
  }

  void _toggleTool(int index, bool value) {
    ref
        .read(cookbookViewModelProvider.notifier)
        .toggleKitchenTool(index, value);
  }

  @override
  Widget build(BuildContext context) {
    final cookbookState = ref.watch(cookbookViewModelProvider);
    final currentRecipe = cookbookState.currentRecipe ?? widget.recipe;

    return SharedRecipeBottomSheet(
      recipe: currentRecipe.toRecipeEntity(),
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
