import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';

abstract interface class IShoppingListRepository {
  Future<Either<Failure, ShoppingListEntity>> addItem(ShoppingListEntity item);

  Future<Either<Failure, List<ShoppingListEntity>>> getItems({
    String? category,
  });

  Future<Either<Failure, ShoppingListEntity>> updateItem(
    ShoppingListEntity item,
  );

  Future<Either<Failure, bool>> deleteItem(String itemId);
}
