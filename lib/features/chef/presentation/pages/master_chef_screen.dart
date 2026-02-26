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
import 'package:yumm_ai/core/widgets/custom_slider.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/active_chef_provider.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/master_chef_view_model.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/available_time_selector.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/visibility_selector.dart';
import 'package:yumm_ai/features/pantry_inventory/presentation/providers/pantry_inventory_provider.dart';

class MasterChefScreen extends ConsumerStatefulWidget {
  const MasterChefScreen({super.key});

  @override
  ConsumerState<MasterChefScreen> createState() => _MasterChefScreenState();
}

class _MasterChefScreenState extends ConsumerState<MasterChefScreen> {
  CookingExpertise _selectedCookingExpertise = CookingExpertise.newBie;
  Meal _selectedMeal = Meal.anything;
  List<IngredientModel> selectedIngredients = [];
  TextEditingController mealTypeController = TextEditingController();
  List<String> _selectedDietaryRestrictions = [];
  int _noOfPeople = 1;
  Duration _selectedDuration = Duration(minutes: 30);
  bool _isPublic = true;
  int _selectedTabIndex = 0;

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

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
      if (index == 1) {
        // "Your Inventory" tab — load pantry items
        final pantryAsync = ref.read(pantryInventoryProvider);
        pantryAsync.whenData((pantryItems) {
          setState(() {
            selectedIngredients = List.from(pantryItems);
          });
        });
      } else {
        // "Ingredients List" tab — clear and let user add manually
        selectedIngredients = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    final state = ref.watch(masterChefViewModelProvider);
    final userAsync = ref.watch(currentUserProvider);

    // Watch pantry inventory so it stays updated when on "Your Inventory" tab
    if (_selectedTabIndex == 1) {
      final pantryAsync = ref.watch(pantryInventoryProvider);
      pantryAsync.whenData((pantryItems) {
        if (selectedIngredients.length != pantryItems.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedIngredients = List.from(pantryItems);
            });
          });
        }
      });
    }

    ref.listen(masterChefViewModelProvider, (previous, next) {
      if (next.status == ChefStatus.error &&
          next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      }
      if (next.isLoading && previous?.isLoading != true) {
        context.pushNamed('generating_recipe');
      }
    });

    final isInventoryTab = _selectedTabIndex == 1;

    return Scaffold(
      appBar: AppBar(title: Text("Master Chef")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(height: 12),
              CookbookHint(text: "Generated meal is saved in your Cookbook"),
              SizedBox(height: 6),
              CustomTabBar<int>(
                tabItems: ["Ingredients List", "Your Inventory"],
                values: [0, 1],
                onTabChanged: _onTabChanged,
              ),
              SizedBox(height: 6),
              InputWidgetTitle(
                title: isInventoryTab
                    ? "Pantry ingredients"
                    : "Selected ingredients",
                haveActionButton: !isInventoryTab,
                actionButtonText: "Add Item",
                onActionTap: () {
                  onAddItem();
                },
              ),

              IngredientsWrapContainer(
                haveAddIngredientButton: !isInventoryTab,
                onAddIngredientButtonPressed: () {
                  onAddItem();
                },
                items: selectedIngredients
                    .map(
                      (ing) => IngredientsChip(
                        onTap: isInventoryTab
                            ? () {}
                            : () {
                                setState(() {
                                  selectedIngredients.removeWhere(
                                    (item) =>
                                        item.ingredientId == ing.ingredientId,
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
                selectedOptions: _selectedDietaryRestrictions,
                onConfirm: (selected) {
                  setState(() {
                    _selectedDietaryRestrictions = selected;
                  });
                },
              ),

              SizedBox(height: 6),

              // no of people slider
              InputWidgetTitle(
                title: "Select the number of people",
                dataText: "(${_noOfPeople.toString()})",
              ),
              CustomSlider(
                onChange: (value) {
                  setState(() {
                    _noOfPeople = value.toInt();
                    debugPrint(_noOfPeople.toString());
                  });
                },
                value: _noOfPeople.toDouble(),
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

              // available time selector
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

              // Cooking experties selector
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
              // visibility selector
              VisibilitySelector(
                isPublic: _isPublic,
                onChanged: (value) => setState(() => _isPublic = value),
              ),
              SizedBox(height: 6),

              SecondaryButton(
                isLoading: state.isLoading,
                borderRadius: 40,
                text: "Generate Meal",
                onTap: () {
                  if (selectedIngredients.isEmpty) {
                    CustomSnackBar.showErrorSnackBar(
                      context,
                      "No Ingridents Selected !",
                    );
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
                      ActiveChefType.master;
                  ref
                      .read(masterChefViewModelProvider.notifier)
                      .generateMeal(
                        ingridents: selectedIngredients,
                        mealType: _selectedMeal,
                        availableTime: _selectedDuration,
                        expertise: _selectedCookingExpertise,
                        noOfServes: _noOfPeople,
                        dietaryRestrictions: _selectedDietaryRestrictions,
                        mealPreferences: mealTypeController.text.toLowerCase(),
                        currentUserId: userId,
                        isPublic: _isPublic,
                      );
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
