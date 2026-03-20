import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/profile/domain/repositories/profile_repository.dart';
import 'package:yumm_ai/features/profile/domain/usecases/update_profile_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late UpdateProfileUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdateProfileUsecase(mockRepository);
  });

  const tFullName = "John Doe";
  const tUid = "test_uid";
  const tAllergicIng = ["Peanuts"];
  const tIsSubscribed = true;
  const tProfilePic = "url";

  final tParams = UpdateProfileParams(
    fullName: tFullName,
    uid: tUid,
    allergicIng: tAllergicIng,
    isSubscribed: tIsSubscribed,
    profilePic: tProfilePic,
  );

  test('should call updateProfile on the repository', () async {
    // arrange
    when(
      () => mockRepository.updateProfile(
        tFullName,
        tIsSubscribed,
        tAllergicIng,
        tProfilePic,
        tUid,
      ),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(null));
    verify(
      () => mockRepository.updateProfile(
        tFullName,
        tIsSubscribed,
        tAllergicIng,
        tProfilePic,
        tUid,
      ),
    );
    verifyNoMoreInteractions(mockRepository);
  });
}
