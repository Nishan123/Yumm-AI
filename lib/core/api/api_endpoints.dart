class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:5000/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // =============== Auth Endpoints ================
  static const String login = "/auth/login";
  static const String signup = "/auth/register";
  static const String logout = "/auth/logout";

  // ================ User Endpoints ===============
  static const String getAllUsers = "/getAllUsers";
  static String getUserById(String uid) => "/users/$uid";
}
