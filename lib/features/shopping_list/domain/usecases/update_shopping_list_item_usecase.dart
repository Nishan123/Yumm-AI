import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/shopping_list/data/repositories/shopping_list_repository.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';
import 'package:yumm_ai/features/shopping_list/domain/repositories/shopping_list_repository.dart';

final updateShoppingListItemUsecaseProvider = Provider((ref) {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return UpdateShoppingListItemUsecase(repository: repository);
});

class UpdateShoppingListItemUsecase
    implements UsecaseWithParms<ShoppingListEntity, ShoppingListEntity> {
  final IShoppingListRepository _repository;

  UpdateShoppingListItemUsecase({required IShoppingListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ShoppingListEntity>> call(ShoppingListEntity params) {
    return _repository.updateItem(params);
  }
}
