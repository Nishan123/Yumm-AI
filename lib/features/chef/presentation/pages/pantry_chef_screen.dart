import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/cookbook_hint.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/models/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/pantry_chef_view_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/available_time_selector.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';

class PantryChefScreen extends ConsumerStatefulWidget {
  const PantryChefScreen({super.key});

  @override
  ConsumerState<PantryChefScreen> createState() => _PantryChefScreenState();
}

class _PantryChefScreenState extends ConsumerState<PantryChefScreen> {
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
    final state = ref.watch(pantryChefViewModelProvider);
    final userAsync = ref.watch(currentUserProvider);

    // Listen for errors
    ref.listen(pantryChefViewModelProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        CustomSnackBar.showErrorSnackBar(context, next.error!);
      }
      if (next.generatedRecipe != null &&
          next.generatedRecipe != previous?.generatedRecipe) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          "Recipe generated successfully!",
        );
        // TODO: Navigate to recipe detail screen
        // Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: next.generatedRecipe!)));
        // For now, just print or show dialog?
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: Text("Recipe Generated!"),
            content: Text(
              "Recipe: ${next.generatedRecipe?.recipeName}\nImages generated: ${next.generatedRecipe?.images.length}",
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c), child: Text("OK")),
            ],
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("Pantry Chef")),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  SizedBox(height: 12),
                  CookbookHint(),
                  SizedBox(height: 6),
                  CustomTabBar(
                    tabItems: ["Ingredients List", "Your Inventory"],
                  ),
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
                    text: state.isLoading
                        ? (state.loadingMessage ?? "Generating...")
                        : "Generate Meal",
                    onTap: state.isLoading
                        ? () {}
                        : () {
                            if (selectedIngredients.isEmpty) {
                              CustomSnackBar.showErrorSnackBar(
                                context,
                                "No Ingredients Selected !",
                              );
                            } else {
                              final userId = userAsync.value?.uid;
                              if (userId == null) {
                                CustomSnackBar.showErrorSnackBar(
                                  context,
                                  "User not authenticated",
                                );
                                return;
                              }

                              ref
                                  .read(pantryChefViewModelProvider.notifier)
                                  .generateMeal(
                                    ingredients: selectedIngredients,
                                    mealType: _selectedMeal,
                                    availableTime: _selectedDuration,
                                    expertise: _selectedCookingExpertise,
                                    currentUserId: userId,
                                  );
                            }
                          },
                    backgroundColor: AppColors.blackColor,
                    haveHatIcon: !state.isLoading,
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),

            if (state.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.primaryColor),
                      SizedBox(height: 20),
                      Text(
                        state.loadingMessage ??
                            "Cooking up something special...",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
