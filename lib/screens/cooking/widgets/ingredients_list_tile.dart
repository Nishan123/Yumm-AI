import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/models/ingredients_model.dart';

class IngredientsListTile extends StatelessWidget {
  final IngredientsModel ingredient;
  final String quantity;

  const IngredientsListTile({
    super.key,
    required this.ingredient,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBlackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: CachedNetworkImage(
              imageUrl: ingredient.prefixImage,
              errorWidget: (context, url, error) {
                return Text("N/A");
              },
            ),
          ),
          SizedBox(width: 8),
          Text(
            ingredient.ingredientName,
            style: AppTextStyles.normalText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          Text(quantity),
        ],
      ),
    );
  }
}
