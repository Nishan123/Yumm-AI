import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';

class ItemCard extends StatelessWidget {
  final String itemName;
  final int savedItems;
  final String image;
  final VoidCallback onTap;
  const ItemCard({
    super.key,
    required this.mq,
    required this.itemName,
    required this.savedItems,
    required this.image,
    required this.onTap,
  });

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.extraLightBlackColor,
                borderRadius: BorderRadius.circular(22),
                border: ContainerProperty.mainBorder,
                boxShadow: [ContainerProperty.mainShadow],
              ),
              child: Center(
                child: Image.asset(
                  image,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            itemName,
            style: AppTextStyles.h6,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${savedItems.toString()} Saved",
            style: AppTextStyles.normalText.copyWith(
              color: AppColors.descriptionTextColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
