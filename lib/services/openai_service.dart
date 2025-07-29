import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService extends ChangeNotifier {
  bool _isLoading = false;
  String? _lastResponse;

  bool get isLoading => _isLoading;
  String? get lastResponse => _lastResponse;

  Future<String?> getMoodResponse(String moodText) async {
    try {
      _isLoading = true;
      notifyListeners();

      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null) {
        throw Exception('OpenAI API key not found');
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': '''You are a supportive AI companion for young adults (18-25) dealing with mental wellness. 
              Provide empathetic, encouraging, and helpful responses. Keep responses concise (2-3 sentences) and positive. 
              Don't give medical advice - just emotional support and gentle encouragement.'''
            },
            {
              'role': 'user',
              'content': moodText,
            }
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _lastResponse = data['choices'][0]['message']['content'];
        return _lastResponse;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting OpenAI response: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}