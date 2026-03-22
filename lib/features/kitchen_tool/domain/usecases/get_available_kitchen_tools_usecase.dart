import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/kitchen_tool/data/reporitories/kitchen_tool_repository.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';

class GetAvailableKitchenToolsUsecaseParams extends Equatable {
  final String uid;
  const GetAvailableKitchenToolsUsecaseParams({required this.uid});

  @override
  List<Object?> get props => [uid];
}

final getKitchenToolProvider = Provider((ref){
  return GetAvailableKitchenToolsUsecase(kitchenToolRepository: ref.read(kitchenToolRepositoryProvider));
});

class GetAvailableKitchenToolsUsecase implements UsecaseWithParms<List<KitchenToolEntity>,GetAvailableKitchenToolsUsecaseParams> {
  final KitchenToolRepository _kitchenToolRepository;
  GetAvailableKitchenToolsUsecase({
    required KitchenToolRepository kitchenToolRepository,
  }) : _kitchenToolRepository = kitchenToolRepository;
  @override
  Future<Either<Failure, List<KitchenToolEntity>>> call(
    GetAvailableKitchenToolsUsecaseParams params,
  ) async {
    return await _kitchenToolRepository.getUserKithcenTools(uid: params.uid);
  }
}
