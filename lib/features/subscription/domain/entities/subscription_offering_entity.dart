import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/subscription/domain/entities/subscription_package_entity.dart';

class SubscriptionOfferingEntity extends Equatable {
  final String identifier;
  final String serverDescription;
  final List<SubscriptionPackageEntity> availablePackages;
  final SubscriptionPackageEntity? lifetime;
  final SubscriptionPackageEntity? annual;
  final SubscriptionPackageEntity? sixMonth;
  final SubscriptionPackageEntity? threeMonth;
  final SubscriptionPackageEntity? twoMonth;
  final SubscriptionPackageEntity? monthly;
  final SubscriptionPackageEntity? weekly;

  const SubscriptionOfferingEntity({
    required this.identifier,
    required this.serverDescription,
    required this.availablePackages,
    this.lifetime,
    this.annual,
    this.sixMonth,
    this.threeMonth,
    this.twoMonth,
    this.monthly,
    this.weekly,
  });

  @override
  List<Object?> get props => [
        identifier,
        serverDescription,
        availablePackages,
        lifetime,
        annual,
        sixMonth,
        threeMonth,
        twoMonth,
        monthly,
        weekly,
      ];
}
