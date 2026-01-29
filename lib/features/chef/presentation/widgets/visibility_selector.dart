import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';

class VisibilitySelector extends StatelessWidget {
  final bool isPublic;
  final ValueChanged<bool> onChanged;

  const VisibilitySelector({
    super.key,
    required this.isPublic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isPublic
                          ? AppColors.primaryColor
                          : AppColors.extraLightBlackColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isPublic
                            ? AppColors.primaryColor
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.globe,
                          color: isPublic
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Public",
                          style: TextStyle(
                            color: isPublic
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: !isPublic
                          ? AppColors.primaryColor
                          : AppColors.extraLightBlackColor,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        
                        color: !isPublic
                            ? AppColors.primaryColor
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.lock,
                          color: !isPublic
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Private",
                          style: TextStyle(
                            color: !isPublic
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Text(
            isPublic
                ? "Your recipe will be visible to all users and appear in home recommendations."
                : "Your recipe will be saved privately in your cookbook only.",
            style: TextStyle(
              color: AppColors.descriptionTextColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
