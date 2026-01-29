import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/widgets/add_tool_bottom_sheet.dart';
import 'package:yumm_ai/features/kitchen_tool/presentation/widgets/kitchen_tools_card.dart';

class KitchenToolsScreen extends StatefulWidget {
  const KitchenToolsScreen({super.key});

  @override
  State<KitchenToolsScreen> createState() => _KitchenToolsScreenState();
}

class _KitchenToolsScreenState extends State<KitchenToolsScreen> {
  List<KitchenToolModel> _selectedTools = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Available Kitchen tools"),
        actions: [
          CustomTextButton(
            text: "Add Tool",
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return AddToolBottomSheet(
                    onSubmit: (List<KitchenToolModel> tools) {
                      setState(() {
                        _selectedTools = tools;
                      });
                    },
                    selectedTools: _selectedTools,
                  );
                },
              );
            },
            buttonTextStyle: AppTextStyles.h6.copyWith(
              color: AppColors.blueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            itemCount: 5,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.88,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return KitchenToolsCard(index: index, kitchenTool: KitchenToolModel(toolId: '001', toolName: "Microwave", imageUrl: ""),);
            },
          ),
        ),
      ),
    );
  }
}
