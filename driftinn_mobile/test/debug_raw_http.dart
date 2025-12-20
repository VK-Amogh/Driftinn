import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final apiKey = 'AIzaSyBsnhDqv1jV9LvNmYXW-CRVdwsaLzFCtMs';
  // Using v1beta for gemini-2.0-flash as it is a newer model
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=$apiKey',
  );

  print('Testing Raw HTTP to: $url');

  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {"text": "Hello, are you working?"}
        ]
      }
    ]
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('SUCCESS: Raw HTTP worked!');
    } else {
      print('FAILURE: Raw HTTP failed.');
    }
  } catch (e) {
    print('EXCEPTION: $e');
  }
}
