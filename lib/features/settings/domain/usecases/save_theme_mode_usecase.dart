import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/settings/data/repositories/theme_repository_impl.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';
import 'package:yumm_ai/features/settings/domain/repositories/theme_repository.dart';

final saveThemeModeUsecaseProvider = Provider((ref) {
  final repository = ref.read(themeRepositoryProvider);
  return SaveThemeModeUsecase(themeRepository: repository);
});

class SaveThemeModeUsecase
    implements UsecaseWithParms<AppThemeMode, AppThemeMode> {
  final IThemeRepository _themeRepository;

  SaveThemeModeUsecase({required IThemeRepository themeRepository})
    : _themeRepository = themeRepository;

  @override
  Future<Either<Failure, AppThemeMode>> call(AppThemeMode params) {
    return _themeRepository.updateTheme(params);
  }
}
