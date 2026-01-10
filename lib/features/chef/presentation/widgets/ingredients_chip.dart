import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/widgets/secondary_icon_button.dart';

class IngredientsChip extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String image;
  const IngredientsChip({
    super.key,
    required this.onTap,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      margin: EdgeInsets.only(right: 10, top: 5, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        border: ContainerProperty.smallBorder,
        boxShadow: [ContainerProperty.miniShadow],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CachedNetworkImage(imageUrl: image),
          ),
          Text(
            text,
            style: AppTextStyles.normalText.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SecondaryIconButton(icon: LucideIcons.circle_x, onTap: onTap),
        ],
      ),
    );
  }
}
