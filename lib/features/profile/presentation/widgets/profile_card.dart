import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/change_username_text_filed.dart';

import 'package:yumm_ai/core/providers/user_selectors.dart';

class ProfileCard extends ConsumerWidget {
  final TextEditingController userNameController;
  final File? selectedImage;
  final VoidCallback onProfileIconTap;
  const ProfileCard({
    super.key,
    required this.userNameController,
    required this.onProfileIconTap,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);

    // Use database-based provider - fetches from server
    final userDataAsync = ref.watch(currentUserProvider);
    // Watch cache key for profile picture reload
    final cacheKey = ref.watch(profilePicCacheKeyProvider);

    return userDataAsync.when(
      data: (userData) {
        final displayName = userData!.fullName;
        final displayEmail = userData.email;
        final profilePicUrl = userData.profilePic;
        final isSubscribedUser = userData.isSubscribedUser;

        // Add cache buster to URL if it exists
        String? cacheBustedUrl;
        if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
          final separator = profilePicUrl.contains('?') ? '&' : '?';
          cacheBustedUrl = '$profilePicUrl${separator}v=$cacheKey';
        }

        return _buildProfileCard(
          ref: ref,
          mq: mq,
          displayName: displayName,
          displayEmail: displayEmail,
          profilePicUrl: cacheBustedUrl,
          isSubscribed: isSubscribedUser ?? false,
          selectedImage: selectedImage,
        );
      },
      loading: () => _buildLoadingCard(mq),
      error: (_, __) => _buildProfileCard(
        ref: ref,
        mq: mq,
        displayName: 'Username',
        displayEmail: 'user@example.com',
        profilePicUrl: null,
        isSubscribed: false,
        selectedImage: selectedImage,
      ),
    );
  }

  Widget _buildProfileCard({
    required WidgetRef ref,
    required MediaQueryData mq,
    required String displayName,
    required String displayEmail,
    required String? profilePicUrl,
    required bool isSubscribed,
    File? selectedImage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      width: mq.size.width,
      decoration: BoxDecoration(
        border: ContainerProperty.mainBorder,
        borderRadius: BorderRadius.circular(36),
        color: AppColors.extraLightBlackColor,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              InkWell(
                onTap: onProfileIconTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.lightBlackColor,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage)
                          : (profilePicUrl != null && profilePicUrl.isNotEmpty
                                    ? NetworkImage(profilePicUrl)
                                    : null)
                                as ImageProvider?,
                      child:
                          selectedImage == null &&
                              (profilePicUrl == null || profilePicUrl.isEmpty)
                          ? Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : 'U',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blueColor,
                        ),
                        child: Icon(
                          LucideIcons.camera,
                          size: 16,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Text(
                          displayName,
                          style: AppTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        _planChip(
                          backgroundColor: AppColors.lightBlueColor,
                          plan: isSubscribed ? "Pro" : "Free",
                        ),
                      ],
                    ),
                    Text(
                      displayEmail,
                      maxLines: 2,
                      style: AppTextStyles.h6.copyWith(
                        color: AppColors.descriptionTextColor,
                        fontWeight: FontWeight.w400,

                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ChangeUsernameTextFiled(userNameController: userNameController),
          SizedBox(height: 20),
          PrimaryButton(text: "Upgrade to Pro", onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(MediaQueryData mq) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      width: mq.size.width,
      decoration: BoxDecoration(
        border: ContainerProperty.mainBorder,
        borderRadius: BorderRadius.circular(36),
        color: AppColors.extraLightBlackColor,
        boxShadow: [ContainerProperty.mainShadow],
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              CircleAvatar(radius: 30, backgroundColor: AppColors.primaryColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Container(
                    width: 120,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlackColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 180,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlackColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightBlackColor,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightBlackColor,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planChip({required Color backgroundColor, required String plan}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        plan,
        style: AppTextStyles.normalText.copyWith(color: AppColors.whiteColor),
      ),
    );
  }
}
