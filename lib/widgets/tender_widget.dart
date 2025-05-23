import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tender.dart';

class TenderWidget extends StatelessWidget {
  final Tender tender;

  const TenderWidget({super.key, required this.tender});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tender id: ${tender.tenderId}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Provider: ${tender.provider}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              'Economic Value: ${tender.economicValue}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            if (tender.content.isNotEmpty) ...[
              Text(
                'Procedure Details:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                tender.content['procedure_name'] ?? 'No procedure name',
                style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              Text(
                'Code: ${tender.content['tender_code'] ?? 'N/A'}',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
              ),
              Text(
                'Authority: ${tender.content['contracting_authority'] ?? 'N/A'}',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 10),
            ],
            if (tender.lots.isNotEmpty) ...[
              Text(
                'Lots:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Column(
                children: tender.lots.map((lot) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lot.lotName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        if (lot.sintelId.isNotEmpty) Text('Sintel ID: ${lot.sintelId}'),
                        if (lot.lotId.isNotEmpty) Text('CIG: ${lot.lotId}'),
                        if (lot.status.isNotEmpty) Text('Status: ${lot.status}'),
                        if (lot.procedureType.isNotEmpty) Text('Procedure Type: ${lot.procedureType}'),
                        if (lot.categories.isNotEmpty) Text('Categories: ${lot.categories}'),
                        if (lot.economicValue.isNotEmpty) Text('Value: ${lot.economicValue}'),
                        if (lot.startDate.isNotEmpty && lot.endDate.isNotEmpty)
                          Text('Dates: ${lot.startDate} → ${lot.endDate}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}