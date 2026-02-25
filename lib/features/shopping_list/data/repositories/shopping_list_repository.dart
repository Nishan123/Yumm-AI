import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/connectivity/network_info.dart';
import 'package:yumm_ai/features/shopping_list/data/datasource/remote/shopping_list_remote_datasource.dart';
import 'package:yumm_ai/features/shopping_list/data/datasource/shopping_list_datasource.dart';
import 'package:yumm_ai/features/shopping_list/data/model/shopping_list_api_model.dart';
import 'package:yumm_ai/features/shopping_list/domain/entities/shopping_list_entity.dart';
import 'package:yumm_ai/features/shopping_list/domain/repositories/shopping_list_repository.dart';

final shoppingListRepositoryProvider = Provider((ref) {
  final remoteDatasource = ref.read(shoppingListRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ShoppingListRepository(
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class ShoppingListRepository implements IShoppingListRepository {
  final IShoppingListRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  ShoppingListRepository({
    required IShoppingListRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  /// Safely extracts an error message from a DioException response.
  /// Handles cases where the response data is HTML (String) instead of JSON (Map).
  String _extractErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] as String?) ?? fallback;
    }
    return fallback;
  }

  @override
  Future<Either<Failure, ShoppingListEntity>> addItem(
    ShoppingListEntity item,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = ShoppingListApiModel.fromEntity(item);
        final result = await _remoteDatasource.addItem(model);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: _extractErrorMessage(e, 'Failed to add item'),
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')),
        );
      }
    } else {
      return Left(
        ApiFailure(message: 'No internet connection. Cannot add item.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ShoppingListEntity>>> getItems({
    String? category,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final items = await _remoteDatasource.getItems(category: category);
        return Right(items.map((e) => e.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: _extractErrorMessage(e, 'Failed to fetch items'),
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')),
        );
      }
    } else {
      return Left(
        ApiFailure(message: 'No internet connection. Cannot fetch items.'),
      );
    }
  }

  @override
  Future<Either<Failure, ShoppingListEntity>> updateItem(
    ShoppingListEntity item,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = ShoppingListApiModel.fromEntity(item);
        final result = await _remoteDatasource.updateItem(model);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: _extractErrorMessage(e, 'Failed to update item'),
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')),
        );
      }
    } else {
      return Left(
        ApiFailure(message: 'No internet connection. Cannot update item.'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteItem(String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDatasource.deleteItem(itemId);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: _extractErrorMessage(e, 'Failed to delete item'),
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')),
        );
      }
    } else {
      return Left(
        ApiFailure(message: 'No internet connection. Cannot delete item.'),
      );
    }
  }
}
