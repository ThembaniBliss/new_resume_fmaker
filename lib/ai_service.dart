import 'package:http/http.dart' as http;

class AiService {
  // Assuming your backend API URL that handles text generation requests
  static const String _apiUrl = 'https://your-api-url.com/generate';

  static Future<String> generateText(String prompt) async {
    try {
      var response = await http.post(Uri.parse(_apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: '{"prompt": "$prompt"}');

      if (response.statusCode == 200) {
        // Assuming the API returns the generated text directly in the response body
        return response.body;
      } else {
        // Handle unexpected status code by returning a default message
        return "Failed to generate text: ${response.statusCode}";
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call
      return "Error occurred while generating text: $e";
    }
  }
}
