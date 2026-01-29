import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/providers/current_user_provider.dart';
import 'package:yumm_ai/core/providers/user_selectors.dart';
import 'package:yumm_ai/features/chef/presentation/view_model/pantry_chef_view_model.dart';
import 'package:yumm_ai/features/cookbook/presentation/view_model/cookbook_view_model.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_provider.dart';
import 'package:yumm_ai/features/cooking/presentation/providers/recipe_state_provider.dart';
import 'package:yumm_ai/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:yumm_ai/features/profile/presentation/widgets/profile_card.dart';

/// Provider for the app state reset service.
final appStateResetServiceProvider = Provider<AppStateResetService>((ref) {
  return AppStateResetService(ref);
});

/// Service responsible for resetting all app state on logout.
/// This ensures that no user data persists between different user sessions.
class AppStateResetService {
  final Ref _ref;

  AppStateResetService(this._ref);

  /// Resets all user-related state providers.
  /// Call this method during logout to clear all in-memory cached data.
  void resetAllState() {
    // Reset user-related providers
    _ref.invalidate(currentUserProvider);
    _ref.invalidate(userProfilePicProvider);
    _ref.invalidate(userUidProvider);
    _ref.invalidate(userEmailProvider);
    _ref.invalidate(userNameProvider);
    _ref.invalidate(userRoleProvider);
    _ref.invalidate(userIsSubscribedProvider);
    _ref.invalidate(userAllergiesProvider);
    _ref.invalidate(userAuthProviderProvider);
    _ref.invalidate(isUserLoggedInProvider);
    _ref.invalidate(userProfileCardDataProvider);
    _ref.invalidate(userBasicInfoProvider);
    _ref.invalidate(userAvatarDataProvider);

    // Reset the cookbook state
    _ref.read(cookbookViewModelProvider.notifier).reset();

    // Reset the profile view model
    _ref.invalidate(profileViewModelProvider);

    // Reset profile pic cache key
    _ref.invalidate(profilePicCacheKeyProvider);

    // Reset pantry chef state
    _ref.invalidate(pantryChefViewModelProvider);

    // Reset recipe providers
    _ref.invalidate(allRecipesProvider);
    _ref.invalidate(publicRecipesProvider);

    // Reset recipe state cache (owner's recipe checkbox states)
    _ref.read(recipeStateCacheProvider.notifier).reset();
  }
}
