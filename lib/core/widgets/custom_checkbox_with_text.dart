import 'package:flutter/material.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';

class CustomCheckboxWithText extends StatelessWidget {
  final String text;
  final bool isAgreed;
  final ValueChanged<bool> onChanged;

  const CustomCheckboxWithText({
    super.key,
    required this.isAgreed,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isAgreed);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: isAgreed ? AppColors.redColor : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isAgreed ? AppColors.redColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isAgreed
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.normalText.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
