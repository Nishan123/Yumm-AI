import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/constants/propmpts.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';

class GenerateScanRecipeReceiptParams extends Equatable {
  final XFile image;
  final String mealType;

  const GenerateScanRecipeReceiptParams({
    required this.image,
    required this.mealType,
  });

  @override
  List<Object?> get props => [image, mealType];
}

final generateScanRecipeReceiptUsecaseProvider =
    Provider<GenerateScanRecipeReceipt>((ref) {
      return GenerateScanRecipeReceipt();
    });

class GenerateScanRecipeReceipt
    implements UsecaseWithParms<RecipeModel, GenerateScanRecipeReceiptParams> {
  @override
  Future<Either<Failure, RecipeModel>> call(
    GenerateScanRecipeReceiptParams params,
  ) async {
    try {
      final prompt = await Propmpts().getReceiptScannerPrompt(
        mealType: params.mealType,
      );
      final bytes = await File(params.image.path).readAsBytes();

      final response = await Gemini.instance.prompt(
        parts: [Part.text(prompt), Part.bytes(bytes)],
      );

      if (response?.output == null) {
        return Left(GeneralFailure("Failed to generate recipe from receipt"));
      }

      String jsonString = response!.output!;
      if (jsonString.contains('```json')) {
        jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '');
      } else if (jsonString.contains('```')) {
        jsonString = jsonString.replaceAll('```', '');
      }

      // Check for error in JSON
      if (jsonString.contains('"error":')) {
        final errorMap = jsonDecode(jsonString);
        if (errorMap['error'] != null) {
          return Left(GeneralFailure(errorMap['error']));
        }
      }

      final masterIngridents = await Propmpts.loadIngredients();
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      final tempRecipe = RecipeModel.fromAiJson(jsonMap, [], masterIngridents);

      return Right(tempRecipe);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
