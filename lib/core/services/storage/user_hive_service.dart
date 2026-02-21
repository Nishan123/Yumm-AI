import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yumm_ai/core/constants/hive_table_contansts.dart';
import 'package:yumm_ai/features/auth/data/model/user_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // Tracks Hive initialization across all instances.
  static bool _initialized = false;

  // init database
  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/${HiveTableConstants.dbName}";
    Hive.init(path);
    _registerAdapter();
    _initialized = true;
  }

  // register adapter
  void _registerAdapter() {
    // Register the adapter once to avoid Hive type errors during auth flows.
    if (!Hive.isAdapterRegistered(HiveTableConstants.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  // open box
  Future<void> openBox() async {
    if (!_initialized) {
      await init();
    } else {
      _registerAdapter();
    }

    if (Hive.isBoxOpen(HiveTableConstants.userTable)) return;
    await Hive.openBox<UserHiveModel>(HiveTableConstants.userTable);
  }

  // close box
  Future<void> closeBox() async {
    await Hive.close();
  }

  // ===================USER QUERIES=====================

  Box<UserHiveModel> get _userBox =>
      Hive.box<UserHiveModel>(HiveTableConstants.userTable);

  UserHiveModel _cloneUser(UserHiveModel user) {
    // Create a fresh instance so Hive does not treat it as the same object stored under a different key.
    return UserHiveModel(
      uid: user.uid,
      email: user.email,
      role: user.role,
      fullName: user.fullName,
      profilePic: user.profilePic,
      allergicTo: user.allergicTo,
      authProvider: user.authProvider,
      password: user.password,
      isSubscribed: user.isSubscribed,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  Future<void> setCurrentUser(UserHiveModel user) async {
    final cloned = _cloneUser(user);
    await _userBox.put(HiveTableConstants.currentUserKey, cloned);
  }

  Future<UserHiveModel?> getCurrentUser() async {
    return _userBox.get(HiveTableConstants.currentUserKey);
  }

  Future<void> clearCurrentUser() async {
    await _userBox.delete(HiveTableConstants.currentUserKey);
  }

  Future<UserHiveModel> createUser(UserHiveModel user) async {
    await _userBox.put(user.uid, user);
    return user;
  }

  Future<UserHiveModel> updateUser(UserHiveModel user) async {
    await _userBox.put(user.uid, user);
    return user;
  }

  Future<bool> deleteUser(String uid) async {
    await _userBox.delete(uid);
    return true;
  }

  Future<UserHiveModel?> getSingleUser(String uid) async {
    final user = _userBox.get(uid);
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    final users = _userBox.toMap();
    users.remove(HiveTableConstants.currentUserKey);
    return users.values.toList();
  }
}
