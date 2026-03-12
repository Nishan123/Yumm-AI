import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:yumm_ai/features/subscription/presentation/state/subscription_state.dart';
import 'package:yumm_ai/features/subscription/presentation/view_model/subscription_view_model.dart';
import 'package:yumm_ai/features/subscription/presentation/pages/available_plans_screen.dart';

class MockSubscriptionViewModel extends SubscriptionViewModel {
  @override
  SubscriptionState build() {
    return const SubscriptionState(
      status: SubscriptionStatus.success,
      subscriptionData: SubscriptionEntity(isPremium: false),
    );
  }

  @override
  Future<void> fetchOfferings() async {
    // do nothing to prevent actual revenue cat fetch
  }
}

void main() {
  testWidgets('available plans screen loads correctly', (
    WidgetTester tester,
  ) async {
    // Set a larger screen size to prevent overflow
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subscriptionViewModelProvider.overrideWith(
            () => MockSubscriptionViewModel(),
          ),
        ],
        child: const MaterialApp(home: AvailablePlansScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("Free for first 7 days !"), findsOneWidget);
  });
}
