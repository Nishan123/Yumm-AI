import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionEntity extends Equatable {
  final Offering? currentOffering;
  final bool isPremium;

  const SubscriptionEntity({this.currentOffering, this.isPremium = false});

  @override
  List<Object?> get props => [currentOffering, isPremium];
}
