import 'package:equatable/equatable.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';

enum ProfileStates { initial, loading, loaded, error }

class ProfileScreenState extends Equatable {
  final ProfileStates profileState;
  final UserEntity? userData;
  final String? errorMsg;
  const ProfileScreenState({
    this.profileState = ProfileStates.initial,
    this.userData,
    this.errorMsg,
  });

  ProfileScreenState copyWith({
    ProfileStates? profileState,
    UserEntity? userData,
    String? errorMsg
  }) {
    return ProfileScreenState(
      profileState: profileState ?? this.profileState,
      userData: userData ?? this.userData,
      errorMsg: errorMsg?? this.errorMsg
    );
  }

  @override
  List<Object?> get props => [profileState, userData, errorMsg];
}
