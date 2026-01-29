import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/domain/usecases/get_ingredients_usecase.dart';

final getIngredientsProvider = FutureProvider<List<IngredientModel>>((
  ref,
) async {
  final usecase = ref.read(getIngredientsUsecaseProvider);
  final result = await usecase.call();
  return result.fold(
    (failure) => throw Exception(failure.errorMessage),
    (ingredients) => ingredients,
  );
});
