import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tender_ui/env.dart';
import 'package:tender_ui/models/website.dart';
import 'package:tender_ui/services/scrape_api_service.dart';
import 'package:tender_ui/services/website_service.dart';

const Color jnjRed = Color(0xFFD71920);

class ScrapeLauncher extends StatefulWidget {
  const ScrapeLauncher({super.key});

  @override
  State<ScrapeLauncher> createState() => _ScrapeLauncherState();
}

class _ScrapeLauncherState extends State<ScrapeLauncher> {
  int? selectedWebsiteId;
  bool isLoading = false;
  List<String> tenderIds = [];
  List<Website> websites = [];
  Timer? pollingTimer;

  String? debugMessage;
  String? lastRawResponse;

  @override
  void initState() {
    super.initState();
    _loadWebsites();
  }

  @override
  void dispose() {
    pollingTimer?.cancel();
    super.dispose();
  }

  void _loadWebsites() async {
    try {
      final fetchedWebsites = await WebsiteService.fetchWebsites();
      setState(() {
        websites = fetchedWebsites;
      });
    } catch (e) {
      _showError('Failed to load websites: $e');
    }
  }

  void _startPolling(int websiteId) {
    pollingTimer?.cancel();
    pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final updates = await ScrapeApiService.getTenderUpdates(websiteId);
        setState(() {
          tenderIds = updates;
          debugMessage = null;
          lastRawResponse = updates.toString();
        });
      } catch (e) {
        setState(() {
          debugMessage = 'Polling error: $e';
        });
      }
    });
  }

  void _onScrapePressed() async {
    if (selectedWebsiteId == null) {
      _showError('Please select a website.');
      return;
    }

    final selectedWebsite = websites.firstWhere((w) => w.id == selectedWebsiteId);

    setState(() {
      isLoading = true;
      tenderIds.clear();
      debugMessage = null;
      lastRawResponse = null;
    });

    try {
      final scrapedTenders = await ScrapeApiService.scrapeSite(selectedWebsite.name);
      setState(() {
        isLoading = false;
        tenderIds = scrapedTenders;
        lastRawResponse = scrapedTenders.toString();
      });
      _startPolling(selectedWebsite.id);
    } catch (e) {
      _showError('Failed to scrape: $e');
    }
  }

  void _showError(String message, {bool showInUI = false}) {
    setState(() {
      isLoading = false;
      debugMessage = showInUI ? message : 'Scraped site -- look for logs for details -- Probably it stumbled on a tender that was already scraped and it stopped executing';
    });

    if (showInUI) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    debugPrint("Error: $message");
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
      title: const Text('Scrape Launcher'),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Website to Scrape',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: jnjRed,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Website',
              ),
              value: selectedWebsiteId,
              items: websites.map((website) {
              final lastScraped = website.lastScrapedAt != null
                  ? 'Last scraped at: ${_formatDate(website.lastScrapedAt!)}'
                  : 'Never scraped';

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
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: jnjRed,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading ? null : _onScrapePressed,
                  icon: const Icon(Icons.search),
                  label: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Scrape',
                          style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.go('/add_website'); 
                  },
                  icon: const Icon(Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text('Add Website',
                  style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (tenderIds.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: tenderIds.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Tender ID: ${tenderIds[index]}'),
                    );
                  },
                ),
              ),
            if (debugMessage != null || lastRawResponse != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (debugMessage != null)
                      Text(
                        'Error: $debugMessage',
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (lastRawResponse != null)
                      Text(
                        'Last Response: $lastRawResponse',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
