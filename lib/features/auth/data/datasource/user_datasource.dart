import 'package:yumm_ai/features/auth/data/model/user_hive_model.dart';

abstract interface class IAuthDatasource {
  Future<bool> signWithEmailPassword(UserHiveModel userModel);
  Future<UserHiveModel?> loginWithEmailPassword(String email, String password);
  Future<UserHiveModel?> getCurrentUser();
  Future<bool> logOut();
}
