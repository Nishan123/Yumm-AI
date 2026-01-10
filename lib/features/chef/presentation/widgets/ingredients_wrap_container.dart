import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';

class IngredientsWrapContainer extends StatelessWidget {
  final List<Widget> items;

  const IngredientsWrapContainer({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ConstantsString.commonPadding,
      padding: EdgeInsets.only(left: 11, top: 10, bottom: 8, right: 0),
      width: double.infinity,
      height: items.isEmpty ? 120 : null,
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        borderRadius: BorderRadius.circular(28),
        border: ContainerProperty.mainBorder,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: items.isEmpty
          ? Center(
              child: Text(
                "No Ingredients Selected 😪",
                style: AppTextStyles.h3.copyWith(color: AppColors.descriptionTextColor,fontWeight: FontWeight.bold),
              ),
            )
          : Wrap(children: [...items]),
    );
  }
}
