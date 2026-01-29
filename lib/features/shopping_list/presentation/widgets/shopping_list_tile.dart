import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class ShoppingListTile extends StatelessWidget {
  final String itemName;
  final String dayAdded;
  final String quantity;
  final bool isChecked;
  final Function(bool?) onChanged;
  final String itemImage;
  const ShoppingListTile({
    super.key,
    required this.itemName,
    required this.dayAdded,
    required this.quantity,
    required this.isChecked,
    required this.onChanged,
    required this.itemImage,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.6, color: AppColors.lightPrimaryColor),
        borderRadius: BorderRadius.circular(16),
        color: AppColors.extraLightBlackColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 10),
      width: mq.width,
      child: Row(
        children: [
          Transform.scale(
            scale: 2,
            child: Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primaryColor;
                    }
                    return Colors.transparent;
                  }),
                  checkColor: WidgetStateProperty.all(AppColors.whiteColor),
                  side: BorderSide(
                    color: AppColors.lightPrimaryColor,
                    width: 2,
                  ),
                ),
              ),
              child: Checkbox(value: isChecked, onChanged: onChanged),
            ),
          ),

          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemName,
                style: AppTextStyles.h6.copyWith(
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
              Row(
                spacing: 8,
                children: [
                  Text(
                    quantity,
                    style: AppTextStyles.normalText.copyWith(
                      color: AppColors.descriptionTextColor,
                    ),
                  ),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightPrimaryColor,
                    ),
                  ),
                  Text(
                    "$dayAdded days ago",
                    style: AppTextStyles.normalText.copyWith(
                      color: AppColors.descriptionTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          itemImage.isNotEmpty
              ? CachedNetworkImage(
                  errorWidget: (context, url, error) {
                    return Icon(Icons.error);
                  },
                  imageUrl: itemImage,
                  height: 60,
                  width: 60,
                )
              : SizedBox(height: 60, width: 60),
        ],
      ),
    );
  }
}
