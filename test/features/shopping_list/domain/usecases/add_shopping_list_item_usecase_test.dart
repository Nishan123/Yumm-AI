import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';
import 'package:yumm_ai/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/add_shopping_list_item_usecase.dart';

class MockShoppingListRepository extends Mock
    implements IShoppingListRepository {}

class FakeShoppingListEntity extends Fake implements ShoppingListEntity {}

void main() {
  late AddShoppingListItemUsecase usecase;
  late MockShoppingListRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeShoppingListEntity());
  });

  setUp(() {
    mockRepository = MockShoppingListRepository();
    usecase = AddShoppingListItemUsecase(repository: mockRepository);
  });

  const tQuantity = "1";
  const tUnit = "kg";
  const tCategory = "Vegetables";
  const tIngredientId = "ing_1";

  const tParams = AddShoppingListItemParam(
    quantity: tQuantity,
    unit: tUnit,
    category: tCategory,
    ingredientId: tIngredientId,
  );

  final tEntity = ShoppingListEntity(
    itemId: 'id_1',
    quantity: tQuantity,
    unit: tUnit,
    category: tCategory,
    ingredientId: tIngredientId,
  );

  test('should call addItem on the repository with correct entity', () async {
    // arrange
    when(
      () => mockRepository.addItem(any()),
    ).thenAnswer((_) async => Right(tEntity));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, Right(tEntity));
    verify(() => mockRepository.addItem(any(that: isA<ShoppingListEntity>())));
    verifyNoMoreInteractions(mockRepository);
  });
}
