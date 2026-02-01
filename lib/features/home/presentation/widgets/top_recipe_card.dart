import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/primary_icon_button.dart';
import 'package:yumm_ai/core/widgets/dot.dart';
import 'package:yumm_ai/core/widgets/read_more_widget.dart';

class TopRecipeCard extends StatelessWidget {
  const TopRecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 30),
      width: double.infinity,
      child: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightBlackColor,
              borderRadius: BorderRadius.circular(26),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.27,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/salad.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12, top: 12),
                    child: PrimaryIconButton(
                      backgroundColor: AppColors.lightWhiteColor,
                      icon: LucideIcons.heart,
                      iconColor: AppColors.whiteColor,
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Text(
            "Food Title with some Description asa",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title,
          ),
          ReadMoreWidget(
            text:
                "Short description of the Food with some rich  laskdl lkas dlaks d history of origin of the food kdsnjfk sdkfj sa flkasd kla slkdc sald c.jkas dkcs kldj",
          ),
          Row(
            spacing: 6,
            children: [
              Flexible(
                child: Text(
                  "Can Cook",
                  style: AppTextStyles.normalText.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              dot(),
              Flexible(
                child: Text(
                  "45 min read",
                  style: AppTextStyles.normalText.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              dot(),
              Flexible(
                child: Text(
                  "Recipe Included",
                  style: AppTextStyles.normalText.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.redColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
