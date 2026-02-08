import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_pantry_recipe_plan_usecase.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/base_chef_view_model.dart';

final pantryChefViewModelProvider =
    NotifierProvider<PantryChefViewModel, ChefState>(() {
      return PantryChefViewModel();
    });

class PantryChefViewModel extends BaseChefViewModel {
  late final GeneratePantryRecipePlanUsecase _generatePantryRecipePlanUsecase;

  @override
  ChefState build() {
    initBaseUsecases();
    _generatePantryRecipePlanUsecase = ref.read(
      generatePantryRecipePlanUsecaseProvider,
    );
    return const ChefState();
  }

  Future<void> generateMeal({
    required List<IngredientModel> ingredients,
    required Meal mealType,
    required Duration availableTime,
    required CookingExpertise expertise,
    required String currentUserId,
    bool isPublic = true,
    
  }) async {
    state = state.copyWith(
      status: ChefStatus.generatingRecipe,
      loadingMessage: "Pantry chef is cooking for you",
      errorMessage: null,
    );
    final user = ref.read(currentUserProvider).value;
    final allergicIngridents = user?.allergicTo ?? [];
    final textResult = await _generatePantryRecipePlanUsecase.call(
      GeneratePantryRecipePlanParams(
        ingredients: ingredients,
        mealType: mealType,
        availableTime: availableTime,
        expertise: expertise,
        currentUserId: currentUserId,
        allergicIngridents: allergicIngridents
      ),
    );

    await textResult.fold(
      (failure) async {
        state = state.copyWith(
          errorMessage: failure.errorMessage,
          status: ChefStatus.error,
          loadingMessage: null,
        );
      },
      (tempRecipe) {
        generateImagesAndSave(
          tempRecipe: tempRecipe,
          currentUserId: currentUserId,
          isPublic: isPublic,
        );
      },
    );
  }
}
