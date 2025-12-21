import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class ToolsListTile extends StatelessWidget {
  final String toolName;
  final String image;
  final Color textColor;
  const ToolsListTile({
    super.key,
    required this.toolName,
    required this.image,
    required this.textColor,
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
            child: CachedNetworkImage(
              imageUrl: image,
              height: 40,
              width: 40,
              errorWidget: (context, url, error) {
                return SizedBox(height: 40, width: 40, child: Text("N/A"));
              },
            ),
          ),
          SizedBox(width: 8),

          Text(
            toolName,
            style: AppTextStyles.normalText.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
