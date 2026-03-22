import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/premium_ad_banner.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/chef_card_widget.dart';
import 'package:yumm_ai/features/chef/presentation/widgets/paywall.dart';
import 'package:yumm_ai/features/subscription/presentation/view_model/subscription_view_model.dart';

class ChefsScreen extends ConsumerWidget {
  const ChefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionViewModelProvider);
    final subscriptionData = subscriptionState.subscriptionData;
    final bool isPremium = subscriptionData?.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(title: Text("Select your desired chef")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 18,
            children: [
              Divider(),
              PremiumAdBanner(
                text: "Unlock\nAll Chefs",
                backgroundImage: "${ConstantsString.assetSvg}/ad_banner2.svg",
                buttonText: "Go Premium",
              ),
              ChefCardWidget(
                havePremium: true,
                suffixImage: ConstantsString.fridgeScannerSuffix,
                backgroundImage: ConstantsString.fridgeScannerBackground,
                onTap: () {
                  context.pushNamed(
                    "scanner",
                    queryParameters: {"selectedScanner": "fridgeScanner"},
                  );
                },
                title: "Fridge Scanner",
                description:
                    "Scan inside your fridge to prepare the combination of available items ",
              ),
              ChefCardWidget(
                havePremium: true,
                suffixImage: ConstantsString.receiptScannerSuffix,
                backgroundImage: ConstantsString.receiptScannerBackground,
                onTap: () {
                  context.pushNamed(
                    "scanner",
                    queryParameters: {"selectedScanner": "receiptScanner"},
                  );
                },
                title: "Receipt Scanner",
                description: "Scan your ingredients receipt to prepare a meal",
              ),
              ChefCardWidget(
                havePremium: true,
                isSuffixCropped: true,
                suffixImage: ConstantsString.pantryChefSuffix,
                backgroundImage: ConstantsString.pantryChefBackground,
                onTap: () {
                  context.pushNamed("pantry_chef");
                },
                title: "Pantry Chef",
                description:
                    "Generate recipes based on the ingredients in you pantry.",
              ),
              ChefCardWidget(
                havePremium: isPremium,
                isSuffixCropped: true,
                suffixImage: ConstantsString.masterChefSuffix,
                backgroundImage: ConstantsString.masterChefBackground,
                onTap: () {
                  isPremium?
                  context.pushNamed("master_chef"):Paywall.showPaywall(context);
                },
                title: "Master Chef",
                description:
                    "Generate personalized recipes to suite your carvings and dietary needs",
              ),
              ChefCardWidget(
                havePremium: isPremium,
                suffixImage: ConstantsString.macroChefSuffix,
                backgroundImage: ConstantsString.macroChefBackground,
                onTap: () {
                  isPremium?
                  context.pushNamed("macro_chef"):Paywall.showPaywall(context);
                },
                title: "Macro Chef",
                description:
                    "Create recipes tailored to your nutrients targets and dietary limits",
              ),
              ChefCardWidget(
                havePremium: isPremium,
                suffixImage: ConstantsString.pairPerfectSuffix,
                backgroundImage: ConstantsString.pairPerfectBackground,
                onTap: () {},
                title: "Pair Perfect",
                description:
                    "Get prefect recommended wine or beer paring for your meal",
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
