import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/subscription/data/datasource/remote/subscription_remote_datasource.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDatasource remoteDatasource;

  SubscriptionRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, bool>> checkEntitlement() async {
    try {
      final customerInfo = await remoteDatasource.getCustomerInfo();
      final isPro = customerInfo.entitlements.active.containsKey('Yumm Ai Pro');
      return Right(isPro);
    } on PlatformException catch (e) {
      return Left(GeneralFailure(e.message ?? "Failed to check entitlement"));
    } catch (e) {
      return Left(GeneralFailure("An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> fetchOfferings() async {
    try {
      final offerings = await remoteDatasource.fetchOfferings();
      final customerInfo = await remoteDatasource.getCustomerInfo();

      final isPro = customerInfo.entitlements.active.containsKey('Yumm Ai Pro');

      return Right(
        SubscriptionEntity(
          currentOffering: offerings.current,
          isPremium: isPro,
        ),
      );
    } on PlatformException catch (e) {
      return Left(GeneralFailure(e.message ?? "Failed to fetch offerings"));
    } catch (e) {
      return Left(GeneralFailure("An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> purchasePackage(Package package) async {
    try {
      final customerInfo = await remoteDatasource.purchasePackage(package);
      final isPro = customerInfo.entitlements.active.containsKey('Yumm Ai Pro');
      return Right(isPro);
    } on PlatformException catch (e) {
      return Left(GeneralFailure(e.message ?? "Failed to complete purchase"));
    } catch (e) {
      return Left(GeneralFailure("An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, bool>> restorePurchases() async {
    try {
      final customerInfo = await remoteDatasource.restorePurchases();
      final isPro = customerInfo.entitlements.active.containsKey('Yumm Ai Pro');
      return Right(isPro);
    } on PlatformException catch (e) {
      return Left(GeneralFailure(e.message ?? "Failed to restore purchases"));
    } catch (e) {
      return Left(GeneralFailure("An unexpected error occurred"));
    }
  }
}
