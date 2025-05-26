import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tender_ui/env.dart';

class FilterService {
   static final String baseUrl = Env.JNJ_API_URL;


  Future<void> submitLombardiaFilters({
    required BuildContext context,
    required String cigCode,
    required String sintelId,
    required String auctionName,
    required String category,
    required String auctionCode,
    required List<String> selectedAuctionTypes,
    required List<String> selectedAuctionStatuses,
    required List<String> selectedBidTypes,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final uri = Uri.parse('$baseUrl/filterLombardia');
    final request = http.MultipartRequest('POST', uri);

    request.fields['cig_code'] = cigCode;
    request.fields['sintel_id'] = sintelId;
    request.fields['auction_name'] = auctionName;
    request.fields['category'] = category;
    request.fields['auction_code'] = auctionCode;

    for (var type in selectedAuctionTypes) {
      request.fields['auction_type'] = type;
    }
    for (var status in selectedAuctionStatuses) {
      request.fields['auction_status'] = status;
    }
    for (var bid in selectedBidTypes) {
      request.fields['bid_type'] = bid;
    }

    if (dateFrom != null) {
      request.fields['date_from'] = dateFrom.toIso8601String();
    }
    if (dateTo != null) {
      request.fields['date_to'] = dateTo.toIso8601String();
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Success: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filters applied successfully!')),
        );
      } else {
        print('Failed: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply filters.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while applying filters.')),
      );
    }
  }

   Future<void> submitLazioFilters({
    required BuildContext context,
    required String cigCode,
    required String year,
    required String keyWord,
  }) async {
    final uri = Uri.parse('$baseUrl/filterLazio');
    final request = http.MultipartRequest('POST', uri);

    request.fields['cig_code'] = cigCode;
    request.fields['year'] = year;
    request.fields['key_word'] = keyWord;

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        final resultUrl = responseData['result_url'];
        print('Success: $resultUrl');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filters applied successfully! Result URL: $resultUrl')),
        );
      } else {
        print('Failed: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply filters.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while applying filters.')),
      );
    }
  }

  Future<void> submitMarcheFilters({
  required BuildContext context,
  required String cigCode,
  required String title,
  required String contractingAuthority,
  required String status,
  required String refNum,
}) async {
  final uri = Uri.parse('$baseUrl/filterMarche');
  final headers = {'Content-Type': 'application/json'};

  final body = json.encode({
    'cig_code': cigCode,
    'title': title,
    'contracting_authority': contractingAuthority,
    'status': status,
    'ref_num': refNum,
  });

  try {
    final response = await http.post(uri, headers: headers, body: body);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      final resultUrl = responseData['result_url'];
      print('Success: $resultUrl');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Filters applied successfully! Result URL: $resultUrl')),
      );
    } else {
      print('Failed: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply filters.')),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred while applying filters.')),
    );
  }
}
}
