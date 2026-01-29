import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_recipe_details_widget.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/read_only_recipe_view.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_details_widget.dart';

class CookingScreen extends ConsumerStatefulWidget {
  final RecipeEntity recipe;
  const CookingScreen({super.key, required this.recipe});

  @override
  ConsumerState<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends ConsumerState<CookingScreen> {
  @override
  void initState() {
    super.initState();
    // Check if recipe is in user's cookbook after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCookbookStatus();
    });
  }

  Future<void> _checkCookbookStatus() async {
    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;
    if (user?.uid != null) {
      // First check if in cookbook
      await ref
          .read(cookbookViewModelProvider.notifier)
          .checkIsInCookbook(
            userId: user!.uid!,
            originalRecipeId: widget.recipe.recipeId,
          );

      // If in cookbook, fetch the user's copy
      final state = ref.read(cookbookViewModelProvider);
      if (state.isInCookbook == true) {
        await ref
            .read(cookbookViewModelProvider.notifier)
            .getUserRecipeByOriginal(
              userId: user.uid!,
              originalRecipeId: widget.recipe.recipeId,
            );
      }
    }
  }

  void _handleAddToCookbook() {
    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;
    if (user?.uid != null) {
      ref
          .read(cookbookViewModelProvider.notifier)
          .addToCookbook(userId: user!.uid!, recipeId: widget.recipe.recipeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final userAsync = ref.watch(currentUserProvider);
    final cookbookState = ref.watch(cookbookViewModelProvider);

    ref.listen<CookbookState>(cookbookViewModelProvider, (previous, next) {
      if (next.status == CookbookStatus.error && next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      } else if (next.status == CookbookStatus.added) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          "Recipe Added in your Cookbook",
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: mq.height * 0.39,
              color: AppColors.lightBlackColor,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: widget.recipe.images.isNotEmpty
                        ? Image.network(
                            widget.recipe.images.first,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "${ConstantsString.assetImage}/salad.png",
                                fit: BoxFit.fitWidth,
                              );
                            },
                          )
                        : Image.asset(
                            "${ConstantsString.assetImage}/salad.png",
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryIconButton(
                          iconColor: AppColors.whiteColor,
                          icon: LucideIcons.chevron_left,
                          onTap: () {
                            context.pop();
                          },
                        ),
                        PrimaryIconButton(
                          iconColor: AppColors.whiteColor,
                          icon: LucideIcons.heart,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Determine which view to show based on ownership and cookbook status
            userAsync.when(
              data: (user) {
                final currentUserId = user?.uid;
                final isOwner =
                    currentUserId != null &&
                    widget.recipe.generatedBy == currentUserId;
                final isInCookbook = cookbookState.isInCookbook == true;

                // Case 1: User is the owner - show original interactive view
                if (isOwner) {
                  return RecipeDetailsWidget(recipe: widget.recipe);
                }

                // Case 2: Recipe is in user's cookbook - show cookbook version
                if (isInCookbook && cookbookState.currentRecipe != null) {
                  return CookbookRecipeDetailsWidget(
                    recipe: cookbookState.currentRecipe!,
                  );
                }

                // Case 3: Recipe is not in cookbook - show read-only view
                return ReadOnlyRecipeView(
                  recipe: widget.recipe,
                  onAddToCookbook: _handleAddToCookbook,
                  isAddingToCookbook:
                      cookbookState.status == CookbookStatus.adding,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => ReadOnlyRecipeView(
                recipe: widget.recipe,
                onAddToCookbook: _handleAddToCookbook,
                isAddingToCookbook:
                    cookbookState.status == CookbookStatus.adding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
