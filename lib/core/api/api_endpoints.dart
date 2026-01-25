class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://localhost:5000/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // =============== Auth Endpoints ================
  static const String login = "/auth/login";
  static const String signup = "/auth/register";
  static const String logout = "/auth/logout";
  static const String googleSignIn = "/auth/google";

  // ================ User Endpoints ===============
  static const String getAllUsers = "/getAllUsers";
  static String getUserById(String uid) => "/users/$uid";
  static String getCurrentUser(String uid) => "/me/$uid";
  static String updateProfilePic(String uid) => "/users/$uid/profile-pic";

  // ================ Recipe Endpoints ================
  static const String saveRecipe = "/saveRecipe";
  static String uploadRecipeImages(String recipeId) =>
      "/recipe/$recipeId/images";
}
