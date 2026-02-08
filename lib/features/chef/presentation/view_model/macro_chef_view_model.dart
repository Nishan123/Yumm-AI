import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_macro_chef_plan_usecase.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/base_chef_view_model.dart';

final macroChefViewModelProvider =
    NotifierProvider<MacroChefViewModel, ChefState>(() {
      return MacroChefViewModel();
    });

class MacroChefViewModel extends BaseChefViewModel {
  late final GenerateMacroChefPlanUsecase _generateMacroChefPlanUsecase;

  @override
  ChefState build() {
    initBaseUsecases();
    _generateMacroChefPlanUsecase = ref.read(
      generateMacroChefPlanUsecaseProvider,
    );
    return const ChefState();
  }

  Future<void> generateMeal({
    required List<IngredientModel> ingridents,
    required double carbs,
    required double protein,
    required double fats,
    required double fiber,
    required double calories,
    required Meal mealType,
    required CookingExpertise cookingExpertise,
    required List<String> dietaryRistrictions,
    required Duration availableTime,
    required String currentUserId,
    bool isPublic = true,
  }) async {
    state = state.copyWith(
      status: ChefStatus.generatingRecipe,
      loadingMessage: "Macro chef is cooking for you",
    );

    final user = ref.read(currentUserProvider).value;
    final allergicIngridents = user?.allergicTo ?? [];

    final textResult = await _generateMacroChefPlanUsecase.call(
      GenerateMacroChefPlanParams(
        ingridents: ingridents,
        carbs: carbs,
        protein: protein,
        fats: fats,
        fiber: fiber,
        calories: calories,
        mealType: mealType,
        cookingExpertise: cookingExpertise,
        dietaryRistrictions: dietaryRistrictions,
        availableTime: availableTime,
        allergicIngridents: allergicIngridents,
      ),
    );

    textResult.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.errorMessage,
          status: ChefStatus.error,
        );
      },
      (tempRecipe) {
        state = state.copyWith(
          status: ChefStatus.success,
          generatedRecipe: tempRecipe,
        );
        generateImagesAndSave(
          tempRecipe: tempRecipe,
          currentUserId: currentUserId,
          isPublic: isPublic,
        );
      },
    );
  }
}
