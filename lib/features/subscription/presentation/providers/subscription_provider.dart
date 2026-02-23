import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/features/subscription/data/datasource/remote/subscription_remote_datasource.dart';
import 'package:yumm_ai/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';

final subscriptionRemoteDatasourceProvider =
    Provider<SubscriptionRemoteDatasource>((ref) {
      return SubscriptionRemoteDatasourceImpl();
    });

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(
    remoteDatasource: ref.watch(subscriptionRemoteDatasourceProvider),
  );
});
