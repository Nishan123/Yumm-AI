import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/widgets/custom_text_button.dart';
import 'package:yumm_ai/core/widgets/primary_button.dart';
import 'package:yumm_ai/features/subscription/presentation/state/subscription_state.dart';
import 'package:yumm_ai/features/subscription/presentation/view_model/subscription_view_model.dart';
import 'package:yumm_ai/features/subscription/presentation/widgets/deals_card.dart';

class AvailablePlansScreen extends ConsumerStatefulWidget {
  const AvailablePlansScreen({super.key});

  @override
  ConsumerState<AvailablePlansScreen> createState() =>
      _AvailablePlansScreenState();
}

class _AvailablePlansScreenState extends ConsumerState<AvailablePlansScreen> {
  Package? _selectedPackage;

  @override
  void initState() {
    super.initState();
    // Fetch offerings on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionViewModelProvider.notifier).fetchOfferings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    // Listen to changes in the subscription state
    ref.listen<SubscriptionState>(subscriptionViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == SubscriptionStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }

      if (next.status == SubscriptionStatus.success &&
          next.subscriptionData != null) {
        final offerings = next.subscriptionData!.currentOffering;
        if (offerings != null &&
            offerings.availablePackages.isNotEmpty &&
            _selectedPackage == null) {
          setState(() {
            _selectedPackage =
                offerings.annual ?? offerings.availablePackages.first;
          });
        }

        if (next.subscriptionData!.isPremium) {
          if (mounted) context.pop();
        }
      }
    });

    final subState = ref.watch(subscriptionViewModelProvider);
    final isProcessing = subState.status == SubscriptionStatus.processing;
    final isLoading =
        subState.status == SubscriptionStatus.loading ||
        subState.subscriptionData == null;

    final currentOffering = subState.subscriptionData?.currentOffering;
    final annualPackage = currentOffering?.annual;
    final monthlyPackage = currentOffering?.monthly;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.rocket, size: 36),
                        SizedBox(width: 6),
                        Text(
                          "Free for first 7 days !",
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.grayColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Unlock the full experience\nand level up your cooking game.",
                      style: AppTextStyles.h5.copyWith(height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),

                    if (annualPackage != null)
                      DealsCard(
                        onTap: () {
                          setState(() {
                            _selectedPackage = annualPackage;
                          });
                        },
                        mq: mq,
                        isSelected: _selectedPackage == annualPackage,
                        haveBestValueTag: true,
                        actualPrice: annualPackage.storeProduct.priceString,
                        oldPrice:
                            "\$${((annualPackage.storeProduct.price / 12) * 1.2 * 12).toStringAsFixed(2)}",
                        duration: "year",
                      ),
                    SizedBox(height: 12),

                    if (monthlyPackage != null)
                      DealsCard(
                        onTap: () {
                          setState(() {
                            _selectedPackage = monthlyPackage;
                          });
                        },
                        mq: mq,
                        isSelected: _selectedPackage == monthlyPackage,
                        haveBestValueTag: false,
                        actualPrice: monthlyPackage.storeProduct.priceString,
                        oldPrice: "",
                        duration: "month",
                        haveOldPrice: false,
                      ),

                    SizedBox(height: 40),
                    PrimaryButton(
                      isLoading: isProcessing,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      text: "Upgrade to Pro",
                      onTap: () {
                        if (_selectedPackage != null) {
                          ref
                              .read(subscriptionViewModelProvider.notifier)
                              .purchasePackage(_selectedPackage!);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Billing starts at the end of your free trial. Starting on 17/06/2024 you will be billed ${_selectedPackage?.storeProduct.priceString ?? 'amount'} every year until you cancel. You can cancel anytime in the Google Play Store",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.descriptionText.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomTextButton(
                      text: "Restore Purchases",
                      onTap: () {
                        ref
                            .read(subscriptionViewModelProvider.notifier)
                            .restorePurchases();
                      },
                    ),
                    CustomTextButton(text: "Terms & Conditions", onTap: () {}),

                    SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
