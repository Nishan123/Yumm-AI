import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/premium_ad_banner.dart';
import 'package:yumm_ai/features/home/presentation/widgets/home_app_bar.dart';
import 'package:yumm_ai/features/home/presentation/widgets/home_search_bar.dart';
import 'package:yumm_ai/features/home/presentation/widgets/recommended_food_scroll_snap.dart';
import 'package:yumm_ai/features/home/presentation/widgets/top_recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Meal _selectedMealType = Meal.anything;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              // Custom Search Bar
              HomeSearchBar(),
              SizedBox(height: 18),
              //Premium Card
              PremiumAdBanner(
                text: 'Unlock\nUnlimited Recipes',
                backgroundImage: '${ConstantsString.assetSvg}/ad_banner.svg',
                onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
