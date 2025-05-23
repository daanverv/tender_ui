import 'package:tender_ui/env.dart';
import 'package:tender_ui/models/website.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class WebsiteService {
    static final String _baseUrl = Env.JNJ_API_URL;
  static Future<List<Website>> fetchWebsites() async {
    final response = await http.get(Uri.parse('${_baseUrl}/websites'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Website.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load websites');
    }
  }
}
