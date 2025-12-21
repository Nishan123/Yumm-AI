import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';

class ToolsListTile extends StatelessWidget {
  final String toolName;
  final String image;
  final Color bgColor;
  const ToolsListTile({
    super.key,
    required this.toolName,
    required this.image,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.height * 0.09,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
          child: SizedBox(
            height: 40,
            width: 40,
            child: CachedNetworkImage(
              imageUrl: image,
              errorWidget: (context, url, error) {
                return Text("N/A");
              },
            ),
          ),
        ),
        Text(
          toolName,
          style: AppTextStyles.normalText.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
