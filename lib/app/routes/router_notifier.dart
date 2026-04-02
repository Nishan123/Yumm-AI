import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/presentation/state/auth_state.dart';
import 'package:yumm_ai/features/auth/presentation/view_model/auth_view_model.dart';

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _splashTimerComplete = false;

  RouterNotifier(this._ref) {
    // Mimic the splash screen 2.5 second delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      _splashTimerComplete = true;
      notifyListeners();
    });

    _ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (previous?.status != next.status) {
        if (kDebugMode) {
          print(
            'Router: Auth state changed from ${previous?.status} to ${next.status}',
          );
        }
        notifyListeners();
      }
    });
  }

  bool get isReady {
    return _splashTimerComplete;
  }

  bool get isAuthenticated {
    // If the auth status is explicitly authenticated, they are logged in.
    // However, since the app initializes synchronously via SharedPreferences,
    // we also check the UserSessionService to cover cold starts before AuthViewModel fires an update.
    final authState = _ref.read(authViewModelProvider);
    final userSessionService = _ref.read(userSessionServiceProvider);

    if (authState.status == AuthStatus.authenticated) {
      return true;
    }

    return userSessionService.isLoggedIn();
  }

  AuthStatus get authStatus {
    return _ref.read(authViewModelProvider).status;
  }
}
