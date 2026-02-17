import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/widgets/custom_dialogue_box.dart';
import 'package:yumm_ai/core/widgets/secondary_button.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:yumm_ai/features/settings/presentation/widgets/profile_preview_card.dart';
import 'package:yumm_ai/features/settings/presentation/widgets/setting_item_card.dart';
import 'package:yumm_ai/features/settings/presentation/widgets/setting_list_group.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        context.goNamed('login');
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
            child: Column(
              spacing: 12,
              children: [
                ProfilePreviewCard(
                  onTap: () {
                    context.pushNamed("profile");
                  },
                ),
                SizedBox(height: 12),
                SettingListGroup(
                  groupName: "Account",
                  settingLists: [
                    SettingItemCard(
                      leadingIcon: LucideIcons.user,
                      title: 'Security & Password',
                      subTitle:
                          'Change your password with new one for security refresh.',
                      onTap: () {
                        context.pushNamed("change_password");
                      },
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.shield,
                      title: 'Account access',
                      subTitle: 'Deactivate or delete your account permanently',
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.dollar_sign,
                      title: 'Manage Subscription',
                      subTitle:
                          'Change your subscription plan for more access.',
                    ),
                  ],
                ),
                Divider(),
                SettingListGroup(
                  groupName: "Preferences",
                  settingLists: [
                    SettingItemCard(
                      leadingIcon: LucideIcons.bell,
                      title: 'Notifications',
                      subTitle: 'Select the kind of notification you get.',
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.sliders_horizontal,
                      title: ' Food Preferences',
                      subTitle:
                          'Tune your likings and food habit on daily basis.',
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.book,
                      title: 'Accessibility & languages',
                      subTitle: 'Manage how contents are displayed to you.',
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.sun,
                      title: 'App theme',
                      subTitle:
                          'Change the theme of the app as per your likings.',
                    ),
                  ],
                ),
                Divider(),
                SettingListGroup(
                  groupName: "Additional",
                  settingLists: [
                    SettingItemCard(
                      leadingIcon: LucideIcons.bug,
                      title: 'Report bug',
                      subTitle: 'Report bug or app crashes & help us improve',
                      onTap: () {
                        context.goNamed("report_bug");
                      },
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.box,
                      title: 'Additional resources',
                      subTitle: 'Checkout other places to know more about app.',
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.info,
                      title: 'Help',
                      subTitle: 'Help center, contacts, privacy policy.',
                    ),
                  ],
                ),
                Divider(),
                SecondaryButton(
                  text: "Log Out",
                  borderRadius: 12,
                  backgroundColor: AppColors.redColor,
                  onTap: () {
                    CustomDialogueBox.show(
                      context,
                      title: "Log Out?",
                      description: "Are you sure you want to log out?",
                      okText: "Cancel",
                      onOkTap: () {},
                      actionButtonText: "Log Out",
                      onActionButtonTap: () {
                        ref.read(authViewModelProvider.notifier).logout();
                      },
                      barrierDismissible: false,
                    );
                  },
                ),
                SizedBox(height: 108),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
