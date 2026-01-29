import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumm_ai/app/theme/app_colors.dart';
import 'package:yumm_ai/app/theme/app_text_styles.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/widgets/svg_text_logo.dart';
import 'package:yumm_ai/features/chef/presentation/state/chef_state.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/active_chef_provider.dart';

class RecipeGenerationLoadingScreen extends ConsumerWidget {
  const RecipeGenerationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeChefStateProvider);

    // go to cooking screen
    ref.listen(activeChefStateProvider, (previous, next) {
      if (next.status == ChefStatus.success && next.generatedRecipe != null) {
        context.pop();
        context.pushNamed('cooking', extra: next.generatedRecipe!.toEntity());
      }
      if (next.status == ChefStatus.error) {
        context.pop();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 50,
              width: double.infinity,
              child: SvgTextLogo(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,

              child: Image.asset(
                '${ConstantsString.assetGif}/generatingRecipe.gif',
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 50, right: 16, left: 16),
              child: Column(
                children: [
                  Text(
                    state.loadingMessage ?? "Your Recipe is being generated",
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
