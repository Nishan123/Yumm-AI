import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/constants/constants_string.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/widgets/premium_ad_banner.dart';
import 'package:yumm_ai/features/cookbook/presentation/state/cookbook_state.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_error_widget.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_list.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/cookbook_loading_skelaton.dart';
import 'package:yumm_ai/features/cookbook/presentation/widgets/empty_cookbook_state_widget.dart';

class CookbookScreen extends ConsumerStatefulWidget {
  const CookbookScreen({super.key});

  @override
  ConsumerState<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends ConsumerState<CookbookScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCookbook();
    });
  }

  Future<void> _loadCookbook({bool forceRefresh = false}) async {
    final currentState = ref.read(cookbookViewModelProvider);
    if (!forceRefresh &&
        currentState.recipes.isNotEmpty &&
        currentState.status != CookbookStatus.initial &&
        currentState.status != CookbookStatus.error) {
      return; // Use cached data
    }

    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;
    if (user?.uid != null) {
      await ref
          .read(cookbookViewModelProvider.notifier)
          .getUserCookbook(user!.uid!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cookbookState = ref.watch(cookbookViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cookbook")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadCookbook(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(),
                const SizedBox(height: 18),
                PremiumAdBanner(
                  text: "Store\nUnlimited Meals",
                  backgroundImage: "${ConstantsString.assetSvg}/ad_banner2.svg",
                  buttonText: "Go Premium",
                ),
                const SizedBox(height: 18),
                _buildCookbookContent(cookbookState),
                const SizedBox(height: 98),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCookbookContent(CookbookState state) {
    if (state.status == CookbookStatus.loading) {
      return const CookbookLoadingSkelaton();
    }

    if (state.status == CookbookStatus.error) {
      return CookbookErrorWidget(
        onRetry: () {
          _loadCookbook(forceRefresh: true);
        },
        errorMessage: state.errorMessage ?? 'Failed to load cookbook',
      );
    }

    if (state.recipes.isEmpty) {
      return EmptyCookbookStateWidget();
    }

    return CookbookList(state: state);
  }
}
