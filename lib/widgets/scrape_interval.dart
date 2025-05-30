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
  final Map<String, TimeOfDay> selectedTimes = {};
  final Map<String, Set<String>> selectedDays = {};
  final Map<String, String> selectedWeeks = {};

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
      final time = selectedTimes[site];
      final days = selectedDays[site];
      final week = selectedWeeks[site];

      debugPrint('Site: $site, Unit: $unit');
      if (unit == 'Hours') {
        debugPrint('  Interval: $interval');
        debugPrint('  Time: ${time?.format(context)}');
      } else if (unit == 'Days') {
        debugPrint('  Days: ${days?.join(', ')}');
      } else if (unit == 'Weeks') {
        debugPrint('  Week: $week');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scrape intervals saved successfully!')),
    );
  }

 Widget _buildAllIntervalOptions(String site) {
  selectedDays.putIfAbsent(site, () => <String>{});

  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final weeks = ['1st', '2nd', '3rd', '4th', 'Last'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Hours
      Text('Hourly Interval', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(
        height: 5,
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: jnjRed,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onPressed: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: selectedTimes[site] ?? TimeOfDay.now(),
          );
          if (time != null) {
            setState(() {
              selectedTimes[site] = time;
            });
          }
        },
        child: Text(selectedTimes[site] != null
            ? 'Time: ${selectedTimes[site]!.format(context)}'
            : 'Pick Time', style: TextStyle(color: Colors.white)),
      ),
      TextField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Interval (in hours)'),
        onChanged: (value) {
          intervals[site] = int.tryParse(value) ?? 0;
        },
      ),
      const SizedBox(height: 16),

      // Days
      Text('Days of the Week', style: TextStyle(fontWeight: FontWeight.bold)),
      Wrap(
        spacing: 8,
        children: days.map((day) {
          final isSelected = selectedDays[site]!.contains(day);
          return FilterChip(
            label: Text(day),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedDays[site]!.add(day);
                } else {
                  selectedDays[site]!.remove(day);
                }
              });
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 16),

      // Weeks
      Text('Week of the Month', style: TextStyle(fontWeight: FontWeight.bold)),
      DropdownButton<String>(
        hint: const Text('Select Week'),
        value: selectedWeeks[site],
        items: weeks.map((week) {
          return DropdownMenuItem(value: week, child: Text(week));
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedWeeks[site] = value!;
          });
        },
      ),
    ],
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
                          Text(site, style: const TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 20)),
                          const SizedBox(height: 8),
                          _buildAllIntervalOptions(site),
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
                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
