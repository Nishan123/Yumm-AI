import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:yumm_ai/features/subscription/presentation/providers/subscription_provider.dart';

final restorePurchasesUsecaseProvider = Provider<RestorePurchasesUsecase>((
  ref,
) {
  return RestorePurchasesUsecase(
    repository: ref.watch(subscriptionRepositoryProvider),
  );
});

class RestorePurchasesUsecase implements UsecaseWithoutParms<bool> {
  final SubscriptionRepository repository;

  RestorePurchasesUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.restorePurchases();
  }
}
