import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/propmpts.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/cookbook_hint.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/models/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/available_time_selector.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';

class PantryChefScreen extends StatefulWidget {
  const PantryChefScreen({super.key});

  @override
  State<PantryChefScreen> createState() => _PantryChefScreenState();
}

class _PantryChefScreenState extends State<PantryChefScreen> {
  Duration _selectedDuration = const Duration(minutes: 30);
  CookingExpertise _selectedCookingExpertise = CookingExpertise.newbie;
  Meal _selectedMeal = Meal.anything;
  List<IngredientModel> selectedIngredients = [];

  void onAddItem() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddIngredientsBottomSheet(
          selectedIngredients: selectedIngredients,
          onSubmit: (List<IngredientModel> newSelection) {
            setState(() {
              selectedIngredients = newSelection;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Pantry Chef")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(height: 12),
              CookbookHint(),
              SizedBox(height: 6),
              CustomTabBar(tabItems: ["Ingredients List", "Your Inventory"]),
              SizedBox(height: 6),

              InputWidgetTitle(
                title: "Selected ingredients",
                haveActionButton: true,
                actionButtonText: "Add Item",
                onActionTap: () {
                  onAddItem();
                },
              ),
              IngredientsWrapContainer(
                haveAddIngredientButton: true,
                onAddIngredientButtonPressed: () {
                  onAddItem();
                },
                items: selectedIngredients
                    .map(
                      (ing) => IngredientsChip(
                        onTap: () {
                          setState(() {
                            selectedIngredients.removeWhere(
                              (item) => item.id == ing.id,
                            );
                          });
                        },
                        text: ing.ingredientName,
                        image: ing.prefixImage,
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 6),

              InputWidgetTitle(title: "What meal do you want to cook?"),
              CustomChoiceChip<Meal>(
                values: Meal.values,
                labelBuilder: (meal) => meal.text,
                iconBuilder: (meal) => meal.icon,
                onSelected: (value) {
                  setState(() {
                    _selectedMeal = value;
                  });
                },
              ),
              SizedBox(height: 6),

              InputWidgetTitle(title: "How much time do you have?"),
              // Available time Container
              AvailableTimeSelector(
                mq: mq,
                selectedDuration: _selectedDuration,
                onDurationChange: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
                },
              ),
              SizedBox(height: 6),

              InputWidgetTitle(title: "Select your expertise in cooking."),
              CustomTabBar(
                tabItems: [
                  CookingExpertise.newbie.text,
                  CookingExpertise.canCook.text,
                  CookingExpertise.expert.text,
                ],
                onTabChanged: (value) {
                  setState(() {
                    _selectedCookingExpertise = value;
                  });
                },
                values: [
                  CookingExpertise.newbie,
                  CookingExpertise.canCook,
                  CookingExpertise.expert,
                ],
              ),
              SizedBox(height: 6),

              SecondaryButton(
                borderRadius: 40,
                text: "Generate Meal",
                onTap: () async {
                  if (selectedIngredients.isEmpty) {
                    CustomSnackBar.showErrorSnackBar(
                      context,
                      "No Ingredients Selected !",
                    );
                  } else {
                    final prompt = await Propmpts().getPantryChefMealPrompt(
                      availableIngridents: selectedIngredients,
                      mealType: _selectedMeal,
                      availableTime: _selectedDuration,
                      cookingExperties: _selectedCookingExpertise,
                    );
                    final response = await Gemini.instance.prompt(
                      parts: [Part.text(prompt)],
                    );
                    debugPrint(response?.output);
                  }
                },
                backgroundColor: AppColors.blackColor,
                haveHatIcon: true,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
