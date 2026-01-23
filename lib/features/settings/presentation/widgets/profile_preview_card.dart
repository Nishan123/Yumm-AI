import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';

class ProfilePreviewCard extends ConsumerWidget {
  final VoidCallback onTap;

  const ProfilePreviewCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch user data from the database
    final userAsync = ref.watch(currentUserProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.extraLightBlackColor,
          border: Border.all(width: 1, color: AppColors.lightBlackColor),
        ),
        child: userAsync.when(
          data: (user) => Row(
            spacing: 8,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.lightBlackColor,
                backgroundImage:
                    user?.profilePic != null && user!.profilePic!.isNotEmpty
                    ? NetworkImage(user.profilePic!)
                    : null,
                child: user?.profilePic == null || user!.profilePic!.isEmpty
                    ? Text(
                        user?.fullName.isNotEmpty == true
                            ? user!.fullName[0].toUpperCase()
                            : 'U',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullName ?? 'Username',
                      style: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      user?.email ?? 'email@example.com',
                      style: AppTextStyles.normalText.copyWith(
                        color: AppColors.descriptionTextColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevron_right, size: 30),
            ],
          ),
          loading: () => Row(
            spacing: 8,
            children: [
              CircleAvatar(radius: 26, backgroundColor: AppColors.blackColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlackColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 150,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlackColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(LucideIcons.chevron_right, size: 30),
            ],
          ),
          error: (_, __) => Row(
            spacing: 8,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.blackColor,
                child: Text(
                  '?',
                  style: AppTextStyles.h2.copyWith(color: AppColors.whiteColor),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error loading profile',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Tap to retry',
                    style: AppTextStyles.normalText.copyWith(
                      color: AppColors.descriptionTextColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(LucideIcons.chevron_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
