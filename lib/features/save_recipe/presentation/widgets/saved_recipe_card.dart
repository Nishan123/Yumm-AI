import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/custom_dialogue_box.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/presentation/view_model/save_recipe_view_model.dart';

class SavedRecipeCard extends ConsumerStatefulWidget {
  final RecipeEntity recipe;

  const SavedRecipeCard({super.key, required this.recipe});

  @override
  ConsumerState<SavedRecipeCard> createState() => _SavedRecipeCardState();
}

class _SavedRecipeCardState extends ConsumerState<SavedRecipeCard> {
  CookingExpertise get _expertiseEnum {
    return CookingExpertise.values.firstWhere(
      (e) => e.value == widget.recipe.experienceLevel,
      orElse: () {
        return CookingExpertise.newBie;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Unique key for Dismissible
    final dismissKey = Key(widget.recipe.recipeId);

    return Dismissible(
      key: dismissKey,
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();
        final confirmed = await CustomDialogueBox.show(
          context,
          title: "Remove from Saved",
          description:
              "Are you sure you want to remove this recipe from your saved list?",
          onActionButtonTap: () {}, // Handled by manual result return
          actionButtonText: "Remove",
          okText: "Cancel",
        );

        if (confirmed == true) {
          await ref
              .read(saveRecipeViewModelProvider.notifier)
              .toggleSaveRecipe(
                recipeId: widget.recipe.recipeId,
                onSuccess: () {
                  // List updates automatically via ViewModel
                },
              );
          return true;
        }
        return false;
      },
      background: Container(
        padding: const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: AppColors.redColor,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(LucideIcons.trash_2, color: Colors.white, size: 32),
            const SizedBox(height: 4),
            Text(
              'Remove',
              style: AppTextStyles.normalText.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          context.pushNamed("cooking", extra: widget.recipe);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(width: 4, color: AppColors.lightBlackColor),
            borderRadius: BorderRadius.circular(36),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Image Section
              Hero(
                tag: 'recipe_image_${widget.recipe.recipeId}',
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: AspectRatio(
                      aspectRatio:
                          16 / 10, // Wider aspect ratio for a cinematic feel
                      child: widget.recipe.images.isNotEmpty
                          ? Image.network(
                              widget.recipe.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/salad.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              "assets/images/salad.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),

              // Details Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.recipeName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 18,
                        height: 1.2,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.recipe.description,
                      maxLines: 2,
                      style: AppTextStyles.descriptionText.copyWith(
                        color: AppColors.descriptionTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tags Row
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip(
                          LucideIcons.clock,
                          widget.recipe.estCookingTime,
                        ),
                        _buildInfoChip(LucideIcons.brain, _expertiseEnum.text),
                        _buildInfoChip(
                          LucideIcons.flame,
                          "${widget.recipe.calorie} kcal",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.descriptionTextColor, width: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.descriptionTextColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.normalText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.descriptionTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
