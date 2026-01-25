import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/input_widget_title.dart';
import 'package:yumm_ai/core/widgets/primary_text_field.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/providers/get_tools_provider.dart';

class AddToolBottomSheet extends StatefulWidget {
  final List<KitchenToolModel> selectedTools;
  final ValueChanged<List<KitchenToolModel>> onSubmit;
  const AddToolBottomSheet({
    super.key,
    required this.selectedTools,
    required this.onSubmit,
  });

  @override
  State<AddToolBottomSheet> createState() => _AddToolBottomSheetState();
}

class _AddToolBottomSheetState extends State<AddToolBottomSheet> {
  final TextEditingController searchToolsController = TextEditingController();
  String query = "";
  late Set<String> _selectedIds;
  List<KitchenToolModel> _tools = [];
  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedTools.map((e) => e.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 4, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: mq.viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(thickness: 4, indent: 120, endIndent: 120),
              InputWidgetTitle(
                onActionTap: () {
                  widget.onSubmit(
                    _tools
                        .where((tool) => _selectedIds.contains(tool.id))
                        .toList(),
                  );
                  Navigator.of(context).pop();
                },
                haveActionButton: true,
                actionButtonText: "Done",
                title: "Add available tools",
                padding: EdgeInsets.only(left: 0, top: 8, bottom: 8),
              ),

              SizedBox(height: 12),

              // search text field
              PrimaryTextField(
                hintText: 'Search: non stick pan',
                controller: searchToolsController,
                onChange: (value) {
                  setState(() {
                    query = value.trim();
                  });
                },
              ),
              SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: mq.size.height * 0.4),
                child: Consumer(
                  builder: (context, ref, child) {
                    final toolsAsync = ref.watch(getToolsProvider);
                    return toolsAsync.when(
                      data: (tools) {
                        _tools = tools;
                        final filtered = query.isEmpty
                            ? tools
                            : tools
                                  .where(
                                    (tool) => tool.name.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ),
                                  )
                                  .toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final tool = filtered[index];
                            final isSelected = _selectedIds.contains(tool.id);
                            return Container(
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.only(
                                left: 12,
                                top: 4,
                                bottom: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.lightBlackColor,
                              ),
                              width: mq.size.width,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CachedNetworkImage(
                                      imageUrl: tool.prefixImage,
                                      fit: BoxFit.contain,
                                      placeholder: (c, s) => Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (c, s, e) =>
                                          Icon(Icons.kitchen),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    tool.name,
                                    style: AppTextStyles.normalText.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Spacer(),
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedIds.remove(tool.id);
                                        } else {
                                          _selectedIds.add(tool.id);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stack) {
                        return Center(child: Text("Failed to load tools: $error"));
                      },
                      loading: () {
                        return Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
