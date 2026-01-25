import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImagenService {
  static final String _apiKey = dotenv.env['GOOGLE_AI_API_KEY'] ?? "";

  // Endpoint for Imagen 4.0 via Generative Language API
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-fast-generate-001:predict';

  final Dio _dio = Dio();

  ImagenService() {
    if (_apiKey.isEmpty) {
      debugPrint("Warning: GOOGLE_AI_API_KEY is not set in .env");
    }
  }

  /// Generates images based on the recipe description
  /// Returns a list of image bytes
  Future<List<Uint8List>> generateRecipeImages({
    required String recipeName,
    required String description,
    int numberOfImages = 2,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        "Google AI API Key is missing. Please check your .env file.",
      );
    }

    final prompt =
        'A professional, high-quality, delicious food photography shot of $recipeName. $description. Creating a mouth-watering presentation with perfect lighting. 4k, potentially garnished with herbs.';

    try {
      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          "instances": [
            {"prompt": prompt},
          ],
          "parameters": {
            "sampleCount": numberOfImages,
            "aspectRatio": "1:1", // or "4:3"
          },
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Parse response...
        if (data['predictions'] != null) {
          final List<dynamic> predictions = data['predictions'];
          final List<Uint8List> images = [];

          for (var prediction in predictions) {
            if (prediction['bytesBase64Encoded'] != null) {
              final String base64Image = prediction['bytesBase64Encoded'];
              images.add(base64Decode(base64Image));
            } else if (prediction['mimeType'] == 'image/png' &&
                prediction['bytesBase64Encoded'] != null) {
              images.add(base64Decode(prediction['bytesBase64Encoded']));
            }
          }

          if (images.isNotEmpty) {
            return images;
          }
        }
      }

      throw Exception('Failed to generate images: ${response.data}');
    } catch (e) {
      debugPrint(
        "Warning: Image generation failed (likely 404 or no access): $e",
      );
      // Fallback: Return empty list to allow recipe creation to continue without images
      return [];
    }
  }
}
