import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:yumm_ai/core/constants/hive_table_contansts.dart';
import 'package:yumm_ai/core/services/security/password_hasher.dart';
import 'package:yumm_ai/core/services/storage/user_hive_service.dart';
import 'package:yumm_ai/features/auth/data/datasource/user_datasource.dart';
import 'package:yumm_ai/features/auth/data/model/user_hive_model.dart';

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  Future<void> _ensureBoxOpen() async {
    if (!Hive.isBoxOpen(HiveTableConstants.userTable)) {
      await _hiveService.openBox();
    }
  }

  @override
  Future<UserHiveModel?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    await _ensureBoxOpen();
    final users = await _hiveService.getAllUsers();
    final targetEmail = email.trim().toLowerCase();
    UserHiveModel? user;
    for (final u in users) {
      if (u.email.toLowerCase() == targetEmail) {
        user = u;
        break;
      }
    }

    if (user == null) return null;

    // Verify password using secure hash comparison
    final storedHash = user.password ?? "";
    final passwordMatches = PasswordHasher.verifyPassword(
      password.trim(),
      storedHash,
    );
    if (!passwordMatches) return null;

    await _hiveService.setCurrentUser(user);
    return user;
  }

  @override
  Future<bool> signWithEmailPassword(UserHiveModel userEntity) async {
    try {
      await _ensureBoxOpen();
      final users = await _hiveService.getAllUsers();
      final alreadyExists = users.any(
        (user) => user.email.toLowerCase() == userEntity.email.toLowerCase(),
      );

      if (alreadyExists) return false;

      // Hash the password before storing
      final hashedPassword = PasswordHasher.hashPassword(
        userEntity.password ?? "",
      );
      final userWithHashedPassword = UserHiveModel(
        uid: userEntity.uid,
        email: userEntity.email,
        role: userEntity.role,
        fullName: userEntity.fullName,
        profilePic: userEntity.profilePic,
        allergicTo: userEntity.allergicTo,
        authProvider: userEntity.authProvider,
        password: hashedPassword,
        isSubscribed: userEntity.isSubscribed,
        createdAt: userEntity.createdAt,
        updatedAt: userEntity.updatedAt,
      );

      await _hiveService.createUser(userWithHashedPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserHiveModel?> getCurrentUser() async {
    try {
      await _ensureBoxOpen();
      return _hiveService.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      await _ensureBoxOpen();
      await _hiveService.clearCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }
}
