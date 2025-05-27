import 'package:flutter/material.dart';
import 'package:tender_ui/services/website_service.dart';

const Color jnjRed = Color(0xFFD71920);

class ScrapeIntervalScreen extends StatefulWidget {
  const ScrapeIntervalScreen({Key? key}) : super(key: key);

  @override
  State<ScrapeIntervalScreen> createState() => _ScrapeIntervalScreenState();
}

class _ScrapeIntervalScreenState extends State<ScrapeIntervalScreen> {
  List<String> websites = [];
  final Map<String, int> intervals = {};
  final Map<String, String> units = {};

  final List<String> timeUnits = ['Hours', 'Days', 'Weeks'];

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
      final interval = intervals[site];
      final unit = units[site];
      debugPrint('Site: $site, Interval: $interval, Unit: $unit');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scrape intervals saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Set Scrape Interval'),
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
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Interval'),
                                  onChanged: (value) {
                                    intervals[site] = int.tryParse(value) ?? 0;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton<String>(
                                value: units[site],
                                hint: const Text('Unit'),
                                items: timeUnits.map((unit) {
                                  return DropdownMenuItem(value: unit, child: Text(unit));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    units[site] = value!;
                                  });
                                },
                              ),
                            ],
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
                style: TextStyle(color: Colors.white),)
                ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
