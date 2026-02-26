import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class InventoryListTile extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String quantity;
  final String unit;
  const InventoryListTile({super.key, required this.itemName, required this.imageUrl, required this.quantity, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightBlackColor,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.fastfood_outlined),
                  )
                : const Icon(Icons.fastfood_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: AppTextStyles.normalText.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$quantity $unit',
                  style: AppTextStyles.normalText.copyWith(
                    color: AppColors.descriptionTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
