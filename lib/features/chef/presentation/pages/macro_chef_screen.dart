import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/check_lists_drop_down.dart';
import 'package:yumm_ai/core/widgets/cookbook_hint.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/active_chef_provider.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/macro_chef_view_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/available_time_selector.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/visibility_selector.dart';

class MacroChefScreen extends ConsumerStatefulWidget {
  const MacroChefScreen({super.key});

  @override
  ConsumerState<MacroChefScreen> createState() => _MacroChefScreenState();
}

class _MacroChefScreenState extends ConsumerState<MacroChefScreen> {
  final proteinController = TextEditingController();
  final crabsController = TextEditingController();
  final fatsController = TextEditingController();
  final fiberController = TextEditingController();
  final calorieController = TextEditingController();
  bool _isPublic = true;
  Duration _selectedDuration = Duration(minutes: 30);

  CookingExpertise _selectedCookingExpertise = CookingExpertise.newBie;
  Meal _selectedMeal = Meal.anything;
  List<IngredientModel> _selectedIngredients = [];
  List<String> _selectedDietary = [];

  void onAddItem() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddIngredientsBottomSheet(
          selectedIngredients: _selectedIngredients,
          onSubmit: (List<IngredientModel> newSelection) {
            setState(() {
              _selectedIngredients = newSelection;
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    calorieController.dispose();
    proteinController.dispose();
    crabsController.dispose();
    fatsController.dispose();
    fiberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final state = ref.watch(macroChefViewModelProvider);
    final userAsync = ref.watch(currentUserProvider);

    ref.listen(macroChefViewModelProvider, (previous, next) {
      if (next.status == ChefStatus.error &&
          next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      }
      if (next.isLoading && previous?.isLoading != true) {
        context.pushNamed('generating_recipe');
      }
    });

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
                items: _selectedIngredients
                    .map(
                      (ing) => IngredientsChip(
                        onTap: () {
                          setState(() {
                            _selectedIngredients.removeWhere(
                              (item) => item.ingredientId == ing.ingredientId,
                            );
                          });
                        },
                        text: ing.name,
                        image: ing.imageUrl,
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 6),

              // macro nutrients input fields
              InputWidgetTitle(title: "Enter your target macro nutrients."),
              PrimaryTextField(
                keyboardType: TextInputType.number,
                hintText: "Calories (kcal.)",
                controller: calorieController,
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),
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
              PrimaryTextField(
                keyboardType: TextInputType.number,
                hintText: "Fiber (gr.)",
                controller: fiberController,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                selectedOptions: _selectedDietary,
                onConfirm: (selected) {
                  setState(() {
                    _selectedDietary = selected;
                  });
                },
              ),
              SizedBox(height: 6),
              // Available time selector
              InputWidgetTitle(title: "How much time do you have?"),
              AvailableTimeSelector(
                mq: mq,
                selectedDuration: Duration(minutes: 30),
                onDurationChange: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
                },
              ),
              SizedBox(height: 6),

              // Cooking expertise selector
              InputWidgetTitle(title: "Select your expertise in cooking."),
              CustomTabBar(
                tabItems: [
                  CookingExpertise.newBie.text,
                  CookingExpertise.canCook.text,
                  CookingExpertise.expert.text,
                ],
                onTabChanged: (value) {
                  setState(() {
                    _selectedCookingExpertise = value;
                  });
                },
                values: [
                  CookingExpertise.newBie,
                  CookingExpertise.canCook,
                  CookingExpertise.expert,
                ],
              ),
              SizedBox(height: 6),
              // Recipe Visibility Toggle
              InputWidgetTitle(title: "Recipe Visibility"),
              VisibilitySelector(
                isPublic: _isPublic,
                onChanged: (value) => setState(() => _isPublic = value),
              ),
              SizedBox(height: 6),
              // Generate Recipe button
              SecondaryButton(
                isLoading: state.isLoading,
                borderRadius: 40,
                haveHatIcon: true,
                backgroundColor: AppColors.blackColor,
                onTap: () {
                  if (_selectedIngredients.isEmpty) {
                    CustomSnackBar.showErrorSnackBar(
                      context,
                      "No Ingridents Selected !",
                    );
                    return;
                  }
                  final userId = userAsync.value?.uid;
                  if (userId == null) {
                    CustomSnackBar.showErrorSnackBar(
                      context,
                      "User not authenticated",
                    );
                    return;
                  }

                  ref.read(activeChefTypeProvider.notifier).state =
                      ActiveChefType.macro;

                  ref
                      .read(macroChefViewModelProvider.notifier)
                      .generateMeal(
                        ingridents: _selectedIngredients,
                        carbs: double.parse(crabsController.text),
                        protein: double.parse(proteinController.text),
                        fats: double.parse(fatsController.text),
                        fiber: double.parse(fiberController.text),
                        calories: double.parse("0"),
                        mealType: _selectedMeal,
                        cookingExpertise: _selectedCookingExpertise,
                        dietaryRistrictions: _selectedDietary,
                        availableTime: _selectedDuration,
                        currentUserId: userId,
                      );
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
