import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:yumm_ai/core/constants/hive_table_contansts.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.userTypeId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String? uid;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String? role;
  @HiveField(3)
  final String fullName;
  @HiveField(4)
  final String? profilePic;
  @HiveField(5)
  final List<String>? allergicTo;
  @HiveField(6)
  final String authProvider;
  @HiveField(7)
  final bool? isSubscribed;
  @HiveField(8)
  final DateTime? createdAt;
  @HiveField(9)
  final DateTime? updatedAt;
  @HiveField(10)
  final String? password;

  UserHiveModel({
    String? uid,
    required this.email,
    String? role,
    required this.fullName,
    String? profilePic,
    List<String>? allergicTo,
    required this.authProvider,
    String? password,
    bool? isSubscribed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : uid = uid ?? Uuid().v4(),
       role = role ?? "user",
       profilePic =
           profilePic ??
           "https://assets.stickpng.com/images/597a2ab7588e2808c03fdec9.png",
       allergicTo = allergicTo ?? [],
       password = password ?? "",
       isSubscribed = isSubscribed ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // to entity method
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      role: role,
      fullName: fullName,
      allergicTo: allergicTo,
      profilePic: profilePic,
      isSubscribedUser: isSubscribed,
      authProvider: authProvider,
      password: password,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      email: entity.email,
      fullName: entity.fullName,
      authProvider: entity.authProvider,
      password: entity.password,
    );
  }
}
