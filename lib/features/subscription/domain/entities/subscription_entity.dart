import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_offering_entity.dart';

class SubscriptionEntity extends Equatable {
  final SubscriptionOfferingEntity? currentOffering;
  final bool isPremium;
  final DateTime? purchaseDate;
  final DateTime? expirationDate;

  const SubscriptionEntity({
    this.currentOffering,
    this.isPremium = false,
    this.purchaseDate,
    this.expirationDate,
  });

  SubscriptionEntity copyWith({
    SubscriptionOfferingEntity? currentOffering,
    bool? isPremium,
    DateTime? purchaseDate,
    DateTime? expirationDate,
  }) {
    return SubscriptionEntity(
      currentOffering: currentOffering ?? this.currentOffering,
      isPremium: isPremium ?? this.isPremium,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  List<Object?> get props => [
        currentOffering,
        isPremium,
        purchaseDate,
        expirationDate,
      ];
}
