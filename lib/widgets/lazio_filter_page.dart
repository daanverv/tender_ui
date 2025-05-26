
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tender_ui/services/filter_service.dart';

const Color jnjRed = Color(0xFFD71920);

class LazioFilterPage extends StatefulWidget {
  @override
  _LazioFilterPageState createState() => _LazioFilterPageState();
}

class _LazioFilterPageState extends State<LazioFilterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cigCodeController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _keyWordController = TextEditingController();

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Applying Filters..."),
              ],
            ),
          ),
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      title: const Text('Lazio Tender Filters'),
      backgroundColor: jnjRed,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure filters for Lazio tenders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: jnjRed,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cigCodeController,
                      decoration: InputDecoration(
                        labelText: 'CIG Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _keyWordController,
                      decoration: InputDecoration(
                        labelText: 'Keyword',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.filter_alt),
                        label: Text('Apply Filters'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: jnjRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          _showLoadingDialog(context); // Show spinner

                          try {
                            final filterService = FilterService();

                            await filterService.submitLazioFilters(
                              context: context,
                              cigCode: _cigCodeController.text,
                              year: _yearController.text,
                              keyWord: _keyWordController.text,
                            );
                          } finally {
                            Navigator.of(context, rootNavigator: true).pop(); // Close spinner
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}}