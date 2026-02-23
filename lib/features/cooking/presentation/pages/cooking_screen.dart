import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_recipe_details_widget.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/read_only_recipe_view.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/recipe_details_widget.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/image_carousel.dart';
import 'package:yumm_ai/features/save_recipe/presentation/view_model/save_recipe_view_model.dart';

class CookingScreen extends ConsumerStatefulWidget {
  final RecipeEntity recipe;
  const CookingScreen({super.key, required this.recipe});

  @override
  ConsumerState<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends ConsumerState<CookingScreen> {
  bool? _isLikedOptimistic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCookbookStatus();
    });
  }

  Future<void> _checkCookbookStatus() async {
    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;

    if (user?.uid != null) {
      await ref
          .read(cookbookViewModelProvider.notifier)
          .checkRecipeWithFallback(
            userId: user!.uid!,
            originalRecipeId: widget.recipe.recipeId,
          );
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

  /// Show confirmation dialog for delete action
  Future<void> _showDeleteConfirmation({
    required bool isOwner,
    required String? userRecipeId,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text(
          isOwner
              ? 'Are you sure you want to delete this recipe? This will also remove it from all users\' cookbooks.'
              : 'Are you sure you want to remove this recipe from your cookbook?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.redColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bool success;
      if (isOwner) {
        // Owner deletes the original recipe (cascade delete)
        success = await ref
            .read(cookbookViewModelProvider.notifier)
            .deleteOriginalRecipe(widget.recipe.recipeId);
      } else {
        // User deletes their cookbook copy
        if (userRecipeId != null) {
          success = await ref
              .read(cookbookViewModelProvider.notifier)
              .deleteCookbookRecipe(userRecipeId);
        } else {
          success = false;
        }
      }

      if (success && mounted) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          isOwner
              ? 'Recipe deleted successfully'
              : 'Recipe removed from cookbook',
        );
        context.pop();
      }
    }
  }

  /// Handle edit action
  void _handleEdit({required bool isOwner, required String? userRecipeId}) {
    // Navigate to edit screen with appropriate data
    context.pushNamed(
      'edit_recipe',
      extra: {
        'recipe': widget.recipe,
        'isOwner': isOwner,
        'userRecipeId': userRecipeId,
        'cookbookRecipe': ref.read(cookbookViewModelProvider).currentRecipe,
      },
    );
  }

  /// Build the popup menu for edit/delete actions
  Widget _buildPopupMenu({
    required bool isOwner,
    required bool isInCookbook,
    required String? userRecipeId,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(120),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightBlackColor,
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 60),
            icon: Icon(LucideIcons.menu, color: AppColors.whiteColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _handleEdit(isOwner: isOwner, userRecipeId: userRecipeId);
              } else if (value == 'delete') {
                _showDeleteConfirmation(
                  isOwner: isOwner,
                  userRecipeId: userRecipeId,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.pen, size: 20, color: AppColors.blueColor),
                    const SizedBox(width: 12),
                    const Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      LucideIcons.trash,
                      size: 20,
                      color: AppColors.redColor,
                    ),
                    const SizedBox(width: 12),
                    const Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    final cookbookState = ref.watch(cookbookViewModelProvider);
    final saveRecipeState = ref.watch(saveRecipeViewModelProvider);

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
      return user != null && widget.recipe.likes.contains(user.uid);
    }

    final kIsLiked = checkIsLiked();

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

    ref.listen<CookbookState>(cookbookViewModelProvider, (previous, next) {
      if (next.status == CookbookStatus.error && next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      } else if (next.status == CookbookStatus.added) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          "Recipe Added in your Cookbook",
        );
      } else if (next.status == CookbookStatus.removed) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          "Recipe Removed from Cookbook",
        );
      } else if (next.status == CookbookStatus.deleted) {
        // Handled in _showDeleteConfirmation
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
                    child: ImageCarousel(images: widget.recipe.images),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: userAsync.when(
                      data: (user) {
                        final currentUserId = user?.uid;
                        final isOwner =
                            currentUserId != null &&
                            widget.recipe.generatedBy == currentUserId;
                        final isInCookbook = cookbookState.isInCookbook == true;
                        final userRecipeId =
                            cookbookState.currentRecipe?.userRecipeId;

                        // Show menu only if user is owner OR recipe is in cookbook
                        final shouldShowMenu = isOwner || isInCookbook;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PrimaryIconButton(
                              iconColor: AppColors.whiteColor,
                              icon: LucideIcons.chevron_left,
                              onTap: () {
                                context.pop();
                              },
                            ),
                            const Spacer(),
                            PrimaryIconButton(
                              iconColor: kIsLiked
                                  ? const Color.fromARGB(231, 255, 17, 0)
                                  : AppColors.whiteColor,
                              icon: kIsLiked
                                  ? Icons.favorite
                                  : LucideIcons.heart,
                              onTap: () async {
                                if (currentUserId == null) {
                                  CustomSnackBar.showErrorSnackBar(
                                    context,
                                    "User not logged in",
                                  );
                                  return;
                                }

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
                            if (shouldShowMenu) ...[
                              const SizedBox(width: 8),
                              _buildPopupMenu(
                                isOwner: isOwner,
                                isInCookbook: isInCookbook,
                                userRecipeId: userRecipeId,
                              ),
                            ],
                          ],
                        );
                      },
                      loading: () => Row(
                        children: [
                          PrimaryIconButton(
                            iconColor: AppColors.whiteColor,
                            icon: LucideIcons.chevron_left,
                            onTap: () {
                              context.pop();
                            },
                          ),
                          const Spacer(),
                          PrimaryIconButton(
                            iconColor: kIsLiked
                                ? const Color.fromARGB(231, 255, 17, 0)
                                : AppColors.whiteColor,
                            icon: kIsLiked ? Icons.favorite : LucideIcons.heart,
                            onTap: () async {
                              if (user == null) {
                                CustomSnackBar.showErrorSnackBar(
                                  context,
                                  "User not logged in",
                                );
                                return;
                              }

                              final wasLiked = kIsLiked;

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
                        ],
                      ),
                      error: (_, __) => Row(
                        children: [
                          PrimaryIconButton(
                            iconColor: AppColors.whiteColor,
                            icon: LucideIcons.chevron_left,
                            onTap: () {
                              context.pop();
                            },
                          ),
                          const Spacer(),
                          PrimaryIconButton(
                            iconColor: AppColors.whiteColor,
                            icon: LucideIcons.heart,
                            onTap: () {},
                          ),
                        ],
                      ),
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

                // Case 2a: Recipe is in cookbook AND we have the user's copy - show cookbook version
                if (isInCookbook && cookbookState.currentRecipe != null) {
                  return CookbookRecipeDetailsWidget(
                    recipe: cookbookState.currentRecipe!,
                  );
                }

                // Case 2b: Recipe is in cookbook but we couldn't fetch it - fallback to read-only
                // This happens when checkRecipeWithFallback found it in cookbook but fetch failed
                // Show original recipe but disable "Add to Cookbook" since it's already added
                if (isInCookbook && cookbookState.currentRecipe == null) {
                  return RecipeDetailsWidget(recipe: widget.recipe);
                }

                // Case 3: Recipe is not in cookbook - show read-only view with add button
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
