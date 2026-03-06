import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_from_server_usecase.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/delete_user_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/update_profile_pic_usecase.dart';
import 'package:yumm_ai/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:yumm_ai/features/profile/presentation/state/profile_screen_state.dart';
import 'package:yumm_ai/features/profile/presentation/view_model/profile_view_model.dart';

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUpdateProfilePicUsecase extends Mock
    implements UpdateProfilePicUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockDeleteUserUsecase extends Mock implements DeleteUserUsecase {}

class MockGetCurrentUserFromServerUsecase extends Mock
    implements GetCurrentUserFromServerUsecase {}

class FakeUserEntity extends Fake implements UserEntity {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProviderContainer container;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  // Others omitted for simplicity in this file

  setUp(() {
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();

    final mockSharedPreferences = MockSharedPreferences();

    container = ProviderContainer(
      overrides: [
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('getCurrentUser success updates state to loaded', () async {
    when(
      () => mockGetCurrentUserUsecase.call(),
    ).thenAnswer((_) async => Right(FakeUserEntity()));

    final viewModel = container.read(profileViewModelProvider.notifier);
    await viewModel.getCurrentUser();

    final state = container.read(profileViewModelProvider);
    expect(state.profileState, ProfileStates.loaded);
  });
}
