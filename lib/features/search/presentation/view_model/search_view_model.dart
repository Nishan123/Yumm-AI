import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/services/storage/search_history_service.dart';
import 'package:yumm_ai/features/search/domain/usecases/search_recipes_usecase.dart';
import 'package:yumm_ai/features/search/presentation/state/search_state.dart';

final searchViewModelProvider = NotifierProvider<SearchViewModel, SearchState>(
  () => SearchViewModel(),
);

class SearchViewModel extends Notifier<SearchState> {
  late final SearchRecipesUseCase _searchRecipesUseCase;
  late final SearchHistoryService _searchHistoryService;

  static const int _pageSize = 10;

  @override
  SearchState build() {
    _searchRecipesUseCase = ref.read(searchRecipesUseCaseProvider);
    _searchHistoryService = ref.read(searchHistoryServiceProvider);

    final history = _searchHistoryService.getSearchHistory();
    return SearchState(searchHistory: history);
  }

  void _loadHistory() {
    final history = _searchHistoryService.getSearchHistory();
    state = state.copyWith(searchHistory: history);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(
      status: SearchStatus.loading,
      searchQuery: query,
      page: 1,
      recipes: [],
      hasMore: true,
    );
    await _searchHistoryService.saveSearchTerm(query);
    _loadHistory();

    final result = await _searchRecipesUseCase(
      page: 1,
      size: _pageSize,
      searchTerm: query,
      experienceLevel: state.filters.experienceLevel,
      mealType: state.filters.mealType,
      minCalorie: state.filters.minCalorie,
      maxCalorie: state.filters.maxCalorie,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.errorMessage,
      ),
      (data) => state = state.copyWith(
        status: SearchStatus.loaded,
        recipes: data.recipes,
        hasMore: data.recipes.length >= _pageSize,
        page: 2,
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (state.status == SearchStatus.loading || !state.hasMore) return;

    state = state.copyWith(status: SearchStatus.loadingMore);

    final result = await _searchRecipesUseCase(
      page: state.page,
      size: _pageSize,
      searchTerm: state.searchQuery,
      experienceLevel: state.filters.experienceLevel,
      mealType: state.filters.mealType,
      minCalorie: state.filters.minCalorie,
      maxCalorie: state.filters.maxCalorie,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.errorMessage,
      ),
      (data) {
        final newRecipes = [...state.recipes, ...data.recipes];
        state = state.copyWith(
          status: SearchStatus.loaded,
          recipes: newRecipes,
          hasMore: data.recipes.length >= _pageSize,
          page: state.page + 1,
        );
      },
    );
  }

  void setFilters(SearchFilters filters) {
    state = state.copyWith(filters: filters);
    if (state.searchQuery.isNotEmpty) {
      search(state.searchQuery);
    }
  }

  void clearFilters() {
    state = state.copyWith(filters: const SearchFilters());
    if (state.searchQuery.isNotEmpty) {
      search(state.searchQuery);
    }
  }

  Future<void> clearHistory() async {
    await _searchHistoryService.clearSearchHistory();
    state = state.copyWith(searchHistory: []);
  }

  Future<void> removeHistoryItem(String term) async {
    await _searchHistoryService.removeSearchTerm(term);
    final history = _searchHistoryService.getSearchHistory();
    state = state.copyWith(searchHistory: history);
  }
}
