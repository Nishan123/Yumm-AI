import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/core/services/storage/token_storage_service.dart';
import 'package:yumm_ai/core/services/storage/user_session_service.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockTokenStorageService extends Mock implements TokenStorageService {}

void main() {
  late LogoutUsecase logoutUsecase;
  late MockAuthRepository mockAuthRepository;
  late MockUserSessionService mockUserSessionService;
  late MockTokenStorageService mockTokenStorageService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserSessionService = MockUserSessionService();
    mockTokenStorageService = MockTokenStorageService();
    logoutUsecase = LogoutUsecase(
      authRepository: mockAuthRepository,
      userSessionService: mockUserSessionService,
      tokenStorageService: mockTokenStorageService,
    );
  });

  test(
    'Logout usecase should clear session, token, and call repository logOut',
    () async {
      // Arrange
      when(
        () => mockUserSessionService.clearSession(),
      ).thenAnswer((_) async {});
      when(
        () => mockTokenStorageService.deleteToken(),
      ).thenAnswer((_) async {});
      when(
        () => mockAuthRepository.logOut(),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result, const Right(true));
      verify(() => mockUserSessionService.clearSession()).called(1);
      verify(() => mockTokenStorageService.deleteToken()).called(1);
      verify(() => mockAuthRepository.logOut()).called(1);
    },
  );

  test('Logout usecase should call methods in correct order', () async {
    // Arrange
    final callOrder = <String>[];

    when(() => mockUserSessionService.clearSession()).thenAnswer((_) async {
      callOrder.add('clearSession');
    });
    when(() => mockTokenStorageService.deleteToken()).thenAnswer((_) async {
      callOrder.add('deleteToken');
    });
    when(() => mockAuthRepository.logOut()).thenAnswer((_) async {
      callOrder.add('logOut');
      return const Right(true);
    });

    // Act
    await logoutUsecase();

    // Assert
    expect(callOrder, ['clearSession', 'deleteToken', 'logOut']);
  });
}
