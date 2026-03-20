import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/check_entitlement_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/get_offerings_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/purchase_subscription_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/restore_purchases_usecase.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_package_entity.dart';
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

  Future<void> purchasePackage(SubscriptionPackageEntity package) async {
    state = state.copyWith(status: SubscriptionStatus.processing);
    final result = await _purchaseSubscriptionUsecase.call(package);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: failure.errorMessage,
        );
      },
      (entitlementEntity) {
        state = state.copyWith(
          status: SubscriptionStatus.success,
          subscriptionData: entitlementEntity,
        );
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
      (entitlementEntity) {
        state = state.copyWith(
          status: SubscriptionStatus.success,
          subscriptionData: entitlementEntity,
        );
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
      (entitlementEntity) {
        state = state.copyWith(
          status: SubscriptionStatus.success,
          subscriptionData: entitlementEntity,
        );
      },
    );
  }
}
