class Lot {
  final String lotId;                  // "CIG"
  final String lotName;                // "NOME LOTTO"
  final String sintelId;               // "ID SINTEL"
  final String procedureType;          // "TIPO PROCEDURA" (if included)
  final String status;                 // "STATO"
  final String categories;             // "CATEGORIE MERCEOLOGICHE"
  final String economicValue;          // "VALORE ECONOMICO"
  final String startDate;              // "DATA INIZIO"
  final String endDate;                // "DATA FINE"
  final String attachments;            // "ALLEGATI" (optional)

  Lot({
    required this.lotId,
    required this.lotName,
    required this.sintelId,
    required this.procedureType,
    required this.status,
    required this.categories,
    required this.economicValue,
    required this.startDate,
    required this.endDate,
    required this.attachments,
  });

  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
      lotId: json['lot_id'] ?? json['cig_code'] ?? '',
      lotName: json['lot_name'] ?? json['name'] ?? '',
      sintelId: json['sintel_id'] ?? '',
      procedureType: json['procedure_type'] ?? '',
      status: json['procedure_status'] ?? json['status'] ?? '',
      categories: json['merchandise_categories'] ?? json['categories'] ?? '',
      economicValue: json['economic_value'] ?? json['value'] ?? '',
      startDate: json['offer_start_date'] ?? json['start_date'] ?? '',
      endDate: json['offer_end_date'] ?? json['end_date'] ?? '',
      attachments: json['attachments'] ?? '',
    );
  }
}