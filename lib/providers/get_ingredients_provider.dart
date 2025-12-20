import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/controllers/ingredient_controller.dart';
import 'package:yumm_ai/models/ingredients_model.dart';

final getIngredientsProvider = FutureProvider<List<IngredientsModel>>((ref) {
  return IngredientController().getIngredients();
});
