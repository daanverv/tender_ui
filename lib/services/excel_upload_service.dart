import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tender_ui/env.dart';

class ExcelUploadService {
  static final String baseUrl = Env.JNJ_API_URL;

  Future<List<List<dynamic>>> uploadExcelFile(File file) async {
    final uri = Uri.parse('$baseUrl/upload_excel');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(responseBody);
      return data.map((row) => (row as List).cast<dynamic>()).toList();
    } else {
      throw Exception('Failed to upload file: ${response.reasonPhrase}');
    }
  }

  Future<List<Map<String, dynamic>>> seeExcel() async {
    final uri = Uri.parse('$baseUrl/list_excels');
    final response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((file) => file as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to retrieve Excel files: ${response.reasonPhrase}');
    }
  }
}
