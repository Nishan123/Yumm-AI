import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/shopping_list/data/repositories/shopping_list_repository.dart';
import 'package:yumm_ai/features/shopping_list/domain/repositories/shopping_list_repository.dart';

final deleteShoppingListItemUsecaseProvider = Provider((ref) {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return DeleteShoppingListItemUsecase(repository: repository);
});

class DeleteShoppingListItemUsecase implements UsecaseWithParms<bool, String> {
  final IShoppingListRepository _repository;

  DeleteShoppingListItemUsecase({required IShoppingListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(String itemId) {
    return _repository.deleteItem(itemId);
  }
}
