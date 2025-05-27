import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tender_ui/env.dart';

class SearchService {
  static final String baseUrl = Env.JNJ_API_URL;

  SearchService();

  Future<List<String>> searchDatabase(String query) async {
    final uri = Uri.parse('$baseUrl/search?keyword=$query');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resultText = data['results']?.toString() ?? 'No results found.';
        return [resultText]; // Wrap in a list for display
      } else {
        throw Exception('Failed to search database: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during search: $e');
    }
  }
}

