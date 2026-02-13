import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/chef/domain/entities/recipe_entity.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'package:yumm_ai/features/search/data/datasources/search_remote_data_source.dart';
import 'package:yumm_ai/features/search/domain/repositories/search_repository.dart';
import 'package:dio/dio.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteDataSource = ref.read(searchRemoteDataSourceProvider);
  return SearchRepositoryImpl(remoteDataSource: remoteDataSource);
});

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl({required SearchRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ({List<RecipeEntity> recipes, int totalPages})>>
  searchRecipes({
    required int page,
    required int size,
    required String searchTerm,
    String? experienceLevel,
    String? mealType,
    double? minCalorie,
    double? maxCalorie,
  }) async {
    try {
      final result = await _remoteDataSource.searchRecipes(
        page: page,
        size: size,
        searchTerm: searchTerm,
        experienceLevel: experienceLevel,
        mealType: mealType,
        minCalorie: minCalorie,
        maxCalorie: maxCalorie,
      );

      final entities = RecipeModel.toEntityList(result.recipes);
      return Right((recipes: entities, totalPages: result.totalPages));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? e.message ?? 'Unknown API Error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
