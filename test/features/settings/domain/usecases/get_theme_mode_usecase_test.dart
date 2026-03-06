import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';
import 'package:yumm_ai/features/settings/domain/repositories/theme_repository.dart';
import 'package:yumm_ai/features/settings/domain/usecases/get_theme_mode_usecase.dart';

class MockThemeRepository extends Mock implements IThemeRepository {}

void main() {
  late GetThemeModeUsecase usecase;
  late MockThemeRepository mockRepository;

  setUp(() {
    mockRepository = MockThemeRepository();
    usecase = GetThemeModeUsecase(themeRepository: mockRepository);
  });

  const tThemeMode = AppThemeMode.dark;

  test('should return AppThemeMode from the repository', () async {
    // arrange
    when(
      () => mockRepository.getSavedTheme(),
    ).thenAnswer((_) async => const Right(tThemeMode));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(tThemeMode));
    verify(() => mockRepository.getSavedTheme());
    verifyNoMoreInteractions(mockRepository);
  });
}
