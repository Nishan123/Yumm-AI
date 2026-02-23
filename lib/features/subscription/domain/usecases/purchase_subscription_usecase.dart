import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:yumm_ai/features/subscription/presentation/providers/subscription_provider.dart';

final purchaseSubscriptionUsecaseProvider =
    Provider<PurchaseSubscriptionUsecase>((ref) {
      return PurchaseSubscriptionUsecase(
        repository: ref.watch(subscriptionRepositoryProvider),
      );
    });

class PurchaseSubscriptionUsecase implements UsecaseWithParms<bool, Package> {
  final SubscriptionRepository repository;

  PurchaseSubscriptionUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(Package params) async {
    return await repository.purchasePackage(params);
  }
}
