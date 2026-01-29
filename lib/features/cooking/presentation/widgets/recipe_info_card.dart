import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/enums/cooking_expertise.dart';
import 'package:yumm_ai/features/cooking/presentation/widgets/icon_with_label.dart';

class RecipeInfoCard extends StatelessWidget {
  final String duration;
  final int steps;
  final String expertise;
  final EdgeInsets margin;
  const RecipeInfoCard({
    super.key,
    required this.margin,
    required this.duration,
    required this.steps,
    required this.expertise,
  });
  // value to enum text
  CookingExpertise get _expertiseEnum {
    return CookingExpertise.values.firstWhere(
      (e) => e.value == expertise,
      orElse: () {
        return CookingExpertise.newBie;
      },
    );
  }

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
            text: duration,
            iconColor: AppColors.redColor,
          ),
          IconWithLabel(
            icon: LucideIcons.sandwich,
            text: "${steps.toString()} Steps",
            iconColor: AppColors.blueColor,
          ),
          IconWithLabel(
            icon: LucideIcons.chef_hat,
            text: _expertiseEnum.text,
            iconColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
