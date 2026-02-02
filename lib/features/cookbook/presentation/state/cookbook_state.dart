import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/cookbook/domain/entities/cookbook_recipe_entity.dart';

enum CookbookStatus {
  initial,
  loading,
  loaded,
  adding,
  added,
  updating,
  updated,
  removing,
  removed,
  checking,
  deleting,
  deleted,
  error,
}

class CookbookState extends Equatable {
  final CookbookStatus status;
  final List<CookbookRecipeEntity> recipes;
  final CookbookRecipeEntity? currentRecipe;
  final bool? isInCookbook;
  final String? errorMessage;

  const CookbookState({
    this.status = CookbookStatus.initial,
    this.recipes = const [],
    this.currentRecipe,
    this.isInCookbook,
    this.errorMessage,
  });

  CookbookState copyWith({
    CookbookStatus? status,
    List<CookbookRecipeEntity>? recipes,
    CookbookRecipeEntity? currentRecipe,
    bool? isInCookbook,
    String? errorMessage,
  }) {
    return CookbookState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      currentRecipe: currentRecipe ?? this.currentRecipe,
      isInCookbook: isInCookbook ?? this.isInCookbook,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Create a new state with currentRecipe cleared
  CookbookState clearCurrentRecipe() {
    return CookbookState(
      status: status,
      recipes: recipes,
      currentRecipe: null,
      isInCookbook: isInCookbook,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    recipes,
    currentRecipe,
    isInCookbook,
    errorMessage,
  ];
}
