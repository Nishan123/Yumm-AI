import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';

abstract class IngredientRepository {
  Future<List<IngredientModel>> getIngredients();
}
