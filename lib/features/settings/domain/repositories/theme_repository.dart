import 'package:dartz/dartz.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';

abstract interface class IThemeRepository {
  Future<Either<Failure, AppThemeMode>> getSavedTheme();
  Future<Either<Failure, AppThemeMode>> updateTheme(AppThemeMode themeMode);
}
