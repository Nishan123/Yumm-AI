import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String email;
  final String? role;
  final String fullName;
  final String? profilePic;
  final List<String>? allergicTo;
  final String authProvider;
  final String? password;
  final bool? isSubscribedUser;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    this.uid,
    required this.email,
    this.role,
    required this.fullName,
    this.profilePic,
    this.allergicTo,
    required this.authProvider,
    this.password,
    this.isSubscribedUser,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      uid,
      email,
      role,
      fullName,
      profilePic,
      allergicTo,
      authProvider,
      password,
      isSubscribedUser,
      createdAt,
      updatedAt,
    ];
  }
}
