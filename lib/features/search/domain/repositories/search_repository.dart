import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, ({List<RecipeEntity> recipes, int totalPages})>>
  searchRecipes({
    required int page,
    required int size,
    required String searchTerm,
    String? experienceLevel,
    String? mealType,
    double? minCalorie,
    double? maxCalorie,
  });
}
