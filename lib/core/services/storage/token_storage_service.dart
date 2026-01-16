import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final tokenServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

class TokenStorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> getToken() async {
    return storage.read(key: "token");
  }

  Future<void> deleteToken() async {
    await storage.delete(key: "token");
  }
}
