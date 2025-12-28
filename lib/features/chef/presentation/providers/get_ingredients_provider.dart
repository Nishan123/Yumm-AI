import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/data/Ingrident_model.dart';
import 'package:yumm_ai/features/chef/domain/ingredient_controller.dart';


final getIngredientsProvider = FutureProvider<List<IngredientModel>>((ref) {
  return IngredientController().getIngredients();
});