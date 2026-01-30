import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('GoogleSigninUsecase - Repository Integration', () {
    const tIdToken = 'test_id_token_123';
    final tUser = FakeUserEntity();

    test(
      'should call signInWithGoogle on repository with correct idToken',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.signInWithGoogle(tIdToken),
        ).thenAnswer((_) async => Right(tUser));

        // Act
        final result = await mockAuthRepository.signInWithGoogle(tIdToken);

        // Assert
        expect(result, Right(tUser));
        verify(() => mockAuthRepository.signInWithGoogle(tIdToken)).called(1);
      },
    );

    test(
      'should return ApiFailure when repository signInWithGoogle fails',
      () async {
        // Arrange
        final tFailure = ApiFailure(message: 'Google authentication failed');
        when(
          () => mockAuthRepository.signInWithGoogle(tIdToken),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await mockAuthRepository.signInWithGoogle(tIdToken);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockAuthRepository.signInWithGoogle(tIdToken)).called(1);
      },
    );

    test('should return ApiFailure when idToken is empty', () async {
      // Arrange
      const emptyToken = '';
      final tFailure = ApiFailure(message: 'Invalid token');
      when(
        () => mockAuthRepository.signInWithGoogle(emptyToken),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await mockAuthRepository.signInWithGoogle(emptyToken);

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('GoogleSigninUsecase - Error Handling', () {
    test('should handle ApiFailure for cancelled sign-in', () {
      // Arrange
      final failure = ApiFailure(message: "Google Sign-In was cancelled");

      // Assert
      expect(failure.errorMessage, "Google Sign-In was cancelled");
    });

    test('should handle ApiFailure for missing ID token', () {
      // Arrange
      final failure = ApiFailure(message: "Failed to get Google ID token");

      // Assert
      expect(failure.errorMessage, "Failed to get Google ID token");
    });

    test('should handle ApiFailure for general sign-in failure', () {
      // Arrange
      const errorMessage = 'Network error';
      final failure = ApiFailure(
        message: "Google Sign-In failed: $errorMessage",
      );

      // Assert
      expect(failure.errorMessage, contains("Google Sign-In failed"));
      expect(failure.errorMessage, contains(errorMessage));
    });
  });
}

