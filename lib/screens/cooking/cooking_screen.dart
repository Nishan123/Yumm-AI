import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/consts/constants.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/screens/cooking/widgets/recipe_details_widget.dart';
import 'package:yumm_ai/widgets/primary_icon_button.dart';

class CookingScreen extends StatelessWidget {
  const CookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: mq.height * 0.39,
              color: AppColors.lightBlackColor,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "${Constants.assetImage}/salad.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryIconButton(
                          iconColor: AppColors.whiteColor,
                          icon: LucideIcons.chevron_left,
                          onTap: () {
                            context.pop();
                          },
                        ),
                        PrimaryIconButton(
                          iconColor: AppColors.whiteColor,
                          icon: LucideIcons.heart,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            RecipeDetailsWidget(),
          ],
        ),
      ),
    );
  }
}
