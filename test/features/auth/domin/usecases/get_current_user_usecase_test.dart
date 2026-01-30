import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late GetCurrentUserUsecase getCurrentUserUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getCurrentUserUsecase = GetCurrentUserUsecase(
      authRepository: mockAuthRepository,
    );
  });

  final tUser = FakeUserEntity();

  test('should return UserEntity when getCurrentUser is successful', () async {
    // Arrange
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => Right(tUser));

    // Act
    final result = await getCurrentUserUsecase();

    // Assert
    expect(result, Right(tUser));
    verify(() => mockAuthRepository.getCurrentUser()).called(1);
  });

  test('should return Failure when getCurrentUser fails', () async {
    // Arrange
    final tFailure = ApiFailure(message: 'No user logged in');
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await getCurrentUserUsecase();

    // Assert
    expect(result, Left(tFailure));
    verify(() => mockAuthRepository.getCurrentUser()).called(1);
  });
}
