import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final googleSignInUsecaseProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GoogleSigninUsecase(authRepository: authRepository);
});

class GoogleSigninUsecase implements UsecaseWithoutParms {
  final IAuthRepository _authRepository;
  GoogleSigninUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, dynamic>> call() async {
    try {
      // Initialize GoogleSignIn with client ID from environment
      final clientId = dotenv.env['GOOGLE_CLIENT_ID'];
      final googleSignIn = GoogleSignIn(
        clientId: clientId,
        scopes: ['email', 'profile'],
      );

      // Sign out first to clear any cached account and force account picker
      await googleSignIn.signOut();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return Left(ApiFailure(message: "Google Sign-In was cancelled"));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null) {
        return Left(ApiFailure(message: "Failed to get Google ID token"));
      }

      // Call the repository method with the idToken
      return await _authRepository.signInWithGoogle(idToken);
    } catch (e) {
      return Left(
        ApiFailure(message: "Google Sign-In failed: ${e.toString()}"),
      );
    }
  }
}
