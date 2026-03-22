import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/kitchen_tool/data/reporitories/kitchen_tool_repository.dart';

class DeleteKitchenToolUsecaseParams extends Equatable {
  final String uid;
  final String toolId;

  const DeleteKitchenToolUsecaseParams({
    required this.uid,
    required this.toolId,
  });

  @override
  List<Object?> get props => [uid, toolId];
}
final deleteKitchenToolProvider = Provider((ref){
  return DeleteKitchenToolUsecase(kitchenToolRepository: ref.read(kitchenToolRepositoryProvider));
});
class DeleteKitchenToolUsecase
    implements UsecaseWithParms<bool, DeleteKitchenToolUsecaseParams> {
  final KitchenToolRepository _kitchenToolRepository;

  DeleteKitchenToolUsecase({
    required KitchenToolRepository kitchenToolRepository,
  }) : _kitchenToolRepository = kitchenToolRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteKitchenToolUsecaseParams params) async{
    final result = await _kitchenToolRepository.deleteKitchenTool(
      uid: params.uid,
      toolId: params.toolId,
    );
    return result;
  }
}
