import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/core/enums/meals.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/domain/usecases/generate_master_recipe_plan_usecase.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/base_chef_view_model.dart';

final masterChefViewModelProvider =
    NotifierProvider<MasterChefViewModel, ChefState>(() {
      return MasterChefViewModel();
    });

class MasterChefViewModel extends BaseChefViewModel {
  late final GenerateMasterRecipePlanUsecase _generateMasterRecipePlanUsecase;

  @override
  ChefState build() {
    initBaseUsecases();
    _generateMasterRecipePlanUsecase = ref.read(
      generateMasterRecipePlanUsecaseProvider,
    );
    return const ChefState();
  }

  Future<void> generateMeal({
    required List<IngredientModel> ingridents,
    required Meal mealType,
    required Duration availableTime,
    required CookingExpertise expertise,
    required int noOfServes,
    required List<String> dietaryRestrictions,
    required String mealPreferences,
    required String currentUserId,
    bool isPublic = true,
  }) async {
    state = state.copyWith(
      status: ChefStatus.generatingRecipe,
      loadingMessage: "Master chef is cooking for you",
    );
    final user = ref.read(currentUserProvider).value;
    final allergicIngridents = user?.allergicTo ?? [];
    final textResult = await _generateMasterRecipePlanUsecase.call(
      GenerateMasterRecipePlanParams(
        ingridents: ingridents,
        mealType: mealType,
        availableTime: availableTime,
        expertise: expertise,
        noOfServes: noOfServes,
        dietaryRestrictions: dietaryRestrictions,
        mealPreferences: mealPreferences,
        allergicIngridents: allergicIngridents
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
        generateImagesAndSave(
          tempRecipe: tempRecipe,
          currentUserId: currentUserId,
          isPublic: isPublic,
        );
      },
    );
  }
}
