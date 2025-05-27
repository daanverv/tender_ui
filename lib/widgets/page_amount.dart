import 'package:flutter/material.dart';
import 'package:tender_ui/services/website_service.dart';

const Color jnjRed = Color(0xFFD71920);

class PageAmountScreen extends StatefulWidget {
  const PageAmountScreen({Key? key}) : super(key: key);

  @override
  State<PageAmountScreen> createState() => _PageAmountScreenState();
}

class _PageAmountScreenState extends State<PageAmountScreen> {
  List<String> websites = [];
  final Map<String, int> pageAmounts = {};

  @override
  void initState() {
    super.initState();
    _loadWebsites();
  }

  Future<void> _loadWebsites() async {
    final sites = await WebsiteService.fetchWebsites();
    setState(() {
      websites = sites.map((site) => site.name.toString()).toList();
    });
  }

  void _onConfirm() {
    for (var site in websites) {
      final pages = pageAmounts[site];
      debugPrint('Site: $site, Pages: $pages');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page amounts saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Set Amount of Pages to Scrape'),
        backgroundColor: jnjRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: websites.length,
                itemBuilder: (context, index) {
                  final site = websites[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(site, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Number of pages to be scraped',
                            ),
                            onChanged: (value) {
                              pageAmounts[site] = int.tryParse(value) ?? 0;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: jnjRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm',
                style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
