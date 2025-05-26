import 'package:intl/intl.dart';

class Website {
  final int id;
  final String name;
  final DateTime? lastScrapedAt;

  Website({
    required this.id,
    required this.name,
    this.lastScrapedAt,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['last_scraped_at'] != null) {
      try {
        parsedDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz').parse(json['last_scraped_at'], true).toLocal();
      } catch (e) {
        print('Date parsing error: $e');
      }
    }

    return Website(
      id: json['id'],
      name: json['name'],
      lastScrapedAt: parsedDate,
    );
  }
}
