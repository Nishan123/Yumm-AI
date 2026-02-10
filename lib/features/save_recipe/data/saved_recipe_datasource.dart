import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

abstract interface class IRemoteSavedRecipeDatasource {
  Future<List<RecipeModel>> getSavedRecipe({required String uid});
  Future<RecipeModel> toggleRecipeLike({required String recipeId});
}
