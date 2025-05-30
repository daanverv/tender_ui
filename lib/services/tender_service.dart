import 'dart:convert';
import 'package:tender_ui/models/tender.dart';
import 'package:http/http.dart' as http;
import 'package:tender_ui/env.dart';


class GetTenders {

  static final String _baseUrl = Env.JNJ_API_URL;

  static Future<List<Tender>> fetchTenders(int websiteId) async {

    final response = await http.get(Uri.parse('$_baseUrl/scrape_results/$websiteId'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Tender.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tenders');
    }
  }



  Future<String> fetchTendersOverview(int websiteId) async {
    final response = await http.get(Uri.parse('$_baseUrl/clear_view/$websiteId'));
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['overview'];
    } else {
      throw Exception('Failed to load overview');
    }
  }

}
