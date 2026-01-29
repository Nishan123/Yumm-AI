import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

enum ChefStatus {
  initial,
  generatingRecipe,
  generatingImages,
  savingRecipe,
  success,
  error,
}

class ChefState extends Equatable {
  final ChefStatus status;
  final RecipeModel? generatedRecipe;
  final String? errorMessage;
  final String? loadingMessage;

  const ChefState({
    this.status = ChefStatus.initial,
    this.generatedRecipe,
    this.errorMessage,
    this.loadingMessage,
  });

  // copyWith method
  ChefState copyWith({
    ChefStatus? status,
    RecipeModel? generatedRecipe,
    String? errorMessage,
    String? loadingMessage,
  }) {
    return ChefState(
      status: status ?? this.status,
      generatedRecipe: generatedRecipe ?? this.generatedRecipe,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingMessage: loadingMessage ?? this.loadingMessage,
    );
  }

  // Helper getter to check if loading
  bool get isLoading =>
      status == ChefStatus.generatingRecipe ||
      status == ChefStatus.generatingImages ||
      status == ChefStatus.savingRecipe;

  @override
  List<Object?> get props => [
    status,
    generatedRecipe,
    errorMessage,
    loadingMessage,
  ];
}
