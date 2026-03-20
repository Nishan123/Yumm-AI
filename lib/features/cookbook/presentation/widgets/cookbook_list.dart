import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_card.dart';

class CookbookList extends ConsumerWidget {
  final CookbookState state;

  const CookbookList({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.recipes.length,
      itemBuilder: (context, index) {
        final recipe = state.recipes[index];
        final userAsync = ref.read(currentUserProvider);
        final currentUserId = userAsync.value?.uid;
        final isOwner =
            currentUserId != null &&
            recipe.originalGeneratedBy == currentUserId;

        return CookbookCard(
          dismissibleKey: ValueKey('recipe_${recipe.userRecipeId}'),
          recipe: recipe,
          isOwner: isOwner,
          onDelete: () async {
            bool success;
            if (isOwner) {
              // Owner deletes the original recipe (cascade delete)
              success = await ref
                  .read(cookbookViewModelProvider.notifier)
                  .deleteOriginalRecipe(recipe.originalRecipeId);
            } else {
              // User deletes their cookbook copy
              success = await ref
                  .read(cookbookViewModelProvider.notifier)
                  .deleteCookbookRecipe(recipe.userRecipeId);
            }

            if (success && context.mounted) {
              CustomSnackBar.showSuccessSnackBar(
                context,
                isOwner
                    ? 'Recipe deleted successfully'
                    : 'Recipe removed from cookbook',
              );
              return true;
            }
            return false;
          },
        );
      },
    );
  }
}
