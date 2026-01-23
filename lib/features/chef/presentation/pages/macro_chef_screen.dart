import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/check_lists_drop_down.dart';
import 'package:yumm_ai/core/widgets/cookbook_hint.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/available_time_selector.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';

class MacroChefScreen extends StatefulWidget {
  const MacroChefScreen({super.key});

  @override
  State<MacroChefScreen> createState() => _MacroChefScreenState();
}

class _MacroChefScreenState extends State<MacroChefScreen> {
  final proteinController = TextEditingController();
  final crabsController = TextEditingController();
  final fatsController = TextEditingController();

  CookingExpertise _selectedCookingExpertise = CookingExpertise.newbie;
  Meal _selectedMeal = Meal.anything;
  List<IngredientModel> selectedIngredients = [];
  List<String> selectedDietary = [];

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
  void dispose() {
    super.dispose();
    proteinController.dispose();
    crabsController.dispose();
    fatsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Macro Chef")),
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

              // selected ingredients widget
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

              // macro nutrients input fields
              InputWidgetTitle(title: "Enter your target macro nutrients."),
              PrimaryTextField(
                keyboardType: TextInputType.number,
                hintText: "Crabs (gr.)",
                controller: crabsController,
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),
              PrimaryTextField(
                keyboardType: TextInputType.number,
                hintText: "Proteins (gr.)",
                controller: proteinController,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              PrimaryTextField(
                keyboardType: TextInputType.number,
                hintText: "Fats (gr.)",
                controller: fatsController,
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),

              SizedBox(height: 6),

              // Meal type selector
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
              // Available time selector
              InputWidgetTitle(title: "How much time do you have?"),
              AvailableTimeSelector(
                mq: mq,
                selectedDuration: Duration(minutes: 30),
                onDurationChange: (value) {},
              ),
              SizedBox(height: 6),

              // Cooking expertise selector
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
              SizedBox(height: 8),
              // Generate Recipe button
              SecondaryButton(
                borderRadius: 40,
                haveHatIcon: true,
                backgroundColor: AppColors.blackColor,
                onTap: () {
                  debugPrint("${_selectedCookingExpertise.value}");
                },
                text: "Generate Recipe",
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
