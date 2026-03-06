import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/add_to_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/check_recipe_with_fallback_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/full_update_cookbook_recipe_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/get_user_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/get_user_recipe_by_original_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/is_recipe_in_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/remove_from_cookbook_usecase.dart';
import 'package:yumm_ai/features/cookbook/domain/usecases/update_cookbook_recipe_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/delete_recipe_usecase.dart';
import 'package:yumm_ai/features/chef/domain/usecases/update_recipe_usecase.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';

class MockAddToCookbookUsecase extends Mock implements AddToCookbookUsecase {}

class MockGetUserCookbookUsecase extends Mock
    implements GetUserCookbookUsecase {}

class MockGetUserRecipeByOriginalUsecase extends Mock
    implements GetUserRecipeByOriginalUsecase {}

class MockUpdateCookbookRecipeUsecase extends Mock
    implements UpdateCookbookRecipeUsecase {}

class MockIsRecipeInCookbookUsecase extends Mock
    implements IsRecipeInCookbookUsecase {}

class MockRemoveFromCookbookUsecase extends Mock
    implements RemoveFromCookbookUsecase {}

class MockCheckRecipeWithFallbackUsecase extends Mock
    implements CheckRecipeWithFallbackUsecase {}

class MockDeleteRecipeUsecase extends Mock implements DeleteRecipeUsecase {}

class MockUpdateRecipeUsecase extends Mock implements UpdateRecipeUsecase {}

class MockFullUpdateCookbookRecipeUsecase extends Mock
    implements FullUpdateCookbookRecipeUsecase {}

class FakeCookbookRecipeEntity extends Fake implements CookbookRecipeEntity {}

class FakeGetUserCookbookParams extends Fake implements GetUserCookbookParams {}

void main() {
  late ProviderContainer container;
  late MockGetUserCookbookUsecase mockGetUserCookbookUsecase;
  // Others mocked appropriately, focusing on getUserCookbook for simplicity.

  setUpAll(() {
    registerFallbackValue(FakeGetUserCookbookParams());
  });

  setUp(() {
    mockGetUserCookbookUsecase = MockGetUserCookbookUsecase();

    container = ProviderContainer(
      overrides: [
        getUserCookbookUsecaseProvider.overrideWithValue(
          mockGetUserCookbookUsecase,
        ),
        // Other dependencies can be mocked here similarly. Currently we test getUserCookbook.
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('getUserCookbook success updates state to loaded', () async {
    when(
      () => mockGetUserCookbookUsecase.call(any()),
    ).thenAnswer((_) async => const Right([]));

    final viewModel = container.read(cookbookViewModelProvider.notifier);
    await viewModel.getUserCookbook('user_1');

    final state = container.read(cookbookViewModelProvider);
    expect(state.status, CookbookStatus.loaded);
    expect(state.recipes, isEmpty);
  });
}
