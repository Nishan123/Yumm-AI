import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionRemoteDatasource {
  Future<Offerings> fetchOfferings();
  Future<CustomerInfo> purchasePackage(Package package);
  Future<CustomerInfo> restorePurchases();
  Future<CustomerInfo> getCustomerInfo();
}

class SubscriptionRemoteDatasourceImpl implements SubscriptionRemoteDatasource {
  @override
  Future<Offerings> fetchOfferings() async {
    if (!await Purchases.isConfigured) throw Exception('RevenueCat is not configured');
    return await Purchases.getOfferings();
  }

  @override
  Future<CustomerInfo> purchasePackage(Package package) async {
    if (!await Purchases.isConfigured) throw Exception('RevenueCat is not configured');
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  @override
  Future<CustomerInfo> restorePurchases() async {
    if (!await Purchases.isConfigured) throw Exception('RevenueCat is not configured');
    return await Purchases.restorePurchases();
  }

  @override
  Future<CustomerInfo> getCustomerInfo() async {
    if (!await Purchases.isConfigured) throw Exception('RevenueCat is not configured');
    return await Purchases.getCustomerInfo();
  }
}
