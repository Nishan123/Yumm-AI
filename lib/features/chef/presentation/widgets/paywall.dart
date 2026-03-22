import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/core/widgets/custom_dialogue_box.dart';

class Paywall {
  static Future<void> showPaywall(BuildContext context) async {
    await CustomDialogueBox.show(
      context,
      title: "Unlock Premium Features",
      titleColor: AppColors.primaryColor,
      description: "Upgrade to Pro to access Master Chef, Macro Chef, and all other exclusive cooking features.",
      okText: "Not Now",
      onOkTap: () {
        // Dialog handles popping
      },
      actionButtonText: "View Plans",
      onActionButtonTap: () {
        context.pushNamed("plans");
      },
      icons: LucideIcons.rocket,
    );
  }
}