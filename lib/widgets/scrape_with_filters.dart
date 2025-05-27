import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tender_ui/services/website_service.dart';
import 'package:tender_ui/models/website.dart';
import 'package:tender_ui/widgets/lazio_filter_page.dart';
import 'package:tender_ui/widgets/lombardia_filter_page.dart';
import 'package:tender_ui/widgets/marche_filter_page.dart';

const Color jnjRed = Color(0xFFD71920);

class ScrapeWithFilterPage extends StatefulWidget {
  const ScrapeWithFilterPage({super.key});

  @override
  State<ScrapeWithFilterPage> createState() => _ScrapeWithFilterPageState();
}

class _ScrapeWithFilterPageState extends State<ScrapeWithFilterPage> {
  int? selectedWebsiteId;
  List<Website> websites = [];
  bool isLoading = false;
  String? message;

  @override
  void initState() {
    super.initState();
    _loadWebsites();
  }

  void _loadWebsites() async {
    try {
      final fetchedWebsites = await WebsiteService.fetchWebsites();
      setState(() {
        websites = fetchedWebsites;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load websites: $e')),
      );
    }
  }

  void _onWebsiteSelected(int? websiteId) {
    setState(() {
      selectedWebsiteId = websiteId;
      message = null;
    });
  }

  String? _getWebsiteNameById(int id) {
  return websites.firstWhere((w) => w.id == id, orElse: () => Website(id: id, name: 'Unknown')).name;
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      title: const Text('Apply Filters'),
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
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a website to apply filters',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: jnjRed,
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 24),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Website',
            ),
            value: selectedWebsiteId,
            items: websites.map((website) {
              return DropdownMenuItem<int>(
                value: website.id,
                child: Text(website.name),
              );
            }).toList(),
            onChanged: _onWebsiteSelected,
          ),
          const SizedBox(height: 24),

          // 🔽 Placeholder for filter UI
          if (selectedWebsiteId != null)
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Card(
              key: ValueKey(selectedWebsiteId),
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gradient header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [jnjRed.withOpacity(0.9), jnjRed.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Text(
                      'Filters for ${_getWebsiteNameById(selectedWebsiteId!)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customize your filters for this website.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.tune),
                            label: Text('Open Filters'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: jnjRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          onPressed: () {
                          final websiteName = _getWebsiteNameById(selectedWebsiteId!);
                          if (websiteName == 'Lombardia') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LombardiaFilterPage()),
                            );
                          } else if (websiteName == 'Lazio') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LazioFilterPage()),
                            );
                          } else if (websiteName == 'Marche') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MarcheFilterPage()),
                            );
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No filter page available for $websiteName')),
                            );
                          }
                        },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      
          const SizedBox(height: 20),
          if (message != null) Text(message!),
        ],
      ),
    ),
    );
  }
}
