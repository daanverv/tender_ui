import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:tender_ui/services/excel_upload_service.dart';
import 'package:tender_ui/services/query_excel_pdf_service.dart';

const Color jnjRed = Color(0xFFD71920);

class ExcelUploadPage extends StatefulWidget {
  @override
  _ExcelUploadPageState createState() => _ExcelUploadPageState();
}

class _ExcelUploadPageState extends State<ExcelUploadPage> {
  File? _selectedFile;
  String _errorMessage = '';

  Future<void> _selectLocalFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'No file selected.';
      });
    }
  }

Future<void> _pickFileFromDatabase() async {
  try {
    final BuildContext parentContext = context;

    final service = ExcelUploadService();
    final files = await service.seeExcel();

    final validFiles = files.where((file) =>
      file['id'] != null &&
      file['filename'] != null &&
      file['filename'].toString().trim().isNotEmpty
    ).toList();

    if (validFiles.isEmpty) {
      setState(() {
        _errorMessage = 'No valid files found in the database.';
      });
      return;
    }

    int? selectedIndex;

await showDialog(
  context: parentContext,
  builder: (context) {
    int? selectedIndex;
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text('Select an Excel File'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: validFiles.length,
            itemBuilder: (context, index) {
              final file = validFiles[index];
              return RadioListTile<int>(
                value: index,
                groupValue: selectedIndex,
                title: Text('File ID: ${file['id']}'),
                onChanged: (int? value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: selectedIndex != null
                ? () {
                    final file = validFiles[selectedIndex!];
                    final String content = file['filename'];

                    final List<List<dynamic>> parsedData = content
                        .trim()
                        .split('\n')
                        .map((line) => line
                            .split(',')
                            .map((cell) => cell.trim())
                            .toList())
                        .toList();

                    final headers = parsedData[0];
                    final int columnCount = headers.length;

                    final rows = parsedData.skip(1).map((row) {
                      final paddedRow = List<dynamic>.from(row);
                      if (paddedRow.length < columnCount) {
                        paddedRow.addAll(
                            List.filled(columnCount - paddedRow.length, ''));
                      } else if (paddedRow.length > columnCount) {
                        paddedRow.removeRange(columnCount, paddedRow.length);
                      }
                      return paddedRow;
                    }).toList();

                    Navigator.pop(context);

                    Future.microtask(() {
                      showDialog(
                        context: parentContext,
                        builder: (context) => AlertDialog(
                          title: Text('Excel Content'),
                          content: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columns: headers
                                    .map((header) => DataColumn(
                                        label: Text(header.toString())))
                                    .toList(),
                                rows: rows
                                    .map((row) => DataRow(
                                          cells: row
                                              .map((cell) => DataCell(
                                                  Text(cell.toString())))
                                              .toList(),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      );
                    });
                  }
                : null,
            child: Text('View File'),
          ),
          ElevatedButton(
            onPressed: selectedIndex != null
                ? () async {
                    final selectedFile = validFiles[selectedIndex!];
                    final int fileId = selectedFile['id'];

                    Navigator.pop(context); // Close selection dialog
                    await Future.delayed(Duration(milliseconds: 200));

                    final urlController = TextEditingController();

                    await showDialog(
                      context: parentContext,
                      builder: (context) => AlertDialog(
                        title: Text('Enter URL to Filter PDF'),
                        content: TextField(
                          controller: urlController,
                          decoration: InputDecoration(
                            hintText: 'https://example.com/your-pdf-url',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final url = urlController.text.trim();
                              if (url.isEmpty) {
                                ScaffoldMessenger.of(parentContext).showSnackBar(
                                  SnackBar(
                                      content: Text('Please enter a valid URL')),
                                );
                                return;
                              }

                              Navigator.pop(context); // Close URL input

                             BuildContext? spinnerContext;
                            showDialog(
                              context: parentContext,
                              barrierDismissible: false,
                              builder: (context) {
                                spinnerContext = context; // save spinner context
                                return AlertDialog(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Text('Filtering PDF...'),
                                    ],
                                  ),
                                );
                              },
                            );

                            try {
                              final result = await queryExcelPdf(fileId, url);
                              final message = result[0];
                              final answer = result[1];

                              if (spinnerContext != null && Navigator.canPop(spinnerContext!)) {
                                Navigator.pop(spinnerContext!); // ✅ Close the spinner
                              }

                              await showDialog(
                                context: parentContext,
                                builder: (context) => AlertDialog(
                                  title: Text('Filter Result'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Message:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text(message),
                                        SizedBox(height: 16),
                                        Text('Answer:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text(answer),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            } catch (e) {
                              if (spinnerContext != null && Navigator.canPop(spinnerContext!)) {
                                Navigator.pop(spinnerContext!); // ✅ Ensure spinner is closed on error
                              }
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                            },
                            child: Text('Filter PDF'),
                          ),
                        ],
                      ),
                    );
                  }
                : null,
            child: Text('Select for Filtering'),
          ),
        ],
      ),
    );
  },
);

  } catch (e) {
    setState(() {
      _errorMessage = 'Error: $e';
    });
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Upload Excel'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload or select an Excel file',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: jnjRed,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Upload/Select Buttons Card
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.upload_file),
                    label: Text('Select Local Excel File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jnjRed,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _selectLocalFile,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.cloud_download),
                    label: Text('Browse Uploaded Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      minimumSize: Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _pickFileFromDatabase,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Selected File Info
          if (_selectedFile != null)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.insert_drive_file, color: Colors.green[700]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SelectableText(
                        'Selected File: ${_selectedFile!.path.split('/').last}',
                        style: TextStyle(color: Colors.green[900]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Error Message
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[800]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[800]),
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
}
  }
  