import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';

enum ProfileStates { initial, loading, loaded, error, success }

class ProfileScreenState extends Equatable {
  final ProfileStates profileState;
  final UserEntity? userData;
  final String? errorMsg;
  final String? message;
  const ProfileScreenState({
    this.profileState = ProfileStates.initial,
    this.userData,
    this.errorMsg,
    this.message
  });

  ProfileScreenState copyWith({
    ProfileStates? profileState,
    UserEntity? userData,
    String? errorMsg,
    String?message
  }) {
    return ProfileScreenState(
      profileState: profileState ?? this.profileState,
      userData: userData ?? this.userData,
      errorMsg: errorMsg ?? this.errorMsg,
      message: message?? this.message
    );
  }

  @override
  List<Object?> get props => [profileState, userData, errorMsg,message];
}
