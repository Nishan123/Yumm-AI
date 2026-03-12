import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:yumm_ai/features/subscription/domain/usecases/check_entitlement_usecase.dart';

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  late CheckEntitlementUsecase usecase;
  late MockSubscriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockSubscriptionRepository();
    usecase = CheckEntitlementUsecase(repository: mockRepository);
  });

  test('should return true if user is entitled', () async {
    // arrange
    when(
      () => mockRepository.checkEntitlement(),
    ).thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(true));
    verify(() => mockRepository.checkEntitlement());
    verifyNoMoreInteractions(mockRepository);
  });
}
