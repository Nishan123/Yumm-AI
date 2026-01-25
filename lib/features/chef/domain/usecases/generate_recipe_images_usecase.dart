import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/services/imagen_service.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';

class GenerateRecipeImagesParams extends Equatable {
  final String recipeName;
  final String description;
  final int numberOfImages;

  const GenerateRecipeImagesParams({
    required this.recipeName,
    required this.description,
    this.numberOfImages = 2,
  });

  @override
  List<Object?> get props => [recipeName, description, numberOfImages];
}

final generateRecipeImagesUsecaseProvider = Provider((ref) {
  final imagenService = ref.watch(imagenServiceProvider);
  return GenerateRecipeImagesUsecase(imagenService: imagenService);
});

class GenerateRecipeImagesUsecase
    implements UsecaseWithParms<List<Uint8List>, GenerateRecipeImagesParams> {
  final ImagenService _imagenService;

  GenerateRecipeImagesUsecase({required ImagenService imagenService})
    : _imagenService = imagenService;

  @override
  Future<Either<Failure, List<Uint8List>>> call(
    GenerateRecipeImagesParams params,
  ) async {
    try {
      final images = await _imagenService.generateRecipeImages(
        recipeName: params.recipeName,
        description: params.description,
        numberOfImages: params.numberOfImages,
      );
      return Right(images);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
