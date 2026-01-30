import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FackeUserEntity extends Fake implements UserEntity {}

void main() {
  late LoginUsecase loginUsecase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
  });
  const tEmail = "test@gmail.com";
  const tPassword = "password123";
  const tParams = LoginUsecaseParam(email: tEmail, password: tPassword);
  final tUser = FackeUserEntity();

  test('Login uscase test', () async {
    when(
      () => mockAuthRepository.loginWithEmailPassword(tEmail, tPassword),
    ).thenAnswer((ans) async => Right(tUser));

    final result = await loginUsecase(tParams);
    expect(result, Right(tUser));
    verify(() {
      mockAuthRepository.loginWithEmailPassword(tEmail, tPassword);
    });
  });
}
