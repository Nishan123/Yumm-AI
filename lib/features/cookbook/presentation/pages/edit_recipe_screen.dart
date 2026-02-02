import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/data/models/instruction_model.dart';
import 'package:yumm_ai/features/chef/data/models/initial_preparation_model.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/chef/domain/entities/instruction_entity.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_wrap_container.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/ingredients_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/add_ingredients_bottom_sheet.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/widgets/custom_tab_bar.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/widgets/custom_choice_chip.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/available_time_selector.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

/// Parameters passed to EditRecipeScreen
class EditRecipeParams {
  final RecipeEntity recipe;
  final bool isOwner;
  final String? userRecipeId;
  final CookbookRecipeEntity? cookbookRecipe;

  const EditRecipeParams({
    required this.recipe,
    required this.isOwner,
    this.userRecipeId,
    this.cookbookRecipe,
  });
}

class EditRecipeScreen extends ConsumerStatefulWidget {
  final EditRecipeParams? params;

  const EditRecipeScreen({super.key, this.params});

  @override
  ConsumerState<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends ConsumerState<EditRecipeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  // Ingredients and Instructions state
  List<IngredientModel> ingredients = [];
  List<String> instructions = [];
  final TextEditingController _instructionController = TextEditingController();

  Meal _selectedMeal = Meal.anything;
  CookingExpertise _selectedCookingExpertise = CookingExpertise.newBie;
  Duration _selectedDuration = const Duration(minutes: 30);

  File? _image;
  String? _existingImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    final params = widget.params;
    if (params == null) return;

    // Use cookbook recipe data for non-owners if available, otherwise use original recipe
    final isOwner = params.isOwner;
    final cookbookRecipe = params.cookbookRecipe;

    // For non-owners with a cookbook recipe, use the cookbook recipe data
    // This ensures we edit the user's copy, not the original
    final recipeName = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.recipeName
        : params.recipe.recipeName;
    final description = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.description
        : params.recipe.description;
    final servings = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.servings
        : params.recipe.servings;
    final images = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.images
        : params.recipe.images;
    final ingredientsList = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.ingredients
        : params.recipe.ingredients;
    final stepsList = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.steps
        : params.recipe.steps;
    final mealType = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.mealType
        : params.recipe.mealType;
    final experienceLevel = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.experienceLevel
        : params.recipe.experienceLevel;
    final estCookingTime = (!isOwner && cookbookRecipe != null)
        ? cookbookRecipe.estCookingTime
        : params.recipe.estCookingTime;

    _titleController.text = recipeName;
    _descriptionController.text = description;
    _servingsController.text = servings.toString();

    // Set existing image URL
    if (images.isNotEmpty) {
      _existingImageUrl = images.first;
    }

    // Convert entities to models for editing
    ingredients = ingredientsList
        .map(
          (e) => IngredientModel(
            ingredientId: e.ingredientId,
            name: e.name,
            quantity: e.quantity,
            unit: e.unit,
            imageUrl: e.imageUrl,
            isReady: e.isReady,
          ),
        )
        .toList();

    instructions = stepsList.map((e) => e.instruction).toList();

    // Set meal type
    _selectedMeal = Meal.values.firstWhere(
      (m) => m.text.toLowerCase() == mealType.toLowerCase(),
      orElse: () => Meal.anything,
    );

    // Set cooking expertise
    _selectedCookingExpertise = CookingExpertise.values.firstWhere(
      (e) => e.text.toLowerCase() == experienceLevel.toLowerCase(),
      orElse: () => CookingExpertise.newBie,
    );

    // Parse duration
    final durationMatch = RegExp(r'(\d+)').firstMatch(estCookingTime);
    if (durationMatch != null) {
      final minutes = int.tryParse(durationMatch.group(1) ?? '30') ?? 30;
      _selectedDuration = Duration(minutes: minutes);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showAddIngredientsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddIngredientsBottomSheet(
            selectedIngredients: ingredients,
            onSubmit: (selected) {
              setState(() {
                ingredients = selected;
              });
            },
          ),
        );
      },
    );
  }

  void _removeIngredient(IngredientModel ingredient) {
    setState(() {
      ingredients.removeWhere(
        (item) => item.ingredientId == ingredient.ingredientId,
      );
    });
  }

  void _addInstruction() {
    if (_instructionController.text.isNotEmpty) {
      setState(() {
        instructions.add(_instructionController.text);
        _instructionController.clear();
      });
    }
  }

  void _removeInstruction(int index) {
    setState(() {
      instructions.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    final params = widget.params;
    if (params == null) {
      Navigator.pop(context);
      return;
    }

    if (_titleController.text.isEmpty) {
      CustomSnackBar.showErrorSnackBar(context, 'Please enter a recipe title');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final viewModel = ref.read(cookbookViewModelProvider.notifier);
      bool success;

      // Determine if this is a public recipe owned by the user
      // Private recipes (isPublic == false) are stored only in UserRecipe collection
      final isPublicRecipe = params.recipe.isPublic;
      final shouldUpdateRecipeCollection = params.isOwner && isPublicRecipe;

      if (shouldUpdateRecipeCollection) {
        // Update original recipe in Recipe collection (public recipes only)
        final updatedRecipe = RecipeModel(
          recipeId: params.recipe.recipeId,
          generatedBy: params.recipe.generatedBy,
          recipeName: _titleController.text,
          description: _descriptionController.text,
          servings: int.tryParse(_servingsController.text) ?? 1,
          mealType: _selectedMeal.text,
          experienceLevel: _selectedCookingExpertise.value,
          estCookingTime: '${_selectedDuration.inMinutes} mins',
          ingredients: ingredients,
          steps: instructions
              .asMap()
              .entries
              .map(
                (e) => InstructionModel(
                  instructionId: (e.key + 1).toString(),
                  instruction: e.value,
                  isDone: false,
                ),
              )
              .toList(),
          initialPreparation: params.recipe.initialPreparation
              .map(
                (e) => InitialPreparationModel(
                  id: e.id,
                  step: e.step,
                  isDone: e.isDone,
                ),
              )
              .toList(),
          kitchenTools: params.recipe.kitchenTools
              .map(
                (e) => KitchenToolModel(
                  toolId: e.toolId,
                  toolName: e.toolName,
                  imageUrl: e.imageUrl,
                ),
              )
              .toList(),
          cuisine: params.recipe.cuisine,
          calorie: params.recipe.calorie,
          images: params.recipe.images,
          nutrition: null, // Keep existing nutrition
          likes: params.recipe.likes,
          isPublic: params.recipe.isPublic,
          createdAt: params.recipe.createdAt,
          updatedAt: DateTime.now(),
        );

        success = await viewModel.updateOriginalRecipe(updatedRecipe);
      } else {
        // Update cookbook recipe (for private recipes or non-owner cookbook copies)
        // Private recipes are stored only in UserRecipe collection
        if (params.cookbookRecipe == null) {
          CustomSnackBar.showErrorSnackBar(
            context,
            'Unable to update recipe - cookbook data not available',
          );
          setState(() => _isLoading = false);
          return;
        }

        final updatedCookbookRecipe = params.cookbookRecipe!.copyWith(
          recipeName: _titleController.text,
          description: _descriptionController.text,
          servings: int.tryParse(_servingsController.text) ?? 1,
          mealType: _selectedMeal.text,
          experienceLevel: _selectedCookingExpertise.text,
          estCookingTime: '${_selectedDuration.inMinutes} mins',
          ingredients: ingredients.map((e) => e.toEntity()).toList(),
          steps: instructions
              .asMap()
              .entries
              .map(
                (e) => params.cookbookRecipe!.steps.length > e.key
                    ? params.cookbookRecipe!.steps[e.key].copyWith(
                        instruction: e.value,
                      )
                    : InstructionEntity(
                        instructionId: (e.key + 1).toString(),
                        instruction: e.value,
                        isDone: false,
                      ),
              )
              .toList(),
        );

        success = await viewModel.fullUpdateCookbookRecipe(
          updatedCookbookRecipe,
        );
      }

      if (success && mounted) {
        CustomSnackBar.showSuccessSnackBar(
          context,
          'Recipe updated successfully',
        );
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    // Watch cookbook state for loading/error handling
    ref.watch(cookbookViewModelProvider);

    // Listen for errors
    ref.listen<CookbookState>(cookbookViewModelProvider, (previous, next) {
      if (next.status == CookbookStatus.error && next.errorMessage != null) {
        CustomSnackBar.showErrorSnackBar(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Recipe")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : _existingImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_existingImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (_image == null && _existingImageUrl == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Add Cover Photo",
                            style: AppTextStyles.normalText.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),

            // Title
            const InputWidgetTitle(title: "Recipe Title"),
            PrimaryTextField(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              controller: _titleController,
              hintText: "Enter recipe title",
            ),
            const SizedBox(height: 18),

            // Description
            const InputWidgetTitle(title: "Description"),
            PrimaryTextField(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              controller: _descriptionController,
              hintText: "Enter recipe description",
              maxLines: 4,
            ),

            const SizedBox(height: 18),

            // Estimated Duration
            AvailableTimeSelector(
              mq: mq,
              selectedDuration: _selectedDuration,
              onDurationChange: (value) {
                setState(() {
                  _selectedDuration = value;
                });
              },
            ),

            const SizedBox(height: 18),

            // Servings
            const InputWidgetTitle(title: "Servings"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryTextField(
                controller: _servingsController,
                hintText: "e.g. 4",
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(height: 18),

            // Meal Type
            CustomChoiceChip<Meal>(
              values: Meal.values,
              labelBuilder: (meal) => meal.text,
              iconBuilder: (meal) => meal.icon,
              selectedValue: _selectedMeal,
              onSelected: (value) {
                setState(() {
                  _selectedMeal = value;
                });
              },
            ),
            const SizedBox(height: 18),
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

            const SizedBox(height: 18),

            // Ingredients
            const InputWidgetTitle(title: "Ingredients"),
            IngredientsWrapContainer(
              items: ingredients.map((e) {
                return IngredientsChip(
                  onTap: () => _removeIngredient(e),
                  text: e.name,
                  image: e.imageUrl,
                );
              }).toList(),
              haveAddIngredientButton: true,
              onAddIngredientButtonPressed: _showAddIngredientsBottomSheet,
            ),

            const SizedBox(height: 8),

            // Instructions
            const InputWidgetTitle(title: "Instructions"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryTextField(
                      controller: _instructionController,
                      hintText: "Add step",
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                    onPressed: _addInstruction,
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            if (instructions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: instructions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 12,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      instructions[index],
                      style: AppTextStyles.normalText,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeInstruction(index),
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),

            SecondaryButton(
              borderRadius: 60,
              onTap: _saveRecipe,
              text: "Update Recipe",
              backgroundColor: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
