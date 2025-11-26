import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yumm_ai/screens/setting/widgets/profile_preview_card.dart';
import 'package:yumm_ai/screens/setting/widgets/setting_item_card.dart';
import 'package:yumm_ai/screens/setting/widgets/setting_list_group.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
            child: Column(
              spacing: 12,
              children: [
                ProfilePreviewCard(),
                SizedBox(height: 12),
                SettingListGroup(
                  groupName: "Account",
                  settingLists: [
                    SettingItemCard(
                      leadingIcon: LucideIcons.user,
                      title: 'Account access',
                      subTitle:
                          'Security, account activation and deactivation.',
                    ),
                    SettingItemCard(
                      leadingIcon: LucideIcons.shield,
                      title: 'Login & Security',
                      subTitle: 'Manage your information on this app.',
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
                      leadingIcon: LucideIcons.smile,
                      title: 'Feedback',
                      subTitle: 'Share your thoughts and help us improve',
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
                SizedBox(height: 108),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
