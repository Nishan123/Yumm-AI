import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:yumm_ai/features/subscription/presentation/providers/subscription_provider.dart';

final checkEntitlementUsecaseProvider = Provider<CheckEntitlementUsecase>((
  ref,
) {
  return CheckEntitlementUsecase(
    repository: ref.watch(subscriptionRepositoryProvider),
  );
});

class CheckEntitlementUsecase implements UsecaseWithoutParms<bool> {
  final SubscriptionRepository repository;

  CheckEntitlementUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.checkEntitlement();
  }
}
