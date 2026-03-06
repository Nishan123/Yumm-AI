import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/auth/domin/entities/user_entity.dart';
import 'package:yumm_ai/features/auth/domin/repositories/auth_repository.dart';
import 'package:yumm_ai/features/auth/domin/usecases/get_current_user_from_server_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late GetCurrentUserFromServerUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserFromServerUsecase(
      authRepository: mockAuthRepository,
    );
  });

  final tUser = FakeUserEntity();

  test('should call getCurrentUserFromServer on the repository', () async {
    // arrange
    when(
      () => mockAuthRepository.getCurrentUserFromServer(),
    ).thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tUser));
    verify(() => mockAuthRepository.getCurrentUserFromServer());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
