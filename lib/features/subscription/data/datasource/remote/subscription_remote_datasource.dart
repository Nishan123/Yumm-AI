import 'package:flutter/services.dart';
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
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  @override
  Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchaseStoreProduct(package.storeProduct);
      return result.customerInfo;
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  @override
  Future<CustomerInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  @override
  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } on PlatformException catch (_) {
      rethrow;
    }
  }
}
