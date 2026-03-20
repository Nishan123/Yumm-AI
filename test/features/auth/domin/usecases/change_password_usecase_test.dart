import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/usecases/change_password_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late ChangePasswordUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = ChangePasswordUseCase(mockAuthRepository);
  });

  const tOldPassword = "oldPassword123";
  const tNewPassword = "newPassword123";
  const tParams = ChangePasswordParams(
    oldPassword: tOldPassword,
    newPassword: tNewPassword,
  );
  final tUser = FakeUserEntity();

  test('should call changePassword on the repository', () async {
    // arrange
    when(
      () => mockAuthRepository.changePassword(tOldPassword, tNewPassword),
    ).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, Right(tUser));
    verify(() => mockAuthRepository.changePassword(tOldPassword, tNewPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
