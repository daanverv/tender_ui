import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tender_ui/env.dart';

class ScrapeApiService {
  static final String _baseUrl = Env.JNJ_API_URL;

  static Future<List<String>> scrapeSite(String siteName) async {
    final url = Uri.parse('$_baseUrl/scrape/$siteName');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> tenders = json.decode(response.body);
      return tenders.map((data) => data['tenderId'].toString()).toList();
    } else {
      throw Exception('Failed to scrape: ${response.reasonPhrase}');
    }
  }

  static Future<List<String>> getTenderUpdates(int website_id) async {
    final url = Uri.parse('$_baseUrl/scrape/updates/$website_id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> updates = json.decode(response.body);
      return updates.map((data) => data['tenderId'].toString()).toList();
    } else {
      throw Exception('Failed to fetch updates: ${response.reasonPhrase}');
    }
  }
}

