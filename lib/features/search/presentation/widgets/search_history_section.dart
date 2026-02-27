import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';

class SearchHistorySection extends StatelessWidget {
  final List<String> items;
  final VoidCallback? onClearAll;

  final Function(String) onSearch;
  final Function(String) onDelete;

  const SearchHistorySection({
    super.key,
    required this.items,
    this.onClearAll,
    required this.onSearch,
    required this.onDelete,
  });

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
                onTap: onClearAll ?? () {},
                buttonTextStyle: AppTextStyles.normalText,
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
                    padding: EdgeInsets.only(
                      left: 2,
                      top: 2,
                      bottom: 2,
                      right: 0,
                    ),
                    label: Text(
                      text,
                      style: AppTextStyles.normalText.copyWith(
                        fontSize: 13,
                        color: AppColors.blackColor,
                      ),
                    ),
                    deleteIcon: Icon(
                      LucideIcons.circle_x,
                      color: Colors.red,
                      size: 20,
                    ),
                    onDeleted: () => onDelete(text),
                    side: BorderSide(color: AppColors.lightBlackColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(400),
                    ),
                    onPressed: () => onSearch(text),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
