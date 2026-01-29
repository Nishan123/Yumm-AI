import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/kitchen_tool/data/models/kitchen_tools_model.dart';

class ToolsListTile extends StatelessWidget {
  final KitchenToolModel kitchenTool;
  final Color textColor;
  final Function(bool?)? onChecked;
  const ToolsListTile({
    super.key,
    required this.kitchenTool,
    required this.textColor,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.6, color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: kitchenTool.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: kitchenTool.imageUrl,
                    height: 40,
                    width: 40,
                    errorWidget: (context, url, error) {
                      return SizedBox(height: 40, width: 40, child: Text("N/A"));
                    },
                  )
                : const SizedBox(height: 40, width: 40, child: Text("N/A")),
          ),
          SizedBox(width: 8),

          Text(
            kitchenTool.toolName,
            style: AppTextStyles.normalText.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Spacer(),
          Checkbox(value: kitchenTool.isReady, onChanged: onChecked),
        ],
      ),
    );
  }
}
