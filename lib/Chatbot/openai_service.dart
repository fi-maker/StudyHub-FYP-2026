import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = "AIzaSyA7XuQ7-vGOkGwuTqt2FgBl5K9VSfM8-sg";

  // Define the model with system instructions
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-3-flash', // Or 'gemini-3-flash' as per latest 2026 updates
    apiKey: _apiKey,
    systemInstruction: Content.system(
      "You are an education consultancy assistant. Answer study abroad related questions clearly.",
    ),
  );

  Future<String> getReply(String userMessage) async {
    try {
      // Gemini uses a simpler 'generateContent' method
      final content = [Content.text(userMessage)];
      final response = await _model.generateContent(
        content,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          maxOutputTokens: 512,
        ),
      );

      if (response.text != null) {
        return response.text!;
      } else {
        return "Gemini could not generate a response.";
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return "Network or API error occurred.";
    }
  }
}