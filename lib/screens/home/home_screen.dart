import 'package:flutter/material.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/screens/home/widgets/home_app_bar.dart';
import 'package:yumm_ai/screens/home/widgets/home_search_bar.dart';
import 'package:yumm_ai/screens/home/widgets/recommended_food_scroll_snap.dart';
import 'package:yumm_ai/screens/home/widgets/top_recipe_card.dart';
import 'package:yumm_ai/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/widgets/premium_ad_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFoodType = "Anything";
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
                backgroundImage: '${Constants.assetSvg}/ad_banner.svg',
                onTap: () {},
                buttonText: 'Go Premium',
              ),
              SizedBox(height: 12),

              //Choice Chips
              CustomChoiceChip(
                onFoodTypeSelected: (foodType) {
                  setState(() {
                    selectedFoodType = foodType;
                  });
                  print(selectedFoodType);
                },
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
