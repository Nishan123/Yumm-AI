import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/check_entitlement_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/get_offerings_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/purchase_subscription_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/restore_purchases_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:yumm_ai/features/subscription/presentation/state/subscription_state.dart';

final subscriptionViewModelProvider =
    NotifierProvider<SubscriptionViewModel, SubscriptionState>(
      () => SubscriptionViewModel(),
    );

class SubscriptionViewModel extends Notifier<SubscriptionState> {
  GetOfferingsUsecase get _getOfferingsUsecase =>
      ref.read(getOfferingsUsecaseProvider);
  PurchaseSubscriptionUsecase get _purchaseSubscriptionUsecase =>
      ref.read(purchaseSubscriptionUsecaseProvider);
  RestorePurchasesUsecase get _restorePurchasesUsecase =>
      ref.read(restorePurchasesUsecaseProvider);
  CheckEntitlementUsecase get _checkEntitlementUsecase =>
      ref.read(checkEntitlementUsecaseProvider);

  @override
  SubscriptionState build() {
    return const SubscriptionState();
  }

  Future<void> fetchOfferings() async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final result = await _getOfferingsUsecase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (subscriptionData) {
        state = state.copyWith(
          status: SubscriptionStatus.success,
          subscriptionData: subscriptionData,
        );
      },
    );
  }

  Future<void> purchasePackage(Package package) async {
    state = state.copyWith(status: SubscriptionStatus.processing);
    final result = await _purchaseSubscriptionUsecase.call(package);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (isPro) {
        // Automatically fetch new offerings state after a successful purchase
        fetchOfferings();
      },
    );
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(status: SubscriptionStatus.processing);
    final result = await _restorePurchasesUsecase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (isPro) {
        fetchOfferings();
      },
    );
  }

  Future<void> checkEntitlement() async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final result = await _checkEntitlementUsecase.call();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (isPro) {
        state = state.copyWith(
          status: SubscriptionStatus.success,
          subscriptionData: SubscriptionEntity(
            currentOffering: state.subscriptionData?.currentOffering,
            isPremium: isPro,
          ),
        );
      },
    );
  }
}
