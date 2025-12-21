import 'package:flutter/material.dart';
import 'package:yumm_ai/controllers/recipe_controller.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/models/ingredients_model.dart';
import 'package:yumm_ai/screens/pantry_chef/widgets/available_time_selector.dart';
import 'package:yumm_ai/screens/pantry_chef/widgets/ingredients_chip.dart';
import 'package:yumm_ai/screens/pantry_chef/widgets/ingredients_wrap_container.dart';
import 'package:yumm_ai/screens/pantry_chef/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/widgets/cookbook_hint.dart';
import 'package:yumm_ai/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/widgets/input_widget_title.dart';
import 'package:yumm_ai/widgets/secondary_button.dart';

class PantryChefScreen extends StatefulWidget {
  const PantryChefScreen({super.key});

  @override
  State<PantryChefScreen> createState() => _PantryChefScreenState();
}

class _PantryChefScreenState extends State<PantryChefScreen> {
  Duration _selectedDuration = const Duration(minutes: 30);
  CookingExpertise _selectedCookingExpertise = CookingExpertise.newbie;
  Meal _selectedMeal = Meal.anything;
  List<IngredientsModel> selectedIngredients = [];
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
              SizedBox(height:6),
              CustomTabBar(tabItems: ["Ingredients List", "Your Inventory"]),
              SizedBox(height: 6),

              InputWidgetTitle(
                title: "Selected ingredients",
                haveActionButton: true,
                actionButtonText: "Add Item",
                onActionTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AddIngredientsBottomSheet(
                        selectedIngredients: selectedIngredients,
                        onSubmit: (List<IngredientsModel> newSelection) {
                          setState(() {
                            selectedIngredients = newSelection;
                          });
                        },
                      );
                    },
                  );
                },
              ),
              IngredientsWrapContainer(
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
                  RecipeController().generatePantryRecipe(
                    selectedIngredients,
                    _selectedMeal.value,
                    _selectedDuration,
                    _selectedCookingExpertise.value,
                  );
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
