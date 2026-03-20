import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_package_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, SubscriptionEntity>> fetchOfferings();
  Future<Either<Failure, SubscriptionEntity>> checkEntitlement();
  Future<Either<Failure, SubscriptionEntity>> purchasePackage(SubscriptionPackageEntity package);
  Future<Either<Failure, SubscriptionEntity>> restorePurchases();
}
