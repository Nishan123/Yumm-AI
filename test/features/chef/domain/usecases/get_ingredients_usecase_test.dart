import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/chef/domain/repositories/ingredient_repository.dart';
import 'package:yumm_ai/features/chef/domain/usecases/get_ingredients_usecase.dart';

class MockIngredientRepository extends Mock implements IngredientRepository {}

void main() {
  late GetIngredientsUsecase usecase;
  late MockIngredientRepository mockRepository;

  setUp(() {
    mockRepository = MockIngredientRepository();
    usecase = GetIngredientsUsecase(ingredientRepository: mockRepository);
  });

  final List<IngredientModel> tIngredients = [
    IngredientModel(
      ingredientId: '1',
      name: 'Tomato',
      imageUrl: 'url',
      quantity: '1',
      unit: 'pcs',
      isReady: true,
    ),
    IngredientModel(
      ingredientId: '2',
      name: 'Potato',
      imageUrl: 'url',
      quantity: '1',
      unit: 'pcs',
      isReady: true,
    ),
  ];

  test('should call getIngredients on the repository', () async {
    // arrange
    when(
      () => mockRepository.getIngredients(),
    ).thenAnswer((_) async => tIngredients);

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tIngredients));
    verify(() => mockRepository.getIngredients());
    verifyNoMoreInteractions(mockRepository);
  });
}
