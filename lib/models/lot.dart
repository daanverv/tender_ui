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
  String getValue(List<String> keys) {
    for (var key in keys) {
      if (json.containsKey(key) && json[key] != null) {
        return json[key].toString();
      }
    }
    return '';
  }

  return Lot(
    lotId: getValue(['lot_id', 'cig_code']),
    lotName: getValue(['lot_name', 'nome_lotto', 'name']),
    sintelId: getValue(['sintel_id']),
    procedureType: getValue(['procedure_type', 'tipo']),
    status: getValue(['procedure_status', 'stato', 'status']),
    categories: getValue(['merchandise_categories', 'categorie_merceologiche', 'categories']),
    economicValue: getValue(['economic_value', 'valore_economico', 'value']),
    startDate: getValue(['offer_start_date', 'data_inizio', 'start_date']),
    endDate: getValue(['offer_end_date', 'data_fine', 'end_date']),
    attachments: json['attachments'] is List
        ? (json['attachments'] as List).map((e) => e.toString()).join(', ')
        : json['attachments']?.toString() ?? '',
  );
}

}