import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:readmore/readmore.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/core/styles/container_property.dart';
import 'package:yumm_ai/screens/cooking/widgets/icon_with_label.dart';
import 'package:yumm_ai/widgets/read_more_widget.dart';

class RecipeDetailsWidget extends StatelessWidget {
  const RecipeDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 32, left: 16, right: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [ContainerProperty.darkerShadow],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AI Generated Recipe Title or Name",
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            SizedBox(height: 6),
            ReadMoreWidget(
              text:
                  "Savor the zest of hot chicken legs enhanced with a citrusy shower of lemon, combining spicy warmth with a refreshing tang. Short description of the Food with some rich  laskdl lkas dlaks d history of origin of the food kdsnjfk sdkfj sa flkasd kla slkdc sald c.jkas dkcs kldj ",
              trimLine: 3,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.extraLightBlackColor,
                border: ContainerProperty.mainBorder,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [ContainerProperty.mainShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconWithLabel(icon: LucideIcons.clock, text: "1h 30m", iconColor: AppColors.redColor,),
                  IconWithLabel(icon: LucideIcons.sandwich, text: "23 Steps", iconColor: AppColors.blueColor,),
                  IconWithLabel(icon: LucideIcons.chef_hat, text: "Expert", iconColor: AppColors.primaryColor,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
