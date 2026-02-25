import 'dart:ui';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/save_recipe/presentation/view_model/save_recipe_view_model.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';

class HomeFoodRecommendations extends ConsumerStatefulWidget {
  final double mainFontSize;
  final double iconsSize;
  final double normalFontSize;
  final RecipeEntity recipe;

  const HomeFoodRecommendations({
    super.key,
    required this.mainFontSize,
    required this.iconsSize,
    required this.normalFontSize,
    required this.recipe,
  });

  @override
  ConsumerState<HomeFoodRecommendations> createState() =>
      _HomeFoodRecommendationsState();
}

class _HomeFoodRecommendationsState
    extends ConsumerState<HomeFoodRecommendations> {
  bool? _isLikedOptimistic;

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
    final mq = MediaQuery.of(context).size;
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;

    // Check SaveRecipeViewModel for the absolute source of truth if available
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            context.pushNamed("cooking", extra: widget.recipe);
          },
          child: Container(
            width: mq.width * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: AppColors.lightBlackColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Stack(
                children: [
                  Positioned.fill(
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
                  // Bottom gradient overlay fixed to the bottom portion only
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        widthFactor: 1.0,
                        heightFactor: 0.55,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(180, 0, 0, 0),
                                Color.fromARGB(80, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                              ],
                              stops: [0.0, 0.6, 1.0],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.recipe.recipeName,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.h3.copyWith(
                                    fontSize: widget.mainFontSize,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildInfoBox(
                                      info: widget.recipe.estCookingTime,
                                      icon: LucideIcons.clock,
                                      fontSize: widget.normalFontSize,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildInfoBox(
                                      info: _expertiseEnum.text,
                                      icon: LucideIcons.brain,
                                      fontSize: widget.normalFontSize,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14, top: 14),
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
                          debugPrint(
                            "Optimistic like state set to: $_isLikedOptimistic",
                          );

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
          ),
        );
      },
    );
  }

  Widget _buildInfoBox({
    required String info,
    required IconData icon,
    required double fontSize,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white24,
          ),
          child: Row(
            spacing: 8,
            children: [
              Icon(icon, size: widget.iconsSize, color: AppColors.whiteColor),
              Text(
                info,
                style: AppTextStyles.normalText.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
