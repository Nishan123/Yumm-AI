import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final appleSigninUsecaseProvider = Provider((ref) {
  return AppleSigninUsecase(authRepository: ref.read(authRepositoryProvider));
});

class AppleSigninUsecase implements UsecaseWithoutParms {
  final IAuthRepository _authRepository;
  AppleSigninUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, dynamic>> call() async {
    try {
      debugPrint("📱 Apple Sign-In: Requesting credentials...");
      final crediential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      debugPrint("📱 Apple Sign-In: Got credential response");
      debugPrint(
        "📱 Apple Sign-In: identityToken is ${crediential.identityToken != null ? 'present' : 'NULL'}",
      );
      debugPrint(
        "📱 Apple Sign-In: email=${crediential.email}, givenName=${crediential.givenName}",
      );

      final idToken = crediential.identityToken;
      if (idToken == null) {
        return Left(ApiFailure(message: "Failed to get Apple ID token"));
      }
      String? fullName;
      if (crediential.givenName != null || crediential.familyName != null) {
        fullName = [
          crediential.givenName,
          crediential.familyName,
        ].where((e) => e != null && e.isNotEmpty).join(" ");
        if (fullName.isEmpty) fullName = null;
      }
      debugPrint("📱 Apple Sign-In: Sending to server...");
      final result = await _authRepository.signInWithApple(
        idToken,
        fullName: fullName,
      );
      debugPrint("📱 Apple Sign-In: Server responded");
      return result;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint(
        "📱 Apple Sign-In: AuthorizationException - code=${e.code}, message=${e.message}",
      );
      if (e.code == AuthorizationErrorCode.canceled) {
        return Left(ApiFailure(message: "Apple Sign-In cancelled"));
      }
      return Left(ApiFailure(message: "Apple Sign-In failed: ${e.message}"));
    } catch (e) {
      debugPrint("📱 Apple Sign-In: Unexpected error - $e");
      return Left(ApiFailure(message: "Apple Sign-In failed: $e"));
    }
  }
}
