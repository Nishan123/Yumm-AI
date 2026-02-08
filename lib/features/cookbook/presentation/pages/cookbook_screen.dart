import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/premium_ad_banner.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_card.dart';

class CookbookScreen extends ConsumerStatefulWidget {
  const CookbookScreen({super.key});

  @override
  ConsumerState<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends ConsumerState<CookbookScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCookbook();
    });
  }

  Future<void> _loadCookbook({bool forceRefresh = false}) async {
    final currentState = ref.read(cookbookViewModelProvider);
    if (!forceRefresh &&
        currentState.recipes.isNotEmpty &&
        currentState.status != CookbookStatus.initial &&
        currentState.status != CookbookStatus.error) {
      return; // Use cached data
    }

    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;
    if (user?.uid != null) {
      await ref
          .read(cookbookViewModelProvider.notifier)
          .getUserCookbook(user!.uid!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cookbookState = ref.watch(cookbookViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cookbook")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadCookbook(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 18),
                PremiumAdBanner(
                  text: "Store\nUnlimited Meals",
                  backgroundImage: "${ConstantsString.assetSvg}/ad_banner2.svg",
                  buttonText: "Go Premium",
                ),
                const SizedBox(height: 18),
                _buildCookbookContent(cookbookState),
                const SizedBox(height: 98,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCookbookContent(CookbookState state) {
    if (state.status == CookbookStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == CookbookStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.errorMessage ?? 'Failed to load cookbook',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadCookbook(forceRefresh: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.recipes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'Your cookbook is empty.\nAdd recipes from the home feed to start cooking!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

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
