import 'package:tender_ui/models/lot.dart';

class Tender {
  final String provider;
  final String tenderId;
  final String economicValue;
  final String offerStartDate;
  final String offerEndDate;
  final String procedureStatus;
  final Map<String, dynamic> content;
  final List<dynamic> attachments;
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
      provider: json['provider'] ?? '',
      tenderId: json['tender_id'] ?? '',
      economicValue: json['economic_value'] ?? '',
      offerStartDate: json['offer_start_date'] ?? '',
      offerEndDate: json['offer_end_date'] ?? '',
      procedureStatus: json['procedure_status'] ?? '',
      content: Map<String, dynamic>.from(json['content'] ?? {}),
      attachments: List<String>.from(json['attachments'] ?? []),
      links: List<String>.from(
        (json['links'] ?? []).map((e) =>
          e is Map && e.containsKey('url') ? e['url'] : e.toString(),
        ),
      ),
      lots: (json['lots'] ?? []).map<Lot>((lotJson) =>
        Lot.fromJson(Map<String, dynamic>.from(lotJson))
      ).toList(),
      websiteId: json['website_id'] ?? 0,
      uniqueTenderKey: json['unique_tender_key'] ?? '',
    );
  }
}