import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

enum SearchStatus { initial, loading, loaded, error, loadingMore }

class SearchFilters extends Equatable {
  final String? experienceLevel;
  final String? mealType;
  final double? minCalorie;
  final double? maxCalorie;

  const SearchFilters({
    this.experienceLevel,
    this.mealType,
    this.minCalorie,
    this.maxCalorie,
  });

  bool get isAnyFilterApplied =>
      experienceLevel != null ||
      mealType != null ||
      minCalorie != null ||
      maxCalorie != null;

  SearchFilters copyWith({
    String? experienceLevel,
    String? mealType,
    double? minCalorie,
    double? maxCalorie,
  }) {
    return SearchFilters(
      experienceLevel: experienceLevel ?? this.experienceLevel,
      mealType: mealType ?? this.mealType,
      minCalorie: minCalorie ?? this.minCalorie,
      maxCalorie: maxCalorie ?? this.maxCalorie,
    );
  }

  @override
  List<Object?> get props => [
    experienceLevel,
    mealType,
    minCalorie,
    maxCalorie,
  ];
}

class SearchState extends Equatable {
  final SearchStatus status;
  final List<RecipeEntity> recipes;
  final String errorMessage;
  final List<String> searchHistory;
  final int page;
  final bool hasMore;
  final String searchQuery;
  final SearchFilters filters;

  const SearchState({
    this.status = SearchStatus.initial,
    this.recipes = const [],
    this.errorMessage = '',
    this.searchHistory = const [],
    this.page = 1,
    this.hasMore = true,
    this.searchQuery = '',
    this.filters = const SearchFilters(),
  });

  SearchState copyWith({
    SearchStatus? status,
    List<RecipeEntity>? recipes,
    String? errorMessage,
    List<String>? searchHistory,
    int? page,
    bool? hasMore,
    String? searchQuery,
    SearchFilters? filters,
  }) {
    return SearchState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      errorMessage: errorMessage ?? this.errorMessage,
      searchHistory: searchHistory ?? this.searchHistory,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object> get props => [
    status,
    recipes,
    errorMessage,
    searchHistory,
    page,
    hasMore,
    searchQuery,
    filters,
  ];
}
