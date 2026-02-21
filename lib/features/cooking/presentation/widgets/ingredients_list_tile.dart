import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/features/chef/data/models/ingredient_model.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/cached_image_error_widget.dart';

class IngredientsListTile extends StatelessWidget {
  final IngredientModel ingredient;
  final Color textColor;
  final Function(bool?)? onChecked;

  const IngredientsListTile({
    super.key,
    required this.ingredient,
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
            child: ingredient.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: ingredient.imageUrl,
                    errorWidget: (context, url, error) {
                      return CachedImageErrorWidget(
                        backgroundColor: textColor,
                        icon: LucideIcons.salad,
                      );
                    },
                  )
                :  CachedImageErrorWidget(
                        backgroundColor: textColor,
                        icon: LucideIcons.salad,
                      ),
          ),
          SizedBox(width: 8),

          Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ingredient.name,
                style: AppTextStyles.normalText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              RichText(
                text: TextSpan(
                  style: AppTextStyles.descriptionText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.descriptionTextColor,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "${ingredient.quantity} ${ingredient.unit.toUpperCase()}",
                      style: AppTextStyles.descriptionText.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColors.descriptionTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Checkbox(value: ingredient.isReady, onChanged: onChecked),
        ],
      ),
    );
  }
}
