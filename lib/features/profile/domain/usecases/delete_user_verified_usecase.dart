import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/profile/data/repositories/profile_repository.dart';
import 'package:yumm_ai/features/profile/domain/repositories/profile_repository.dart';

/// Parameters for deleting user with password verification
class DeleteUserWithPasswordParams {
  final String uid;
  final String password;
  final String? reason;

  DeleteUserWithPasswordParams({
    required this.uid,
    required this.password,
    this.reason,
  });
}

/// Usecase for deleting user with password verification (emailPassword auth)
final deleteUserWithPasswordUsecaseProvider = Provider((ref) {
  return DeleteUserWithPasswordUsecase(
    iprofileRepository: ref.watch(profileRepositoryProvider),
  );
});

class DeleteUserWithPasswordUsecase
    implements UsecaseWithParms<bool, DeleteUserWithPasswordParams> {
  final IProfileRepository _iProfileRepository;

  DeleteUserWithPasswordUsecase({
    required IProfileRepository iprofileRepository,
  }) : _iProfileRepository = iprofileRepository;

  @override
  Future<Either<Failure, bool>> call(
    DeleteUserWithPasswordParams params,
  ) async {
    return await _iProfileRepository.deleteUserWithPassword(
      params.uid,
      params.password,
      params.reason,
    );
  }
}

/// Parameters for deleting user with Google verification
class DeleteUserWithGoogleParams {
  final String uid;
  final String? reason;

  DeleteUserWithGoogleParams({required this.uid, this.reason});
}

/// Usecase for deleting user with Google token verification (Google auth)
final deleteUserWithGoogleUsecaseProvider = Provider((ref) {
  return DeleteUserWithGoogleUsecase(
    iprofileRepository: ref.watch(profileRepositoryProvider),
  );
});

class DeleteUserWithGoogleUsecase
    implements UsecaseWithParms<bool, DeleteUserWithGoogleParams> {
  final IProfileRepository _iProfileRepository;

  DeleteUserWithGoogleUsecase({required IProfileRepository iprofileRepository})
    : _iProfileRepository = iprofileRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteUserWithGoogleParams params) async {
    try {
      // Initialize GoogleSignIn with client ID from environment
      final clientId = dotenv.env['GOOGLE_CLIENT_ID'];
      final googleSignIn = GoogleSignIn(
        clientId: clientId,
        scopes: ['email', 'profile'],
      );

      // Sign out first to clear any cached account and force account picker
      await googleSignIn.signOut();

      // Trigger the Google Sign-In flow for re-authentication
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return Left(ApiFailure(message: "Google verification was cancelled"));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null) {
        return Left(ApiFailure(message: "Failed to get Google ID token"));
      }

      // Call the repository method with the idToken
      return await _iProfileRepository.deleteUserWithGoogle(
        params.uid,
        idToken,
        params.reason,
      );
    } catch (e) {
      return Left(
        ApiFailure(message: "Google verification failed: ${e.toString()}"),
      );
    }
  }
}
