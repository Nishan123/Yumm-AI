import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';

class UserApiModel {
  final String? uid;
  final String email;
  final String? role;
  final String fullName;
  final String? profilePic;
  final List<String>? allergicTo;
  final String authProvider;
  final bool? isSubscribed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? password;
  UserApiModel({
    this.uid,
    required this.email,
    this.role,
    required this.fullName,
    this.profilePic,
    this.allergicTo,
    required this.authProvider,
    this.isSubscribed,
    this.createdAt,
    this.updatedAt,
    this.password,
  });

  // to json
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "role": role,
      "fullName": fullName,
      "profilePic": profilePic,
      "allergicTo": allergicTo,
      "authProvider": authProvider,
      "isSubscribed": isSubscribed,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "password": password,
      "confirmPassword": password,
    };
  }

  // from json
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return UserApiModel(
      uid: json["uid"] as String?,
      email: (json["email"] ?? "") as String,
      role: json["role"] as String?,
      fullName: (json["fullName"] ?? "") as String,
      profilePic: json["profilePic"] as String?,
      allergicTo: (json["allergicTo"] as List?)
          ?.map((e) => e.toString())
          .toList(),
      authProvider: (json["authProvider"] ?? "") as String,
      isSubscribed: json["isSubscribed"] as bool?,
      createdAt: parseDate(json["createdAt"]),
      updatedAt: parseDate(json["updatedAt"]),
    );
  }

  // to entity
   UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      role: role,
      fullName: fullName,
      profilePic: profilePic,
      allergicTo: allergicTo,
      authProvider: authProvider,
      isSubscribed: isSubscribed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // from entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      uid: entity.uid,
      email: entity.email,
      role: entity.role,
      fullName: entity.fullName,
      profilePic: entity.profilePic,
      allergicTo: entity.allergicTo,
      authProvider: entity.authProvider,
      isSubscribed: entity.isSubscribed,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      password: entity.password,
    );
  }
}
