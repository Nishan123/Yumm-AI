import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/settings/data/repositories/theme_repository_impl.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';
import 'package:yumm_ai/features/settings/domain/repositories/theme_repository.dart';

final getThemeModeUsecaseProvider = Provider((ref) {
  final repository = ref.read(themeRepositoryProvider);
  return GetThemeModeUsecase(themeRepository: repository);
});

class GetThemeModeUsecase implements UsecaseWithoutParms<AppThemeMode> {
  final IThemeRepository _themeRepository;

  GetThemeModeUsecase({required IThemeRepository themeRepository})
    : _themeRepository = themeRepository;

  @override
  Future<Either<Failure, AppThemeMode>> call() {
    return _themeRepository.getSavedTheme();
  }
}
