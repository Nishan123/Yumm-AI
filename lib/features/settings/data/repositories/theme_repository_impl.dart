import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/features/settings/data/datasource/theme_local_datasource.dart';
import 'package:yumm_ai/features/settings/domain/entities/app_theme_entity.dart';
import 'package:yumm_ai/features/settings/domain/repositories/theme_repository.dart';

final themeRepositoryProvider = Provider<IThemeRepository>((ref) {
  final localDatasource = ref.read(themeLocalDatasourceProvider);
  return ThemeRepository(localDatasource: localDatasource);
});

class ThemeRepository implements IThemeRepository {
  final IThemeLocalDatasource _localDatasource;

  ThemeRepository({required IThemeLocalDatasource localDatasource})
    : _localDatasource = localDatasource;

  @override
  Future<Either<Failure, AppThemeMode>> getSavedTheme() async {
    try {
      final themeMode = await _localDatasource.getSavedTheme();
      return Right(themeMode);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "$e"));
    }
  }

  @override
  Future<Either<Failure, AppThemeMode>> updateTheme(
    AppThemeMode themeMode,
  ) async {
    try {
      final savedTheme = await _localDatasource.cacheTheme(themeMode);
      return Right(savedTheme);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "$e"));
    }
  }
}
