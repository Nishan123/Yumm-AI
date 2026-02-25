import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/shopping_list/data/repositories/shopping_list_repository.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';
import 'package:yumm_ai/features/shopping_list/domain/repositories/shopping_list_repository.dart';

final getShoppingListUsecaseProvider = Provider((ref) {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return GetShoppingListUsecase(repository: repository);
});

class GetShoppingListUsecase
    implements UsecaseWithParms<List<ShoppingListEntity>, String?> {
  final IShoppingListRepository _repository;

  GetShoppingListUsecase({required IShoppingListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ShoppingListEntity>>> call(String? category) {
    return _repository.getItems(category: category);
  }
}
