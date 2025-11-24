import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/screens/home/widgets/home_app_bar.dart';
import 'package:yumm_ai/screens/home/widgets/home_search_bar.dart';
import 'package:yumm_ai/screens/home/widgets/recommended_food_scroll_snap.dart';
import 'package:yumm_ai/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/widgets/purchase_premium_card.dart';

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
              //Premium Card
              PurchasePremiumCard(),
              //Choice Chips
              CustomChoiceChip(
                onFoodTypeSelected: (foodType) {
                  setState(() {
                    selectedFoodType = foodType;
                  });
                  print(selectedFoodType);
                },
              ),

              //Recommendations Card
              RecommendedFoodScrollSnap(),

              //Top Recipes
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
                        height: 220,
                        width: double.infinity,
                        color: AppColors.blackColor,
                      ),
                      Text("Recipe name")
                    ],
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
