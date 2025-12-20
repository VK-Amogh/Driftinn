import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Replace with the user's provided API Key if you want to test this script standalone
  final apiKey = 'YOUR_OPENAI_API_KEY';
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  print('Testing OpenAI API to: $url');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    "model": "gpt-4o",
    "messages": [
      {"role": "user", "content": "Hello, are you working?"}
    ],
    "max_tokens": 50
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('SUCCESS: OpenAI worked!');
    } else {
      print('FAILURE: OpenAI failed.');
    }
  } catch (e) {
    print('EXCEPTION: $e');
  }
}
