import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/cooking/domain/usecases/update_recipe_usecase.dart';

final cookingViewModelProvider =
    NotifierProvider<CookingViewModel, AsyncValue<void>>(
      () => CookingViewModel(),
    );

class CookingViewModel extends Notifier<AsyncValue<void>> {
  late final UpdateRecipeUseCase _updateRecipeUseCase;

  @override
  AsyncValue<void> build() {
    _updateRecipeUseCase = ref.read(updateRecipeUseCaseProvider);
    return const AsyncValue.data(null);
  }

  Future<void> updateRecipe(RecipeEntity recipe) async {
    state = const AsyncValue.loading();
    final result = await _updateRecipeUseCase(recipe);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (success) => state = const AsyncValue.data(null),
    );
  }
}
