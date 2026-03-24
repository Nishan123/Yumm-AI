import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';
enum ToolsStatus {
  initial,
  success,
  loading,
  loaded,
  error,
}

class ToolsState extends Equatable {
  final ToolsStatus status;
  final List<KitchenToolEntity>? kitchenTools;
  final String? message;
  
  // For tracking background actions (add/delete)
  final ToolsStatus actionStatus;
  final String? actionMessage;

  const ToolsState({
    this.status = ToolsStatus.initial,
    this.kitchenTools,
    this.message,
    this.actionStatus = ToolsStatus.initial,
    this.actionMessage,
  });

  ToolsState copyWith({
    ToolsStatus? status,
    List<KitchenToolEntity>? kitchenTools,
    String? message,
    ToolsStatus? actionStatus,
    String? actionMessage,
  }) {
    return ToolsState(
      status: status ?? this.status,
      kitchenTools: kitchenTools ?? this.kitchenTools,
      message: message ?? this.message,
      actionStatus: actionStatus ?? this.actionStatus,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    kitchenTools,
    message,
    actionStatus,
    actionMessage,
  ];
}