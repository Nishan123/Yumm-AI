import 'package:equatable/equatable.dart';

import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
enum AuthStatus { initial, authenticated, unauthenticated, loading, error, registered }
class AuthState extends Equatable {
final AuthStatus status;
final UserEntity ? user;
final String? errorMessage;

const AuthState({
  this.status = AuthStatus.initial,
  this.user,
  this.errorMessage,
});

// copyWith method
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
