import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tender_ui/env.dart';


final String baseUrl = Env.JNJ_API_URL;

Future<List<dynamic>> queryExcelPdf(int fileId, String pdfUrl) async {
  final uri = Uri.parse('$baseUrl/query_excel_pdf');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'excel_id': fileId,
    'pdf_blob_path': pdfUrl,
  });

  try {
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final message = responseData['message'];
      final answer = responseData['answer'];
      return [message, answer]; // ✅ Return values directly
    } else {
      throw Exception('Failed with status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error sending request: $e');
  }
}