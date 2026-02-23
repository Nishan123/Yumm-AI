import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/app/theme/container_property.dart';
import 'package:yumm_ai/features/subscription/presentation/state/subscription_state.dart';
import 'package:yumm_ai/features/subscription/presentation/view_model/subscription_view_model.dart';
import 'package:go_router/go_router.dart';

class PremiumAdBanner extends ConsumerWidget {
  final String text;
  final String backgroundImage;
  final String buttonText;
  const PremiumAdBanner({
    super.key,
    required this.text,
    required this.backgroundImage,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subState = ref.watch(subscriptionViewModelProvider);

    // Auto-fetch if data is missing during widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (subState.status == SubscriptionStatus.initial) {
        ref.read(subscriptionViewModelProvider.notifier).checkEntitlement();
      }
    });

    if (subState.status == SubscriptionStatus.initial ||
        subState.status == SubscriptionStatus.loading) {
      return const SizedBox.shrink();
    }

    final isPremium = subState.subscriptionData?.isPremium ?? false;

    if (isPremium) {
      return const SizedBox.shrink();
    }
    return _buildBanner(context);
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed("plans");
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: ContainerProperty.mainBorder,
          boxShadow: [ContainerProperty.mainShadow],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(28),
              child: SvgPicture.asset(backgroundImage, fit: BoxFit.cover),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      wordSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.blackColor,
                      foregroundColor: AppColors.whiteColor,
                    ),
                    onPressed: () {
                      context.pushNamed("plans");
                    },
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
