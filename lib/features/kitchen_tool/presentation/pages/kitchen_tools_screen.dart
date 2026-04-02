import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/custom_dialogue_box.dart';
import 'package:yumm_ai/core/widgets/custom_snack_bar.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/state/tools_state.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/view_models/kitchen_view_model.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/widgets/add_tool_bottom_sheet.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/widgets/kitchen_tools_card.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/widgets/tools_loading_skelaton.dart';

class KitchenToolsScreen extends ConsumerStatefulWidget {
  const KitchenToolsScreen({super.key});

  @override
  ConsumerState<KitchenToolsScreen> createState() => _KitchenToolsScreenState();
}

class _KitchenToolsScreenState extends ConsumerState<KitchenToolsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialTools();
    });
  }

  void _loadInitialTools() {
    final currentState = ref.read(kitchenViewModelProvider);
    if (currentState.status == ToolsStatus.loaded &&
        currentState.kitchenTools != null &&
        currentState.kitchenTools!.isNotEmpty) {
      return;
    }

    final uidAsync = ref.read(currentUserUidProvider);
    uidAsync.whenData((uid) {
      if (uid != null) {
        ref.read(kitchenViewModelProvider.notifier).getUserTools(uid: uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final toolState = ref.watch(kitchenViewModelProvider);

    ref.listen<ToolsState>(kitchenViewModelProvider, (previous, next) {
      if (next.status == ToolsStatus.error && next.message != null) {
        CustomSnackBar.showErrorSnackBar(context, next.message!);
      }

      if (previous?.actionStatus != next.actionStatus) {
        if (next.actionStatus == ToolsStatus.error &&
            next.actionMessage != null) {
          CustomSnackBar.showErrorSnackBar(context, next.actionMessage!);
        } else if (next.actionStatus == ToolsStatus.success &&
            next.actionMessage != null) {
          CustomSnackBar.showSuccessSnackBar(context, next.actionMessage!);
        }
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
                    final ownedIds =
                        toolState.kitchenTools?.map((t) => t.toolId).toSet() ??
                        {};
                    final newTools = tools
                        .where((tool) => !ownedIds.contains(tool.toolId))
                        .map((tool) => tool.toEntity())
                        .toList();
                    
                    if (newTools.isNotEmpty) {
                      ref
                          .read(kitchenViewModelProvider.notifier)
                          .addMultipleKitchenTools(tools: newTools);
                    }
                  },
                  selectedTools:
                      toolState.kitchenTools
                          ?.map((e) => KitchenToolModel.fromEntity(e))
                          .toList() ??
                      [],
                );
              },
            );
          },
          label: Text("Add Tool"),
        ),
      ),
      appBar: AppBar(title: Text("Available Kitchen tools")),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _buildBody(toolState),
        ),
      ),
    );
  }

  Widget _buildBody(ToolsState state) {
    if (state.status == ToolsStatus.loading) {
      return ToolsLoadingSkelaton();
    }
    if (state.status == ToolsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.circle_alert, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.message ?? "Something went wrong",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final uidAsync = ref.read(currentUserUidProvider);
                uidAsync.whenData((uid) {
                  if (uid != null) {
                    ref
                        .read(kitchenViewModelProvider.notifier)
                        .getUserTools(uid: uid);
                  }
                });
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }
    if (state.kitchenTools == null || state.kitchenTools!.isEmpty) {
      return const Center(child: Text("No kitchen tools added"));
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
        return KitchenToolsCard(
          index: index,
          kitchenTool: KitchenToolModel.fromEntity(tool),
          onTap: () {
            CustomDialogueBox.show(
              icons: LucideIcons.trash,
              okText: "Cancel",
              actionButtonText: "Remove",
              onActionButtonTap: () async {
                final uid = ref.read(currentUserUidProvider).value;
                if (uid != null) {
                  await ref
                      .read(kitchenViewModelProvider.notifier)
                      .deleteKitchenTool(
                        uid: uid,
                        toolId: tool.toolId,
                      );
                }
              
              },
              onOkTap: () {
                context.pop();
              },
              context,
              title: "Remove kitchen tool",
              description:
                  "Are you sure, you want to remove this tool from your kitchen",
            );
          },
        );
      },
    );
  }
}
