import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/usecases/add_kitchen_tools_usecase.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/usecases/delete_kitchen_tool_usecase.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/usecases/get_available_kitchen_tools_usecase.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/state/tools_state.dart';

final kitchenViewModelProvider = NotifierProvider<KitchenViewModel, ToolsState>(()=>KitchenViewModel());

class KitchenViewModel extends Notifier<ToolsState> {
  late AddKitchenToolsUsecase _addKitchenToolUsecase;
  late DeleteKitchenToolUsecase _deleteKitchenToolUsecase;
  late GetAvailableKitchenToolsUsecase _getUserKitchenToolUsecase;

  @override
  ToolsState build() {
    _addKitchenToolUsecase = ref.read(addKitchenToolProvider);
    _deleteKitchenToolUsecase = ref.read(deleteKitchenToolProvider);
    _getUserKitchenToolUsecase = ref.read(getKitchenToolProvider);
    return ToolsState();
  }

  Future<void> addKitchenTool({required KitchenToolEntity kitchenTool}) async {
    state = state.copyWith(status: ToolsStatus.loading);
    final result = await _addKitchenToolUsecase.call(
      AddKitchenToolsUsecaseParams(
        toolId: kitchenTool.toolId,
        toolName: kitchenTool.toolName,
        imageUrl: kitchenTool.imageUrl,
        isReady: kitchenTool.isReady,
      ),
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ToolsStatus.error,
          message: failure.errorMessage,
        );
      },
      (success) {
        final currentTools = state.kitchenTools ?? [];
        state = state.copyWith(
          status: ToolsStatus.success,
          kitchenTools: [...currentTools, success],
        );
      },
    );
  }

  Future<void> deleteKitchenTool({
    required String uid,
    required String toolId,
  }) async {
    state = state.copyWith(status: ToolsStatus.loading);
    final result = await _deleteKitchenToolUsecase.call(
      DeleteKitchenToolUsecaseParams(uid: uid, toolId: toolId),
    );
    result.fold(
      (failure) {
        state = state.copyWith(status: ToolsStatus.error);
      },
      (success) {
        final currentTools = state.kitchenTools ?? [];
        final updatedTools =
            currentTools.where((t) => t.toolId != toolId).toList();
        state = state.copyWith(
          status: ToolsStatus.success,
          kitchenTools: updatedTools,
        );
      },
    );
  }

  Future<void> getUserTools({required String uid}) async {
    state = state.copyWith(status: ToolsStatus.loading);
    final result = await _getUserKitchenToolUsecase.call(
      GetAvailableKitchenToolsUsecaseParams(uid: uid),
    );
    result.fold((failure) {
      state = state.copyWith(status: ToolsStatus.error, message: failure.errorMessage);
    }, (tools) {
      state = state.copyWith(status: ToolsStatus.loaded, kitchenTools: tools);
    });
  }
}
