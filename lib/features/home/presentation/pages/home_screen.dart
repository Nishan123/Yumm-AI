import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/premium_ad_banner.dart';
import 'package:yumm_ai/features/cooking/data/datasource/remote/recipe_remote_datasource.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_state_provider.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_provider.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/top_recipe_provider.dart';
import 'package:yumm_ai/features/home/presentation/widgets/home_app_bar.dart';
import 'package:yumm_ai/features/home/presentation/widgets/home_search_bar.dart';
import 'package:yumm_ai/features/home/presentation/widgets/recommended_food_scroll_snap.dart';
import 'package:yumm_ai/features/home/presentation/widgets/top_recipe_card.dart';
import 'package:yumm_ai/features/search/presentation/pages/search_screen.dart';
import 'package:yumm_ai/core/providers/user_selectors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Watch user data from the database
    final userAsync = ref.watch(currentUserProvider);
    final cacheKey = ref.watch(profilePicCacheKeyProvider);

    return Scaffold(
      appBar: userAsync.when(
        data: (user) {
          String profilePicUrl = user!.profilePic!;
          if (profilePicUrl.isNotEmpty) {
            final separator = profilePicUrl.contains('?') ? '&' : '?';
            profilePicUrl = '$profilePicUrl${separator}v=$cacheKey';
          }
          return HomeAppBar(userName: user.fullName, profilePic: profilePicUrl);
        },
        loading: () {
          return HomeAppBar(userName: "", profilePic: "");
        },
        error: (_, __) => HomeAppBar(userName: 'N/A', profilePic: ''),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(recipeStateCacheProvider);
            ref.invalidate(recipeStateProvider);
            ref.invalidate(recipeRemoteDataSourceProvider);
            ref.invalidate(currentUserProvider);
            ref.invalidate(publicRecipesProvider);
            ref.invalidate(topPublicRecipesProvider);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.9 &&
                  ref.read(topPublicRecipesProvider.notifier).canLoadMore) {
                ref.read(topPublicRecipesProvider.notifier).loadMore();
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  // Custom Search Bar
                  HomeSearchBar(
                    onTap: () {
                      Navigator.of(context).push(SearchScreen.route());
                    },
                    onFilterTap: () {
                      Navigator.of(
                        context,
                      ).push(SearchScreen.route(focusFilter: true));
                    },
                  ),
                  SizedBox(height: 18),
                  //Premium Card
                  PremiumAdBanner(
                    text: 'Unlock\nUnlimited Recipes',
                    backgroundImage:
                        '${ConstantsString.assetSvg}/ad_banner.svg',
                    buttonText: 'Go Premium',
                  ),

                  //Choice Chips
                  CustomChoiceChip<Meal>(
                    values: Meal.values,
                    onSelected: (value) {
                      ref.read(selectedMealTypeProvider.notifier).state = value;
                    },
                    labelBuilder: (meal) => meal.text,
                    iconBuilder: (meal) => meal.icon,
                  ),
                  SizedBox(height: 8),

                  //Recommendations Card
                  RecommendedFoodScrollSnap(),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      top: 18,
                      bottom: 18,
                    ),
                    child: Text("Top Recipes", style: AppTextStyles.title),
                  ),

                  //Top Recipes
                  Consumer(
                    builder: (context, ref, child) {
                      final topRecipesAsync = ref.watch(
                        topPublicRecipesProvider,
                      );

                      return topRecipesAsync.when(
                        data: (recipes) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                recipes.length +
                                (ref
                                        .read(topPublicRecipesProvider.notifier)
                                        .canLoadMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index == recipes.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TopRecipeCard(recipe: recipes[index]),
                                ],
                              );
                            },
                          );
                        },
                        error: (error, stack) =>
                            Center(child: Text('Error: $error')),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
