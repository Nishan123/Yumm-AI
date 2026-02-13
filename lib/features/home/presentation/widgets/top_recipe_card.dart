import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';
import 'package:yumm_ai/core/widgets/dot.dart';
import 'package:yumm_ai/core/widgets/read_more_widget.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/save_recipe/presentation/view_model/save_recipe_view_model.dart';

class TopRecipeCard extends ConsumerStatefulWidget {
  final RecipeEntity recipe;
  const TopRecipeCard({super.key, required this.recipe});

  @override
  ConsumerState<TopRecipeCard> createState() => _TopRecipeCardState();
}

class _TopRecipeCardState extends ConsumerState<TopRecipeCard> {
  bool? _isLikedOptimistic;

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;
    final saveRecipeState = ref.watch(saveRecipeViewModelProvider);

    bool kIsLiked = false;

    // Helper to determine if liked based on available data
    bool checkIsLiked() {
      // 1. If we have optimistic local state, use it (highest priority for immediate UI feedback)
      if (_isLikedOptimistic != null) {
        return _isLikedOptimistic!;
      }

      // 2. If we have the source-of-truth list from SaveRecipeViewModel, use it
      if (saveRecipeState.savedRecipes != null) {
        return saveRecipeState.savedRecipes!.any(
          (r) => r.recipeId == widget.recipe.recipeId,
        );
      }

      // 3. Fallback to the widget's passed data
      return currentUser != null &&
          widget.recipe.likes.contains(currentUser.uid);
    }

    kIsLiked = checkIsLiked();

    // Listen to provider changes to reset optimistic state when source of truth updates
    ref.listen(saveRecipeViewModelProvider, (previous, next) {
      if (previous?.savedRecipes != next.savedRecipes) {
        if (mounted) {
          setState(() {
            _isLikedOptimistic = null;
          });
        }
      }
    });

    return GestureDetector(
      onTap: () {
        context.pushNamed("cooking", extra: widget.recipe);
      },
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 30),
        width: double.infinity,
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightBlackColor,
                borderRadius: BorderRadius.circular(26),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.27,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, top: 12),
                      child: PrimaryIconButton(
                        backgroundColor: AppColors.lightWhiteColor,
                        icon: kIsLiked ? Icons.favorite : LucideIcons.heart,
                        iconColor: kIsLiked
                            ? const Color.fromARGB(231, 255, 17, 0)
                            : AppColors.whiteColor,
                        onTap: () async {
                          if (currentUser == null) {
                            CustomSnackBar.showErrorSnackBar(
                              context,
                              "User not logged in",
                            );
                            return;
                          }

                          // Store previous state to determine action (Save vs Unsave)
                          final wasLiked = kIsLiked;

                          // Optimistic update
                          setState(() {
                            _isLikedOptimistic = !kIsLiked;
                          });

                          await ref
                              .read(saveRecipeViewModelProvider.notifier)
                              .toggleSaveRecipe(
                                recipeId: widget.recipe.recipeId,
                                onSuccess: () {
                                  if (!wasLiked) {
                                    CustomSnackBar.showSuccessSnackBar(
                                      context,
                                      "Recipe Saved",
                                    );
                                  }
                                },
                              );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Text(
              widget.recipe.recipeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.title,
            ),
            ReadMoreWidget(text: widget.recipe.description),
            Row(
              spacing: 6,
              children: [
                Flexible(
                  child: Text(
                    widget.recipe.experienceLevel,
                    style: AppTextStyles.normalText.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                dot(),
                Flexible(
                  child: Text(
                    "${widget.recipe.estCookingTime} min read",
                    style: AppTextStyles.normalText.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                dot(),
                Flexible(
                  child: Text(
                    "Recipe Included",
                    style: AppTextStyles.normalText.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.redColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
