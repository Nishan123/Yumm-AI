import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as rc;
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/subscription/data/datasource/remote/subscription_remote_datasource.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_offering_entity.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_package_entity.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';

const String kProEntitlementId = 'Yumm Ai Pro';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDatasource remoteDatasource;

  rc.Offerings? _cachedOfferings;

  SubscriptionRepositoryImpl({required this.remoteDatasource});

  SubscriptionEntity _mapCustomerInfoToEntity(rc.CustomerInfo customerInfo, {SubscriptionOfferingEntity? currentOffering}) {
    final activeEntitlements = customerInfo.entitlements.active;
    final isPro = activeEntitlements.containsKey(kProEntitlementId);
    final entitlement = activeEntitlements[kProEntitlementId];

    DateTime? purchaseDate;
    DateTime? expDate;

    if (entitlement != null) {
      final originalStr = entitlement.originalPurchaseDate;
      if (originalStr.isNotEmpty) {
        purchaseDate = DateTime.tryParse(originalStr);
      }
      final expStr = entitlement.expirationDate;
      if (expStr != null && expStr.isNotEmpty) {
        expDate = DateTime.tryParse(expStr);
      }
    }

    return SubscriptionEntity(
      currentOffering: currentOffering,
      isPremium: isPro,
      purchaseDate: purchaseDate,
      expirationDate: expDate,
    );
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> checkEntitlement() async {
    try {
      final customerInfo = await remoteDatasource.getCustomerInfo();
      SubscriptionOfferingEntity? currentOfferingEntity;
      if (_cachedOfferings?.current != null) {
        currentOfferingEntity = _mapOffering(_cachedOfferings!.current!);
      }
      return Right(_mapCustomerInfoToEntity(customerInfo, currentOffering: currentOfferingEntity));
    } on PlatformException catch (e) {
      return Left(GeneralFailure(e.message ?? "Failed to check entitlement"));
    } catch (e) {
      return Left(GeneralFailure("Error: $e"));
    }
  }

  PackageType _mapPackageType(rc.PackageType type) {
    switch (type) {
      case rc.PackageType.unknown:
        return PackageType.unknown;
      case rc.PackageType.custom:
        return PackageType.custom;
      case rc.PackageType.lifetime:
        return PackageType.lifetime;
      case rc.PackageType.annual:
        return PackageType.annual;
      case rc.PackageType.sixMonth:
        return PackageType.sixMonth;
      case rc.PackageType.threeMonth:
        return PackageType.threeMonth;
      case rc.PackageType.twoMonth:
        return PackageType.twoMonth;
      case rc.PackageType.monthly:
        return PackageType.monthly;
      case rc.PackageType.weekly:
        return PackageType.weekly;
    }
  }

  SubscriptionPackageEntity _mapPackage(rc.Package package) {
    return SubscriptionPackageEntity(
      identifier: package.identifier,
      packageType: _mapPackageType(package.packageType),
      priceString: package.storeProduct.priceString,
      price: package.storeProduct.price,
      title: package.storeProduct.title,
      description: package.storeProduct.description,
    );
  }

  SubscriptionOfferingEntity _mapOffering(rc.Offering offering) {
    return SubscriptionOfferingEntity(
      identifier: offering.identifier,
      serverDescription: offering.serverDescription,
      availablePackages:
          offering.availablePackages.map((p) => _mapPackage(p)).toList(),
      lifetime: offering.lifetime != null ? _mapPackage(offering.lifetime!) : null,
      annual: offering.annual != null ? _mapPackage(offering.annual!) : null,
      sixMonth: offering.sixMonth != null ? _mapPackage(offering.sixMonth!) : null,
      threeMonth: offering.threeMonth != null ? _mapPackage(offering.threeMonth!) : null,
      twoMonth: offering.twoMonth != null ? _mapPackage(offering.twoMonth!) : null,
      monthly: offering.monthly != null ? _mapPackage(offering.monthly!) : null,
      weekly: offering.weekly != null ? _mapPackage(offering.weekly!) : null,
    );
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> fetchOfferings() async {
    try {
      final offerings = await remoteDatasource.fetchOfferings();
      _cachedOfferings = offerings;
      final customerInfo = await remoteDatasource.getCustomerInfo();

      SubscriptionOfferingEntity? currentOfferingEntity;
      if (offerings.current != null) {
        currentOfferingEntity = _mapOffering(offerings.current!);
      }

      return Right(_mapCustomerInfoToEntity(customerInfo, currentOffering: currentOfferingEntity));
    } on PlatformException catch (e) {
      return Left(GeneralFailure(e.message ?? "Failed to fetch offerings"));
    } catch (e) {
      return Left(GeneralFailure("Error: $e"));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> purchasePackage(
      SubscriptionPackageEntity packageEntity) async {
    try {
      if (_cachedOfferings == null || _cachedOfferings!.current == null) {
        return Left(GeneralFailure("Offerings not loaded"));
      }

      final rcPackage = _cachedOfferings!.current!.availablePackages.firstWhere(
        (p) => p.identifier == packageEntity.identifier,
        orElse: () => throw Exception("Package not found in current offering"),
      );

      final customerInfo = await remoteDatasource.purchasePackage(rcPackage);
      SubscriptionOfferingEntity? currentOfferingEntity;
      if (_cachedOfferings?.current != null) {
        currentOfferingEntity = _mapOffering(_cachedOfferings!.current!);
      }
      
      return Right(_mapCustomerInfoToEntity(customerInfo, currentOffering: currentOfferingEntity));
    } on PlatformException catch (e) {
      final errorCode = rc.PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == rc.PurchasesErrorCode.purchaseCancelledError) {
        return Left(GeneralFailure('Purchase cancelled by user'));
      }
      return Left(GeneralFailure(e.message ?? "Failed to complete purchase"));
    } catch (e) {
      return Left(GeneralFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> restorePurchases() async {
    try {
      final customerInfo = await remoteDatasource.restorePurchases();
      SubscriptionOfferingEntity? currentOfferingEntity;
      if (_cachedOfferings?.current != null) {
        currentOfferingEntity = _mapOffering(_cachedOfferings!.current!);
      }
      return Right(_mapCustomerInfoToEntity(customerInfo, currentOffering: currentOfferingEntity));
    } on PlatformException catch (e) {
      return Left(GeneralFailure(e.message ?? "Failed to restore purchases"));
    } catch (e) {
      return Left(GeneralFailure("Error: $e"));
    }
  }
}
