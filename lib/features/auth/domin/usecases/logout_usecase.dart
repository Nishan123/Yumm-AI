import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/storage/token_storage_service.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

final logoutUsercaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userSessionService = ref.watch(userSessionServiceProvider);
  final tokenService = ref.watch(tokenServiceProvider);
  return LogoutUsecase(
    authRepository: authRepository,
    userSessionService: userSessionService,
    tokenStorageService: tokenService,
  );
});

class LogoutUsecase implements UsecaseWithoutParms<bool> {
  final IAuthRepository _authRepository;
  final UserSessionService _userSessionService;
  final TokenStorageService _tokenStorageService;

  LogoutUsecase({
    required IAuthRepository authRepository,
    required UserSessionService userSessionService,
    required TokenStorageService tokenStorageService,
  }) : _authRepository = authRepository,
       _userSessionService = userSessionService,
       _tokenStorageService = tokenStorageService;

  @override
  Future<Either<Failure, bool>> call() async {
    // Clear the SharedPreferences session
    await _userSessionService.clearSession();
    // Clear the secure storage token
    await _tokenStorageService.deleteToken();
    // Clear the Hive storage
    return _authRepository.logOut();
  }
}
