import 'package:tender_ui/models/lot.dart';

class Tender {
  final String provider;
  final String tenderId;
  final String economicValue;
  final String offerStartDate;
  final String offerEndDate;
  final String procedureStatus;
  final Map<String, dynamic> content;
  final List<String> attachments;
  final List<String> links;
  final List<Lot> lots;
  final int websiteId;
  final String uniqueTenderKey;

  Tender({
    required this.provider,
    required this.tenderId,
    required this.economicValue,
    required this.offerStartDate,
    required this.offerEndDate,
    required this.procedureStatus,
    required this.content,
    required this.attachments,
    required this.links,
    required this.lots,
    required this.websiteId,
    required this.uniqueTenderKey,
  });

  factory Tender.fromJson(Map<String, dynamic> json) {
  return Tender(
    provider: json['provider']?.toString() ?? '',
    tenderId: json['tender_id']?.toString() ?? '',
    economicValue: json['economic_value']?.toString() ?? '',
    offerStartDate: json['offer_start_date']?.toString() ?? '',
    offerEndDate: json['offer_end_date']?.toString() ?? '',
    procedureStatus: json['procedure_status']?.toString() ?? '',
    content: Map<String, dynamic>.from(json['content'] ?? {}),
    attachments: (json['attachments'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    links: (json['links'] as List<dynamic>? ?? [])
        .map((e) => e is Map && e.containsKey('url') ? e['url'].toString() : e.toString())
        .toList(),
    lots: (json['lots'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((lotJson) => Lot.fromJson(lotJson))
        .toList(),
    websiteId: json['website_id'] ?? 0,
    uniqueTenderKey: json['unique_tender_key']?.toString() ?? '',
  );
}
}
