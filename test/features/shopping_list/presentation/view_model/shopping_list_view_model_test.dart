import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/add_shopping_list_item_usecase.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/delete_shopping_list_item_usecase.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/get_shopping_list_usecase.dart';
import 'package:yumm_ai/features/shopping_list/domain/usecases/update_shopping_list_item_usecase.dart';
import 'package:yumm_ai/features/shopping_list/presentation/state/shopping_list_state.dart';
import 'package:yumm_ai/features/shopping_list/presentation/view_model/shopping_list_view_model.dart';

class MockAddShoppingListItemUsecase extends Mock
    implements AddShoppingListItemUsecase {}

class MockGetShoppingListUsecase extends Mock
    implements GetShoppingListUsecase {}

class MockUpdateShoppingListItemUsecase extends Mock
    implements UpdateShoppingListItemUsecase {}

class MockDeleteShoppingListItemUsecase extends Mock
    implements DeleteShoppingListItemUsecase {}

class FakeAddShoppingListItemParam extends Fake
    implements AddShoppingListItemParam {}

class FakeShoppingListEntity extends Fake implements ShoppingListEntity {}

void main() {
  late ProviderContainer container;
  late MockAddShoppingListItemUsecase mockAddShoppingListItemUsecase;
  late MockGetShoppingListUsecase mockGetShoppingListUsecase;
  late MockUpdateShoppingListItemUsecase mockUpdateShoppingListItemUsecase;
  late MockDeleteShoppingListItemUsecase mockDeleteShoppingListItemUsecase;

  setUpAll(() {
    registerFallbackValue(FakeAddShoppingListItemParam());
    registerFallbackValue(FakeShoppingListEntity());
  });

  setUp(() {
    mockAddShoppingListItemUsecase = MockAddShoppingListItemUsecase();
    mockGetShoppingListUsecase = MockGetShoppingListUsecase();
    mockUpdateShoppingListItemUsecase = MockUpdateShoppingListItemUsecase();
    mockDeleteShoppingListItemUsecase = MockDeleteShoppingListItemUsecase();

    // Default mock response for the initial fetch on build
    when(
      () => mockGetShoppingListUsecase.call(any()),
    ).thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        addShoppingListItemUsecaseProvider.overrideWithValue(
          mockAddShoppingListItemUsecase,
        ),
        getShoppingListUsecaseProvider.overrideWithValue(
          mockGetShoppingListUsecase,
        ),
        updateShoppingListItemUsecaseProvider.overrideWithValue(
          mockUpdateShoppingListItemUsecase,
        ),
        deleteShoppingListItemUsecaseProvider.overrideWithValue(
          mockDeleteShoppingListItemUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('getItems success updates state to loaded', () async {
    // Wait for the microtask from build to finish
    await Future.microtask(() {});

    final tItems = [
      ShoppingListEntity(
        itemId: '1',
        quantity: '1',
        unit: 'pcs',
        category: 'none',
      ),
    ];

    when(
      () => mockGetShoppingListUsecase.call(any()),
    ).thenAnswer((_) async => Right(tItems));

    final viewModel = container.read(shoppingListViewModelProvider.notifier);
    await viewModel.getItems();

    final state = container.read(shoppingListViewModelProvider);
    expect(state.status, ShoppingListStatus.loaded);
    expect(state.items, tItems);
  });
}
