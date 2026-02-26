import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/presentation/providers/get_ingredients_provider.dart';

/// Provides a lookup map from ingredientId to IngredientModel.
/// This allows resolving name and imageUrl from local JSON data.
final ingredientLookupProvider = FutureProvider<Map<String, IngredientModel>>((
  ref,
) async {
  final ingredients = await ref.watch(getIngredientsProvider.future);
  return {for (final item in ingredients) item.ingredientId: item};
});
