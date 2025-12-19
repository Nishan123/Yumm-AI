import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/styles/app_colors.dart';
import 'package:yumm_ai/core/styles/app_text_styles.dart';
import 'package:yumm_ai/widgets/primary_icon_button.dart';

class HomeFoodRecommendations extends StatelessWidget {
  final double mainFontSize;
  final double iconsSize;
  final double normalFontSize;
  const HomeFoodRecommendations({
    super.key,
    required this.mainFontSize,
    required this.iconsSize,
    required this.normalFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            context.pushNamed("cooking");
          },
          child: Container(
            width: mq.width * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: AppColors.lightBlackColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/images/salad.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14, top: 14),
                      child: PrimaryIconButton(
                        backgroundColor: AppColors.lightWhiteColor,
                        icon: LucideIcons.heart,
                        iconColor: AppColors.whiteColor,
                        onTap: () {},
                      ),
                    ),
                  ),
                  // Bottom gradient overlay fixed to the bottom portion only
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        widthFactor: 1.0,
                        heightFactor: 0.55,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(180, 0, 0, 0),
                                Color.fromARGB(80, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0),
                              ],
                              stops: [0.0, 0.6, 1.0],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name of the Dish and some random descriptions",
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.h3.copyWith(
                                    fontSize: mainFontSize,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildInfoBox(
                                      info: "25 min",
                                      icon: LucideIcons.clock,
                                      fontSize: normalFontSize,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildInfoBox(
                                      info: "Intermediate",
                                      icon: LucideIcons.brain,
                                      fontSize: normalFontSize,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBox({
    required String info,
    required IconData icon,
    required double fontSize,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white24,
          ),
          child: Row(
            spacing: 8,
            children: [
              Icon(icon, size: iconsSize, color: AppColors.whiteColor),
              Text(
                info,
                style: AppTextStyles.normalText.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
