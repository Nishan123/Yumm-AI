import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/shopping_list/data/repositories/shopping_list_repository.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';
import 'package:yumm_ai/features/shopping_list/domain/repositories/shopping_list_repository.dart';

class AddShoppingListItemParam extends Equatable {
  final String quantity;
  final String unit;
  final String category;
  final String? ingredientId;

  const AddShoppingListItemParam({
    required this.quantity,
    required this.unit,
    this.category = 'none',
    this.ingredientId,
  });

  @override
  List<Object?> get props => [quantity, unit, category, ingredientId];
}

final addShoppingListItemUsecaseProvider = Provider((ref) {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return AddShoppingListItemUsecase(repository: repository);
});

class AddShoppingListItemUsecase
    implements UsecaseWithParms<ShoppingListEntity, AddShoppingListItemParam> {
  final IShoppingListRepository _repository;

  AddShoppingListItemUsecase({required IShoppingListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShoppingListEntity>> call(
    AddShoppingListItemParam params,
  ) {
    final entity = ShoppingListEntity(
      quantity: params.quantity,
      unit: params.unit,
      category: params.category,
      ingredientId: params.ingredientId,
    );
    return _repository.addItem(entity);
  }
}
