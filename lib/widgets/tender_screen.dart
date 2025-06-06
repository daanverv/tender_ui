import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tender_ui/services/tender_service.dart';
import 'package:tender_ui/services/website_service.dart';
import 'package:tender_ui/widgets/upload_excel.dart';
import '../widgets/tender_widget.dart';
import '../models/tender.dart';
import '../models/website.dart';

const Color jnjRed = Color(0xFFD71920);

class TenderScreen extends StatefulWidget {
  const TenderScreen({super.key});

  @override
  State<TenderScreen> createState() => _TenderScreenState();
}

class _TenderScreenState extends State<TenderScreen> {
  int? selectedWebsiteId;
  bool isLoading = false;
  String? resultMessage;
  List<Tender> tenderResults = [];
  List<Website> websites = [];

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

  String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
         '${date.month.toString().padLeft(2, '0')}/'
         '${date.year}';
}

  void _overviewResult() {
    if (selectedWebsiteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a website.')),
      );
      return;
    }

    context.push('/tender_overview?websiteId=$selectedWebsiteId');

    return;
  }

  void _onSeeResultsPressed() async {
    if (selectedWebsiteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a website.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      resultMessage = null;
      tenderResults.clear();
    });

    try {
      final tenders = await GetTenders.fetchTenders(selectedWebsiteId!);
      setState(() {
        isLoading = false;
        tenderResults = tenders;
        resultMessage = 'Retrieved ${tenders.length} tenders for this website';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        resultMessage = 'Failed to load tenders: $e';
      });
    }
  }

  String? get selectedWebsiteName {
  return websites.firstWhere(
    (w) => w.id == selectedWebsiteId,
    orElse: () => Website(id: 0, name: '', lastScrapedAt: null),
  ).name;
}

@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 800;

  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      title: const Text('Scrape Results'),
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
            'Select a website to see scraped results',
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
              final lastScraped = website.lastScrapedAt != null
                  ? _formatDate(website.lastScrapedAt!)
                  : 'Never';

              return DropdownMenuItem<int>(
                value: website.id,
                child: Text.rich(
                  TextSpan(
                    text: website.name,
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '  •  $lastScraped',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

              );
            }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedWebsiteId = value;
                });
              },
            ),
            const SizedBox(height: 24),
           if (tenderResults.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: jnjRed,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading ? null : _onSeeResultsPressed,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    'See Results',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: jnjRed,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading ? null : _onSeeResultsPressed,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    'Sort by ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: jnjRed,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading ? null : _overviewResult,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    'Overview',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Download Tenders'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.code),
                              title: const Text('Download as JSON'),
                              onTap: () {
                                Navigator.pop(context);
                                //_downloadAsJson();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.picture_as_pdf),
                              title: const Text('Download as PDF'),
                              onTap: () {
                                Navigator.pop(context);
                                //_downloadAsPdf();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.description),
                              title: const Text('Download as Word'),
                              onTap: () {
                                Navigator.pop(context);
                                //_downloadAsWord();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text(
                    'Download Tenders',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          else
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: jnjRed,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isLoading ? null : _onSeeResultsPressed,
              icon: const Icon(Icons.search),
              label: const Text(
                'See Results',
                style: TextStyle(color: Colors.white),
              ),
            ),
 
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (resultMessage != null) Text(resultMessage!),
            const SizedBox(height: 20),
            if (tenderResults.isNotEmpty)
              ...tenderResults.map((tender) => TenderWidget(tender: tender)).toList(),
          ],
        ),
      ),
    );
  }
}
