import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumm_ai/core/constants/propmpts.dart';
import 'package:yumm_ai/core/error/failure.dart';
import 'package:yumm_ai/core/usecases/app_usecases.dart';
import 'package:yumm_ai/features/chef/data/models/recipe_model.dart';
import 'dart:io';

class GenerateScanRecipeFridgeParams extends Equatable {
  final XFile image;
  final String mealType;

  const GenerateScanRecipeFridgeParams({
    required this.image,
    required this.mealType,
  });

  @override
  List<Object?> get props => [image, mealType];
}

final generateScanRecipeFridgeUsecaseProvider =
    Provider<GenerateScanRecipeFridge>((ref) {
      return GenerateScanRecipeFridge();
    });

class GenerateScanRecipeFridge
    implements UsecaseWithParms<RecipeModel, GenerateScanRecipeFridgeParams> {
  @override
  Future<Either<Failure, RecipeModel>> call(
    GenerateScanRecipeFridgeParams params,
  ) async {
    try {
      final prompt = await Propmpts().getFridgeScannerPrompt(
        mealType: params.mealType,
      );
      final bytes = await File(params.image.path).readAsBytes();

      final response = await Gemini.instance.prompt(
        parts: [Part.text(prompt), Part.bytes(bytes)],
      );

      if (response?.output == null) {
        return Left(GeneralFailure("Failed to generate recipe from image"));
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

      // We pass empty list for reference ingredients because scanner identifies them
      // But we need masterIngredients to map correctly
      final tempRecipe = RecipeModel.fromAiJson(jsonMap, [], masterIngridents);

      return Right(tempRecipe);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
