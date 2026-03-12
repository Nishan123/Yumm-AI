import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/profile/domain/repositories/profile_repository.dart';
import 'package:yumm_ai/features/profile/domain/usecases/delete_user_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late DeleteUserUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = DeleteUserUsecase(iprofileRepository: mockRepository);
  });

  const tUid = "test_uid";
  const tReason = "test_reason";
  final tParams = DeleteUserUsecaseParams(uid: tUid, reason: tReason);

  test('should call deleteUser on the repository', () async {
    // arrange
    when(
      () => mockRepository.deleteUser(tUid, tReason),
    ).thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(true));
    verify(() => mockRepository.deleteUser(tUid, tReason));
    verifyNoMoreInteractions(mockRepository);
  });
}
