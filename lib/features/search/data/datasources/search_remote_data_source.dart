import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/api/api_client.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/core/error/failure.dart';

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SearchRemoteDataSource(apiClient: apiClient);
});

class SearchRemoteDataSource {
  final ApiClient _apiClient;

  SearchRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  Future<({List<RecipeModel> recipes, int totalPages})> searchRecipes({
    required int page,
    required int size,
    required String searchTerm,
    String? experienceLevel,
    String? mealType,
    double? minCalorie,
    double? maxCalorie,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'size': size,
        'searchTerm': searchTerm,
      };

      if (experienceLevel != null) {
        queryParameters['experienceLevel'] = experienceLevel;
      }
      if (mealType != null) {
        queryParameters['mealType'] = mealType;
      }
      if (minCalorie != null) {
        queryParameters['minCalorie'] = minCalorie;
      }
      if (maxCalorie != null) {
        queryParameters['maxCalorie'] = maxCalorie;
      }

      final response = await _apiClient.get(
        '/publicRecipes',
        queryParameters: queryParameters,
      );

      final data = response.data['data'];
      final recipesList = data['recipe'] as List;
      final recipes = RecipeModel.fromJsonList(recipesList);
      final pagination = data['pagination'];
      final totalPages = pagination['totalPages'] as int;

      return (recipes: recipes, totalPages: totalPages);
    } catch (e) {
      throw ApiFailure(message: e.toString());
    }
  }
}
