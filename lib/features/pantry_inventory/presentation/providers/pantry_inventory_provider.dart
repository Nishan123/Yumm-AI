import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/shopping_list/data/services/ingredient_lookup_service.dart';
import 'package:yumm_ai/features/shopping_list/presentation/view_model/shopping_list_view_model.dart';


final pantryInventoryProvider = FutureProvider<List<IngredientModel>>((
  ref,
) async {
  final shoppingListState = ref.watch(shoppingListViewModelProvider);

  // Filter for checked items only
  final checkedItems = shoppingListState.items
      .where((item) => item.isChecked)
      .toList();

  final lookupMap = await ref.watch(ingredientLookupProvider.future);

  return checkedItems
      .where(
        (item) => item.ingredientId != null && item.ingredientId!.isNotEmpty,
      )
      .map((item) {
        final ingredient = lookupMap[item.ingredientId];
        return IngredientModel(
          ingredientId: item.ingredientId!,
          name: ingredient?.name ?? 'Unknown Item',
          imageUrl: ingredient?.imageUrl ?? '',
          quantity: item.quantity,
          unit: item.unit,
          isReady: true,
        );
      })
      .toList();
});
