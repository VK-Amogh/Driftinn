import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

void main() async {
  // Key from mbti_service.dart
  final apiKey = 'AIzaSyDVNgAAibDauHkrxmpYFqOCXBo6kp19NOU';

  if (apiKey.isEmpty) {
    print('No API key provided.');
    return;
  }

  try {
    print('Listing models using google_generative_ai...');
    // We cannot easily 'list' models with the client directly in all versions,
    // but we can try to initialize one and run a simple prompt.

    final modelNames = [
      'gemini-1.5-flash',
      'gemini-1.5-pro',
      'gemini-pro',
      'gemini-1.0-pro',
    ];

    for (final name in modelNames) {
      print('\nTesting model: $name');
      final model = GenerativeModel(model: name, apiKey: apiKey);
      try {
        final response = await model.generateContent([
          Content.text('Hello, are you working?'),
        ]);
        print('SUCCESS: $name works! Response: ${response.text}');
      } catch (e) {
        print('FAILURE: $name failed. Error: $e');
      }
    }
  } catch (e) {
    print('Critical Error: $e');
  }
}
