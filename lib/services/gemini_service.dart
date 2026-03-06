import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_keys.dart';

class GeminiService {

  final String apiKey = ApiKeys.geminiApiKey;

  Future<String?> generateResponse(String prompt) async {

    final url =
        "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return "API Error: ${response.statusCode}";
    }
  }
}