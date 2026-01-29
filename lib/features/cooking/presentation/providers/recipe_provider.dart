import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/cooking/data/repositories/recipe_repository_impl.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

/// Provider for fetching all recipes (for admin/debug use)
final allRecipesProvider = FutureProvider<List<RecipeEntity>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  final result = await repository.getAllRecipes();
  return result.fold((failure) => throw failure, (recipes) => recipes);
});

/// Provider for fetching only public recipes (for home recommendations)
final publicRecipesProvider = FutureProvider<List<RecipeEntity>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  final result = await repository.getPublicRecipes();
  return result.fold((failure) => throw failure, (recipes) => recipes);
});
