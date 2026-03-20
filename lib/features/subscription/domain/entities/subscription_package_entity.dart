import 'package:equatable/equatable.dart';

enum PackageType {
  unknown,
  custom,
  lifetime,
  annual,
  sixMonth,
  threeMonth,
  twoMonth,
  monthly,
  weekly,
}

class SubscriptionPackageEntity extends Equatable {
  final String identifier;
  final PackageType packageType;
  final String priceString;
  final double price;
  final String title;
  final String description;

  const SubscriptionPackageEntity({
    required this.identifier,
    required this.packageType,
    required this.priceString,
    required this.price,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [
        identifier,
        packageType,
        priceString,
        price,
        title,
        description,
      ];
}
