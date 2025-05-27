import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:tender_ui/services/search_db_service.dart';
import 'package:url_launcher/url_launcher.dart';

const Color jnjRed = Color(0xFFD71920);

class ScrapePage extends StatelessWidget {
  const ScrapePage({super.key});

  Future<void> _showSearchDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();
  final searchService = SearchService();

  await showDialog(
    context: context,
    builder: (context) {
      bool isLoading = false;
      List<dynamic> results = [];

      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Enter your search query to search the database'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Search query'),
              ),
              const SizedBox(height: 16),
              if (isLoading) const CircularProgressIndicator(),
              if (results.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: SelectableText(
                      results.first,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            if (results.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: results.first));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                child: const Text('Copy to Clipboard'),
              ),
            ElevatedButton(
              onPressed: () async {
                final query = controller.text.trim();
                if (query.isEmpty) return;

                setState(() {
                  isLoading = true;
                  results = [];
                });

                try {
                  final data = await searchService.searchDatabase(query);
                  setState(() {
                    results = data;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: const Text('Search'),
            ),
          ],
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
        title: const Text('Scraping Options'),
        backgroundColor: jnjRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(context, 'Scrape Site', '/scrape_website'),
            _buildCard(context, 'See Scrape Results', '/tenders'),
            _buildCard(context, 'Scrape Based on Filters', '/scrape_with_filters'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSearchDialog(context),
        backgroundColor: jnjRed,
        child: const Icon(Icons.search, color: Colors.white),
        tooltip: 'Search Database',
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        onTap: () => context.go(route),
      ),
    );
  }
}
