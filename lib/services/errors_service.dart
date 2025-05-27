import 'package:http/http.dart' as http;
import 'package:tender_ui/env.dart';
import 'package:tender_ui/models/error.dart';
import 'dart:convert';


class ErrorsService {
  static final String baseUrl = Env.JNJ_API_URL;

  static Future<List<ErrorLog>> fetchLogs() async {
  final response = await http.get(Uri.parse('$baseUrl/logs'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonBody = json.decode(response.body);
    final List<dynamic> logsJson = jsonBody['logs'];
    return logsJson.map((log) => ErrorLog.fromJson(log)).toList();
  } else {
    throw Exception('Failed to load logs');
  }
}
  static Future<void> clearLogs() async {
    final response = await http.delete(Uri.parse('$baseUrl/clear_logs'));

    if (response.statusCode != 200) {
      throw Exception('Failed to clear logs');
    }
  }

}
