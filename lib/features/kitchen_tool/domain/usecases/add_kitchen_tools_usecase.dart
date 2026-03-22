import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/kitchen_tool/data/reporitories/kitchen_tool_repository.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';

class AddKitchenToolsUsecaseParams extends Equatable {
  final String toolId;
  final String toolName;
  final String imageUrl;
  final bool isReady;

  const AddKitchenToolsUsecaseParams({
    required this.toolId,
    required this.toolName,
    required this.imageUrl,
    required this.isReady,
  });

  @override
  List<Object?> get props => [toolId, toolName, imageUrl, isReady];
}

final addKitchenToolProvider = Provider((ref){
  return AddKitchenToolsUsecase(kitchenToolRepository: ref.read(kitchenToolRepositoryProvider));
});

class AddKitchenToolsUsecase
    implements UsecaseWithParms<KitchenToolEntity, AddKitchenToolsUsecaseParams> {
  final KitchenToolRepository _kitchenToolRepository;
  AddKitchenToolsUsecase({required KitchenToolRepository kitchenToolRepository})
    : _kitchenToolRepository = kitchenToolRepository;
  @override
  Future<Either<Failure, KitchenToolEntity>> call(
    AddKitchenToolsUsecaseParams params, 
  ) async {
    final toolEntity = KitchenToolEntity(
      toolId: params.toolId,
      toolName: params.toolName,
      imageUrl: params.imageUrl,
    );
    final result = await _kitchenToolRepository.saveKitchenTool(
      kitchenTool: toolEntity,
    );
    return result;
  }
}
