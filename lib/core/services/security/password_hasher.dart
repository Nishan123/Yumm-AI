import 'dart:convert';
import 'package:crypto/crypto.dart';

/// A utility class for securely hashing and verifying passwords.
class PasswordHasher {
  static const String _salt = 'yumm_ai_secure_salt_2024';
  static String hashPassword(String password) {
    final saltedPassword = '$_salt$password$_salt';
    final bytes = utf8.encode(saltedPassword);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Returns true if the password matches, false otherwise.
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    final hashedInput = hashPassword(plainPassword);
    return hashedInput == hashedPassword;
  }
}
