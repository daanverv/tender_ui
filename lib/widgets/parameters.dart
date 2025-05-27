
import 'package:flutter/material.dart';
import 'package:tender_ui/widgets/page_amount.dart';
import 'package:tender_ui/widgets/scrape_interval.dart';
import 'package:tender_ui/widgets/settings.dart';

const Color jnjRed = Color(0xFFD71920);

class Parameters extends StatelessWidget {
  const Parameters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Parameters'),
        backgroundColor: jnjRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard('Set scrape interval', Icons.timer, context),
            const SizedBox(height: 20),
            _buildCard('Set amount pages', Icons.pages, context),
            const SizedBox(height: 20),
            _buildCard('Settings', Icons.settings, context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: jnjRed),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: jnjRed,
                fontWeight: FontWeight.bold,
              ),
        ),
        onTap: () {
          if (title == 'Set scrape interval') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ScrapeIntervalScreen()));
          } else if (title == 'Set amount pages') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PageAmountScreen()));
          } else if (title == 'Settings') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }
        }
      ),
    );
  }
}
