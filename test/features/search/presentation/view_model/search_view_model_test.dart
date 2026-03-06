import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/services/storage/search_history_service.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

import 'package:yumm_ai/features/search/domain/usecases/search_recipes_usecase.dart';
import 'package:yumm_ai/features/search/presentation/state/search_state.dart';
import 'package:yumm_ai/features/search/presentation/view_model/search_view_model.dart';

class MockSearchRecipesUseCase extends Mock implements SearchRecipesUseCase {}

class MockSearchHistoryService extends Mock implements SearchHistoryService {}

void main() {
  late ProviderContainer container;
  late MockSearchRecipesUseCase mockSearchRecipesUseCase;
  late MockSearchHistoryService mockSearchHistoryService;

  setUp(() {
    mockSearchRecipesUseCase = MockSearchRecipesUseCase();
    mockSearchHistoryService = MockSearchHistoryService();

    when(() => mockSearchHistoryService.getSearchHistory()).thenReturn([]);

    container = ProviderContainer(
      overrides: [
        searchRecipesUseCaseProvider.overrideWithValue(
          mockSearchRecipesUseCase,
        ),
        searchHistoryServiceProvider.overrideWithValue(
          mockSearchHistoryService,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('search success updates state to loaded', () async {
    when(
      () => mockSearchHistoryService.saveSearchTerm(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockSearchRecipesUseCase.call(
        page: any(named: 'page'),
        size: any(named: 'size'),
        searchTerm: any(named: 'searchTerm'),
        experienceLevel: any(named: 'experienceLevel'),
        mealType: any(named: 'mealType'),
        minCalorie: any(named: 'minCalorie'),
        maxCalorie: any(named: 'maxCalorie'),
      ),
    ).thenAnswer(
      (_) async => const Right((recipes: <RecipeEntity>[], totalPages: 0)),
    );

    final viewModel = container.read(searchViewModelProvider.notifier);
    await viewModel.search('chicken');

    final state = container.read(searchViewModelProvider);
    expect(state.status, SearchStatus.loaded);
    expect(state.recipes, isEmpty);
  });
}
