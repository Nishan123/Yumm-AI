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
import 'package:yumm_ai/features/home/presentation/widgets/home_app_bar.dart';
import 'package:yumm_ai/features/home/presentation/widgets/home_search_bar.dart';
import 'package:yumm_ai/features/home/presentation/widgets/recommended_food_scroll_snap.dart';
import 'package:yumm_ai/features/home/presentation/widgets/top_recipe_card.dart';
import 'package:yumm_ai/features/search/presentation/pages/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Meal _selectedMealType = Meal.anything;

  @override
  Widget build(BuildContext context) {
    // Watch user data from the database
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: userAsync.when(
        data: (user) =>
            HomeAppBar(userName: user!.fullName, profilePic: user.profilePic!),
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
                ),

                SizedBox(height: 18),
                //Premium Card
                PremiumAdBanner(
                  text: 'Unlock\nUnlimited Recipes',
                  backgroundImage: '${ConstantsString.assetSvg}/ad_banner.svg',
                  buttonText: 'Go Premium',
                ),

                SizedBox(height: 12),

                //Choice Chips
                CustomChoiceChip<Meal>(
                  values: Meal.values,
                  onSelected: (value) {
                    setState(() {
                      _selectedMealType = value;
                      debugPrint(_selectedMealType.text);
                    });
                  },
                  labelBuilder: (meal) => meal.text,
                  iconBuilder: (meal) => meal.icon,
                ),
                SizedBox(height: 8),

                //Recommendations Card
                RecommendedFoodScrollSnap(),

                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 18, bottom: 18),
                  child: Text("Top Recipes", style: AppTextStyles.title),
                ),

                //Top Recipes
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [TopRecipeCard()],
                    );
                  },
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
