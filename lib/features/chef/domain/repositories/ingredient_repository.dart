import 'package:yumm_ai/features/chef/data/models/Ingrident_model.dart';

abstract class IngredientRepository {
  Future<List<IngredientModel>> getIngredients();
}
