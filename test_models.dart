import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    return;
  }

  final lines = await envFile.readAsLines();
  String? apiKey;
  for (var line in lines) {
    if (line.startsWith('GOOGLE_AI_API_KEY=')) {
      apiKey = line.split('=')[1].trim();
    }
  }

  if (apiKey == null || apiKey.isEmpty) return;

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
  );
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final file = File('models_list.txt');
      var sink = file.openWrite();
      sink.writeln("Available Models for key: ${apiKey.substring(0, 5)}...");
      for (var model in json['models']) {
        sink.writeln(model['name']);
      }
      await sink.close();
      print("Models written to models_list.txt");
    } else {
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Exception: $e");
  }
}
