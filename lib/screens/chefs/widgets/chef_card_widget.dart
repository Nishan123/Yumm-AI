import 'package:flutter/material.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/container_property.dart';

class ChefCardWidget extends StatelessWidget {
  final String suffixImage;
  final String backgroundImage;
  final VoidCallback onTap;
  final String title;
  final String description;
  const ChefCardWidget({
    super.key,
    required this.suffixImage,
    required this.backgroundImage,
    required this.onTap,
    required this. title,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.extraLightBlackColor,
          borderRadius: BorderRadius.circular(28),
          border: ContainerProperty.mainBorder,
          boxShadow: [ContainerProperty.mainShadow],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Image.asset("${Constants.assetImage}/fridge_scanner.png"),
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(title,style: AppTextStyles.h5,),
                        Text(
                          description,
                          style: AppTextStyles.descriptionText,
                        ),
                      ],
                    ),
                    Image.asset("${Constants.assetImage}/1.png", width: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
