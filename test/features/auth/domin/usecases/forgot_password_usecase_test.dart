import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/usecases/forgot_password_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late ForgotPasswordUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = ForgotPasswordUsecase(authRepository: mockAuthRepository);
  });

  const tEmail = "test@example.com";

  test('should call forgotPassword on the repository', () async {
    // arrange
    when(
      () => mockAuthRepository.forgotPassword(tEmail),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tEmail);

    // assert
    expect(result, const Right(null));
    verify(() => mockAuthRepository.forgotPassword(tEmail));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
