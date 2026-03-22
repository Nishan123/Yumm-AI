import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/connectivity/network_info.dart';
import 'package:yumm_ai/features/kitchen_tool/data/datasource/remote/remote_kitchen_tool_datasource.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/repositories/kitchen_tool_repository.dart';

final kitchenToolRepositoryProvider = Provider((ref) {
  return KitchenToolRepository(
    networkInfo: ref.read(networkInfoProvider),
    remoteKitchenToolDatasource: ref.read(remoteKitchenToolDatasourceProvider),
  );
});

class KitchenToolRepository implements IKitchenToolRepository {
  final RemoteKitchenToolDatasource _remoteKitchenToolDatasource;
  final NetworkInfo _networkInfo;
  KitchenToolRepository({
    required RemoteKitchenToolDatasource remoteKitchenToolDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteKitchenToolDatasource = remoteKitchenToolDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> deleteKitchenTool({
    required String uid,
    required String toolId,
  }) async{
    if(await _networkInfo.isConnected){
      try {
        await _remoteKitchenToolDatasource.deleteKitchenTool(uid: uid, toolId: toolId);
        return Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }
    throw GeneralFailure("No internet connection");
  }

  @override
  Future<Either<Failure, List<KitchenToolEntity>>> getUserKithcenTools({required String uid}) async{
    if(await _networkInfo.isConnected){
      try {
        final models = await _remoteKitchenToolDatasource.getUserKithcenTools(uid: uid);
        final entities = KitchenToolModel.toEntityList(models);
        return Right(entities);
      } on DioException catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
     
    }
    return Left(GeneralFailure("No internet connection"));
  }

  @override
  Future<Either<Failure, KitchenToolEntity>> saveKitchenTool({
    required KitchenToolEntity kitchenTool,
  }) async{
    if(await _networkInfo.isConnected){
      try {
      final kitchenToolmodel = KitchenToolModel.fromEntity(kitchenTool);
    await _remoteKitchenToolDatasource.saveKitchenTool(kitchenTool: kitchenToolmodel);
    return Right(kitchenTool);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
    }
    return Left(GeneralFailure("No internet connection"));

  }
}
