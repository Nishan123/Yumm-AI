import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_provider.dart';
import 'package:yumm_ai/features/home/presentation/widgets/home_food_recommendations.dart';
import 'package:yumm_ai/features/home/presentation/widgets/recommended_food_snap_loading_skelaton.dart';

class RecommendedFoodScrollSnap extends ConsumerStatefulWidget {
  const RecommendedFoodScrollSnap({super.key});

  @override
  ConsumerState<RecommendedFoodScrollSnap> createState() =>
      _RecommendedFoodScrollSnapState();
}

class _RecommendedFoodScrollSnapState
    extends ConsumerState<RecommendedFoodScrollSnap> {
  final _controller = PageController(viewportFraction: 0.90);
  int focusedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsyncValue = ref.watch(publicRecipesProvider);

    ref.listen(publicRecipesProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        if (_controller.hasClients) {
          _controller.jumpToPage(0);
        }
        setState(() => focusedIndex = 0);
      }
    });

    return SizedBox(
      height: 440,
      width: double.infinity,
      child: recipesAsyncValue.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(child: Text('No recipes found'));
          }
          return PageView.builder(
            padEnds: false,
            controller: _controller,
            itemCount: recipes.length,
            onPageChanged: (i) {
              setState(() => focusedIndex = i);
              // Trigger load more when we reach the end
              if (i >= recipes.length - 2) {
                ref.read(publicRecipesProvider.notifier).loadMore();
              }
            },
            itemBuilder: (context, index) {
              final isFocused = index == focusedIndex;
              final recipe = recipes[index];
              return AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  left: isFocused ? 18 : 0,
                  right: 12,
                  top: isFocused ? 0 : 40,
                  bottom: isFocused ? 0 : 0,
                ),
                child: HomeFoodRecommendations(
                  mainFontSize: isFocused ? 18 : 16,
                  iconsSize: isFocused ? 18 : 14,
                  normalFontSize: isFocused ? 14 : 10,
                  recipe: recipe,
                ),
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => const RecommendedFoodSnapLoadingSkelaton(),
      ),
    );
  }
}
