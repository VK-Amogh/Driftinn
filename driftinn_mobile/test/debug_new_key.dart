import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  final apiKey = 'AIzaSyBsnhDqv1jV9LvNmYXW-CRVdwsaLzFCtMs';
  final modelName = 'gemini-1.5-flash';

  print('Testing API Key: $apiKey');
  print('Model: $modelName');

  try {
    final model = GenerativeModel(model: modelName, apiKey: apiKey);
    final response = await model.generateContent([
      Content.text('Say "Hello World" if you work.'),
    ]);
    print('SUCCESS! Response: ${response.text}');
  } catch (e) {
    print('FAILURE. Error details:');
    print(e);
  }
}
