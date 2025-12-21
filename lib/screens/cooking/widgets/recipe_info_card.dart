import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/container_property.dart';
import 'package:yumm_ai/screens/cooking/widgets/icon_with_label.dart';

class RecipeInfoCard extends StatelessWidget {
  final EdgeInsets margin;
  const RecipeInfoCard({super.key, required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.extraLightBlackColor,
        border: ContainerProperty.mainBorder,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconWithLabel(
            icon: LucideIcons.clock,
            text: "1h 30m",
            iconColor: AppColors.redColor,
          ),
          IconWithLabel(
            icon: LucideIcons.sandwich,
            text: "23 Steps",
            iconColor: AppColors.blueColor,
          ),
          IconWithLabel(
            icon: LucideIcons.chef_hat,
            text: "Expert",
            iconColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
