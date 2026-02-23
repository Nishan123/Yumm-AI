import 'package:dartz/dartz.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, SubscriptionEntity>> fetchOfferings();
  Future<Either<Failure, bool>> checkEntitlement();
  Future<Either<Failure, bool>> purchasePackage(Package package);
  Future<Either<Failure, bool>> restorePurchases();
}
