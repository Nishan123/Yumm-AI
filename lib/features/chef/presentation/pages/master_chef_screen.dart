import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/check_lists_drop_down.dart';
import 'package:yumm_ai/core/widgets/cookbook_hint.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_slider.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/models/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/available_time_selector.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';

class MasterChefScreen extends StatefulWidget {
  const MasterChefScreen({super.key});

  @override
  State<MasterChefScreen> createState() => _MasterChefScreenState();
}

class _MasterChefScreenState extends State<MasterChefScreen> {
  CookingExpertise _selectedCookingExpertise = CookingExpertise.newbie;
  Meal _selectedMeal = Meal.anything;
  List<IngredientModel> selectedIngredients = [];
  TextEditingController mealTypeController = TextEditingController();
  List<String> selectedDietary = [];
  int noOfPeople = 1;

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
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Master Chef")),
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

              // Dietary Restrictions Widget
              InputWidgetTitle(title: "Have any dietary restrictions"),
              CustomDropdownChecklist(
                title: 'No Dietary Restrictions',
                options: ConstantsString.dietaryRestrictions,
                selectedOptions: selectedDietary,
                onConfirm: (selected) {
                  setState(() {
                    selectedDietary = selected;
                  });
                  print('Selected: $selected');
                },
              ),

              SizedBox(height: 6),

              // no of people slider
              InputWidgetTitle(
                title: "Select the number of people",
                dataText: "(${noOfPeople.toString()})",
              ),
              CustomSlider(
                onChange: (value) {
                  setState(() {
                    noOfPeople = value.toInt();
                    debugPrint(noOfPeople.toString());
                  });
                },
                value: noOfPeople.toDouble(),
              ),
              SizedBox(height: 6),
              InputWidgetTitle(title: "Describe your meal preferences."),
              PrimaryTextField(
                margin: EdgeInsets.symmetric(horizontal: 16),
                hintText: "eg. Something Chinese",
                controller: mealTypeController,
              ),
              SizedBox(height: 6),
              InputWidgetTitle(title: "How much time do you have?"),

              AvailableTimeSelector(
                mq: mq,
                selectedDuration: Duration(minutes: 30),
                onDurationChange: (value) {},
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
                  // if (selectedIngredients.isEmpty) {
                  //   CustomSnackBar.showErrorSnackBar(
                  //     context,
                  //     "No Ingredients Selected !",
                  //   );
                  // } else {
                  //   RecipeController().generatePantryRecipe(
                  //     selectedIngredients,
                  //     _selectedMeal.value,
                  //     _selectedDuration,
                  //     _selectedCookingExpertise.value,
                  //   );
                  // }
                },
                backgroundColor: AppColors.blackColor,
                haveHatIcon: true,
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
