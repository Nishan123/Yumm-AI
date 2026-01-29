import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/dot.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';

class CookbookCard extends StatelessWidget {
  final Key dismissibleKey;
  final CookbookRecipeEntity recipe;
  final VoidCallback? onDismissed;

  const CookbookCard({
    super.key,
    required this.dismissibleKey,
    required this.recipe,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Dismissible(
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Recipe'),
              content: const Text(
                'Are you sure you want to delete this recipe?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) => onDismissed?.call(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.only(right: 30),
        color: AppColors.redColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.5),
            const Icon(Icons.delete, color: Colors.white, size: 32),
            const SizedBox(height: 4),
            const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      key: dismissibleKey,
      direction: DismissDirection.endToStart,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4),
        margin: const EdgeInsets.only(left: 18, right: 18, bottom: 24),
        height: mq.height * 0.25,
        width: mq.width,
        decoration: BoxDecoration(
          color: AppColors.extraLightBlackColor,
          border: ContainerProperty.mainBorder,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [ContainerProperty.mainShadow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                // Image Container
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: recipe.images.isNotEmpty
                            ? Image.network(
                                recipe.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  "${ConstantsString.assetImage}/salad.png",
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                "${ConstantsString.assetImage}/salad.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Information Column
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3),
                      Text(
                        recipe.recipeName,
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        recipe.description,
                        style: AppTextStyles.normalText.copyWith(
                          color: AppColors.descriptionTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              recipe.experienceLevel,
                              style: AppTextStyles.normalText.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          dot(),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              recipe.estCookingTime,
                              style: AppTextStyles.normalText.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          dot(),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _getProgressText(),
                              style: AppTextStyles.normalText.copyWith(
                                fontWeight: FontWeight.w800,
                                color: _isComplete()
                                    ? AppColors.primaryColor
                                    : AppColors.redColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SecondaryButton(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              haveHatIcon: true,
              borderRadius: 40,
              backgroundColor: AppColors.blackColor,
              onTap: () {
                // Navigate to cooking screen with the recipe converted to RecipeEntity
                context.push('/cooking', extra: recipe.toRecipeEntity());
              },
              text: _isComplete() ? "Cook Again" : "Continue Cooking",
            ),
          ],
        ),
      ),
    );
  }

  String _getProgressText() {
    final totalIngredients = recipe.ingredients.length;
    final doneIngredients = recipe.ingredients.where((i) => i.isReady).length;
    final totalSteps = recipe.steps.length;
    final doneSteps = recipe.steps.where((s) => s.isDone).length;

    if (_isComplete()) {
      return "Recipe Complete";
    }

    return "$doneIngredients/$totalIngredients ingredients • $doneSteps/$totalSteps steps";
  }

  bool _isComplete() {
    final allIngredientsDone = recipe.ingredients.every((i) => i.isReady);
    final allStepsDone = recipe.steps.every((s) => s.isDone);
    return allIngredientsDone && allStepsDone;
  }
}
