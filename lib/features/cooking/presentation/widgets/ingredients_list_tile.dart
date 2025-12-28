import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/Ingrident_model.dart';

class IngredientsListTile extends StatelessWidget {
  final IngredientModel ingredient;
  final String quantity;
  final Color textColor;
  const IngredientsListTile({
    super.key,
    required this.ingredient,
    required this.quantity,
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
            height: 35,
            width: 35,
            child: CachedNetworkImage(
              imageUrl: ingredient.prefixImage,
              errorWidget: (context, url, error) {
                return SizedBox(height: 35, width: 35, child: Text("N/A"));
              },
            ),
          ),
          SizedBox(width: 8),

          Text(
            ingredient.ingredientName,
            style: AppTextStyles.normalText.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Spacer(),
          RichText(
            text: TextSpan(
              style: AppTextStyles.descriptionText.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.descriptionTextColor,
              ),
              children: [
                TextSpan(text: "QTY: "),
                TextSpan(
                  text: "2",
                  style: AppTextStyles.descriptionText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
