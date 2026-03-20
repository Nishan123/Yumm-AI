import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geminiServiceProvider = Provider((ref) {
  return GeminiService();
});

class GeminiService {
  Future<Candidates?> promptAi(String prompt) async {
    return await Gemini.instance.prompt(parts: [Part.text(prompt)]);
  }

  String formatJsonResponse(String jsonString){
    String response;
    if (jsonString.contains('```json')) {
      response = jsonString.replaceAll('```json', '').replaceAll('```', '');
    } else if (jsonString.contains('```')) {
      response = jsonString.replaceAll('```', '');
    } else {
      response = jsonString;
    }
    return response;
  }
}
