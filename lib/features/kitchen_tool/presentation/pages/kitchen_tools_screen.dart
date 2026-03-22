import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/state/tools_state.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/view_models/kitchen_view_model.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/widgets/add_tool_bottom_sheet.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/widgets/kitchen_tools_card.dart';

class KitchenToolsScreen extends ConsumerStatefulWidget {
  const KitchenToolsScreen({super.key});

  @override
  ConsumerState<KitchenToolsScreen> createState() => _KitchenToolsScreenState();
}

class _KitchenToolsScreenState extends ConsumerState<KitchenToolsScreen> {
  List<KitchenToolModel> _selectedTools = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final uidAsync = ref.read(currentUserUidProvider);
      uidAsync.whenData((uid){
        if(uid!=null){
          ref.read(kitchenViewModelProvider.notifier).getUserTools(uid: uid);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final toolState = ref.watch(kitchenViewModelProvider);


  ref.listen<ToolsState>(kitchenViewModelProvider,(previous, next){
    if(next.status == ToolsStatus.error && next.message!=null){
      CustomSnackBar.showErrorSnackBar(context, next.message!);
    }
  });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ElevatedButton.icon(
          icon: Icon(LucideIcons.utensils),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.blackColor,
            foregroundColor: AppColors.whiteColor,
          ),
          onPressed: () async {
           showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return AddToolBottomSheet(
                    onSubmit: (List<KitchenToolModel> tools) {
                      for (var tool in tools) {
                        ref
                            .read(kitchenViewModelProvider.notifier)
                            .addKitchenTool(
                              kitchenTool: tool.toEntity(),
                            );
                      }
                    },
                    selectedTools: _selectedTools,
                  );
                },
              );
          },
          label: Text("Add Tool"),
        ),
      ),
      appBar: AppBar(
        title: Text("Available Kitchen tools"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _buildBody(toolState)
        ),
      ),
    );
  }
  Widget _buildBody(ToolsState state){
    if(state.status == ToolsStatus.loading){
      return Center(child: CircularProgressIndicator(),);
    }
    if(state.kitchenTools==null || state.kitchenTools!.isEmpty){
      return const Center( child:  Text("No kitchen tools added"),);
    }
    return GridView.builder(
            itemCount: state.kitchenTools!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.88,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final tool = state.kitchenTools![index];
              return KitchenToolsCard(index: index, kitchenTool:  KitchenToolModel.fromEntity(tool));
            },
          );
  }
}


