import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tender_ui/services/tender_service.dart';
import 'dart:html' as html; 

const Color jnjRed = Color(0xFFD71920);

class TenderOverviewPage extends StatefulWidget {
  final int websiteId;

  const TenderOverviewPage({Key? key, required this.websiteId}) : super(key: key);

  @override
  _TenderOverviewPageState createState() => _TenderOverviewPageState();
}

class _TenderOverviewPageState extends State<TenderOverviewPage> {
  final GetTenders tenderService = GetTenders();
  String? _overview;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTenders();
  }

  Future<void> fetchTenders() async {
    setState(() => isLoading = true);
    try {
      final overview = await tenderService.fetchTendersOverview(widget.websiteId);
      final decodedOverview = overview.replaceAll(r'\n', '\n');
      setState(() {
        _overview = decodedOverview;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> copyToClipboard() async {
    if (_overview != null) {
      await Clipboard.setData(ClipboardData(text: _overview!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copied to clipboard")),
      );
    }
  }

Future<void> exportToCSV() async {
  if (_overview == null) return;

  final csvContent = _overview!
      .replaceAll('|', ',')
      .replaceAll(RegExp(r',\s+'), ',')
      .replaceAll(RegExp(r'\n+'), '\n');

  if (kIsWeb) {
    final bytes = utf8.encode(csvContent);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "tender_overview.csv")
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV download started")),
    );
  } else {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/tender_overview.csv');
    await file.writeAsString(csvContent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("CSV exported to ${file.path}")),
    );
    Share.shareXFiles([XFile(file.path)], text: 'Tender Overview CSV');
  }
}


Future<void> exportToPDF() async {
  if (_overview == null) return;

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Text(_overview!),
    ),
  );

  final pdfBytes = await pdf.save();

  if (kIsWeb) {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "tender_overview.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF download started")),
    );
  } else {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/tender_overview.pdf");
    await file.writeAsBytes(pdfBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF exported to ${file.path}")),
    );
    await Printing.sharePdf(bytes: pdfBytes, filename: 'tender_overview.pdf');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Tender Overview"),
        backgroundColor: jnjRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          Tooltip(
            message: 'Refresh Overview',
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: fetchTenders,
            ),
          ),
          Tooltip(
            message: 'Copy to Clipboard',
            child: IconButton(
              icon: const Icon(Icons.copy, color: Colors.white),
              onPressed: copyToClipboard,
            ),
          ),
          Tooltip(
            message: 'Export as CSV',
            child: IconButton(
              icon: const Icon(Icons.table_chart, color: Colors.white),
              onPressed: exportToCSV,
            ),
          ),
          Tooltip(
            message: 'Export as PDF',
            child: IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              onPressed: exportToPDF,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _overview == null
              ? const Center(child: Text("No overview available."))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          maxWidth: constraints.maxWidth,
                          minHeight: 200,
                          maxHeight: constraints.maxHeight,
                        ),
                        child: Markdown(
                          data: _overview!,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 14),
                            tableBody: const TextStyle(fontFamily: 'Courier'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
