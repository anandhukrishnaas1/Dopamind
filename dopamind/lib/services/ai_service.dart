import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  static Future<String> getAIAnalytics(Map<String, dynamic> usageData) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    
    if (apiKey == null || apiKey == 'your_api_key_here') {
      return 'Please set your OpenRouter API key in the .env file to get AI insights.';
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://github.com/dopamind/dopamind', // Optional
          'X-Title': 'Dopamind App', // Optional
        },
        body: jsonEncode({
          'model': 'meta-llama/llama-3.1-8b-instruct:free', // Using a free model for demo
          'messages': [
            {
              'role': 'system',
              'content': 'You are the Dopamind AI coach. Analyze the users app usage and provide a concise, motivational insight (max 2 sentences) on how to improve their focus and dopamine health.'
            },
            {
              'role': 'user',
              'content': 'Usage statistics: ${jsonEncode(usageData)}'
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'AI currently unavailable. Focus on your goals!';
      }
    } catch (e) {
      return 'Error connecting to AI. Stay disciplined!';
    }
  }
}
