import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:yumm_ai/features/subscription/presentation/providers/subscription_provider.dart';

final getOfferingsUsecaseProvider = Provider<GetOfferingsUsecase>((ref) {
  return GetOfferingsUsecase(
    repository: ref.watch(subscriptionRepositoryProvider),
  );
});

class GetOfferingsUsecase implements UsecaseWithoutParms<SubscriptionEntity> {
  final SubscriptionRepository repository;

  GetOfferingsUsecase({required this.repository});
  @override
  Future<Either<Failure, SubscriptionEntity>> call() async {
    return await repository.fetchOfferings();
  }
}
