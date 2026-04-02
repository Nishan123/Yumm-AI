import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/shared_recipe_bottom_sheet.dart';

/// A read-only view of recipe details for users who haven't added the recipe
/// to their cookbook. Shows recipe information without interactive checkboxes.
class ReadOnlyRecipeView extends StatefulWidget {
  final RecipeEntity recipe;
  final VoidCallback onAddToCookbook;
  final bool isAddingToCookbook;

  const ReadOnlyRecipeView({
    super.key,
    required this.recipe,
    required this.onAddToCookbook,
    this.isAddingToCookbook = false,
  });

  @override
  State<ReadOnlyRecipeView> createState() => _ReadOnlyRecipeViewState();
}

class _ReadOnlyRecipeViewState extends State<ReadOnlyRecipeView> {
  @override
  Widget build(BuildContext context) {
    return SharedRecipeBottomSheet(
      recipe: widget.recipe,
      actionWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PrimaryButton(
          text: widget.isAddingToCookbook
              ? "Adding..."
              : "Add to Cookbook to Start Cooking",
          isLoading: widget.isAddingToCookbook,
          onTap: widget.onAddToCookbook,
        ),
      ),
      ingredientsBody: _buildReadOnlyIngredientsList(),
      instructionsBody: _buildReadOnlyInstructionsList(),
      toolsBody: _buildReadOnlyToolsList(),
    );
  }

  Widget _buildReadOnlyIngredientsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.recipe.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = widget.recipe.ingredients[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.extraLightBlackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (ingredient.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ingredient.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.descriptionTextColor.withOpacity(0.3),
                      child: const Icon(Icons.restaurant, size: 24),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.name,
                      style: AppTextStyles.normalText.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${ingredient.quantity} ${ingredient.unit}",
                      style: AppTextStyles.descriptionText.copyWith(
                        color: AppColors.descriptionTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyInstructionsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.recipe.steps.length,
      itemBuilder: (context, index) {
        final step = widget.recipe.steps[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.extraLightBlackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.descriptionTextColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: AppTextStyles.normalText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(step.instruction, style: AppTextStyles.normalText),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyToolsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.recipe.kitchenTools.length,
      itemBuilder: (context, index) {
        final tool = widget.recipe.kitchenTools[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.extraLightBlackColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (tool.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    tool.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.descriptionTextColor.withOpacity(0.3),
                      child: const Icon(Icons.kitchen, size: 24),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tool.toolName,
                  style: AppTextStyles.normalText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
