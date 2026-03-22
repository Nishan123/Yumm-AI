import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';

abstract interface class IKitchenToolRepository {
Future<Either<Failure,KitchenToolEntity>> saveKitchenTool({required KitchenToolEntity kitchenTool});
  Future<Either<Failure, bool>> deleteKitchenTool({required String uid, required String toolId});
  Future<Either<Failure, List<KitchenToolEntity>>> getUserKithcenTools({required String uid});
}