import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_entity.dart';

enum SubscriptionStatus { initial, loading, processing, success, error }

class SubscriptionState extends Equatable {
  final SubscriptionStatus status;
  final SubscriptionEntity? subscriptionData;
  final String? errorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.subscriptionData,
    this.errorMessage,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    SubscriptionEntity? subscriptionData,
    String? errorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscriptionData: subscriptionData ?? this.subscriptionData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, subscriptionData, errorMessage];
}
