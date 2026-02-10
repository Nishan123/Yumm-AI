import 'package:yumm_ai/features/auth/data/model/user_api_model.dart';
import 'package:yumm_ai/features/auth/data/model/user_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<bool> signWithEmailPassword(UserHiveModel userModel);
  Future<UserHiveModel?> loginWithEmailPassword(String email, String password);
  Future<UserHiveModel?> getCurrentUser();
  Future<bool> logOut();
}

abstract interface class IAuthRemoteDatasource {
  Future<UserApiModel?> signWithEmailPassword(UserApiModel userModel);
  Future<UserApiModel?> loginWithEmailPassword(String email, String password);
  Future<UserApiModel?> signInWithGoogle(String idToken);
  Future<UserApiModel?> getCurrentUser();
  Future<bool> logOut();
  Future<void> registerForPush(String uid);
}
