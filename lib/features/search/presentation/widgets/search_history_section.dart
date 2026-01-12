import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';

class SearchHistorySection extends StatelessWidget {
  final List<String> items;
  final VoidCallback? onClearAll;

  const SearchHistorySection({super.key, required this.items, this.onClearAll});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Search history', style: AppTextStyles.h6),
              CustomTextButton(
                text: "Clear All",
                onTap: () {},
                buttonTextStyle: AppTextStyles.h6,
                textColor: AppColors.redColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 0,
            children: items
                .map(
                  (text) => InputChip(
                    padding: EdgeInsets.only(left: 2, top: 2,bottom: 2, right: 0),
                    label: Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          text,
                          style: AppTextStyles.normalText.copyWith(
                            fontSize: 13,
                            color: AppColors.blackColor
                          ),
                        ),
                        InkWell(
                          child: Icon(LucideIcons.circle_x,color: Colors.red,size: 20,),
                        )
                      ],
                    ),
                    side: BorderSide(color: AppColors.lightBlackColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(400),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
