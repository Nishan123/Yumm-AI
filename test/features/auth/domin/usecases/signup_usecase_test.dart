import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/usecases/signup_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late SignupUsecase signupUsecase;
  late MockAuthRepository mockAuthRepository;
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signupUsecase = SignupUsecase(authRepository: mockAuthRepository);
  });

  const email = 'test@gmail.com';
  const password = 'password123';
  const fullName = 'Nishan Giri';
  const params = SignupUsecaseParam(
    email: email,
    password: password,
    fullName: fullName,
  );

  test('Signup usecase test', () async {
    when(
      () => mockAuthRepository.signUpWithEmailPassword(any()),
    ).thenAnswer((ans) async => Right(true));

    final result = await signupUsecase(params);

    expect(result, Right(true));
    verify(() => mockAuthRepository.signUpWithEmailPassword(any())).called(1);
  });
}
