import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/kitchen_tool/domain/entities/kitchen_tool_entity.dart';
enum ToolsStatus {
  success,
  loading,
  loaded,
  error,
  
}
class ToolsState extends Equatable{

  final ToolsStatus? status;
  final List<KitchenToolEntity>? kitchenTools;
  final String? message;

  const ToolsState({
     this.status,
     this.kitchenTools,
     this.message
  });

  ToolsState copyWith({
    ToolsStatus? status,
    List<KitchenToolEntity>? kitchenTools,
    String? message
  }){
    return ToolsState(
      status: status??this.status, 
      kitchenTools: kitchenTools??this.kitchenTools,
      message: message??this.message
      );
  }

  
  @override
  List<Object?> get props => [status, kitchenTools,message];

}